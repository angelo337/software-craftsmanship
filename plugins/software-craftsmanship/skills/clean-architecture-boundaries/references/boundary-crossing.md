# Boundary Crossing

## Core statement
Crossing a boundary is a call plus data. What matters is the direction of source
dependencies, always toward the higher-level side, whatever the physical form: source
modules in a monolith, deployable components, local processes, or services.

## Symptoms
- Core code contains hostnames, URIs, process names, or registry keys of lower-level pieces.
- Chatty calls designed for in-process cost are used across a network.
- ORM entities or HTTP request objects flow into business code.
- A change in a data class forces rebuilds on the wrong side of the line.
- Threads are described as "architectural boundaries".

## How to apply
1. Identify which form each line takes: source-level, deployment-level, local process, service.
2. Calls toward the higher level need nothing special; calls toward the lower level
   need an interface owned by the caller, with a runtime implementation injected.
3. Define the data structure on the side being called (inbound) or the calling side
   when inverted; it belongs to the inner side either way.
4. Pass plain structures only; map rows, entities, and request objects at the edge.
5. Budget chattiness: in-process cheap, process moderate, service expensive (batch calls).
6. Keep locations (URIs, paths) in Main or configuration, never in the high-level code.
7. Expect mixes: a service may be a facade over processes made of components.

## Example (TypeScript)
```ts
// inner side owns the shape and the port
export interface PriceQuote { sku: string; cents: number }
export interface PriceSource { quote(sku: string): Promise<PriceQuote> }

export async function total(src: PriceSource, skus: string[]) {
  const quotes = await Promise.all(skus.map(s => src.quote(s)));
  return quotes.reduce((a, q) => a + q.cents, 0);
}

// outer side: detail maps its own payload to the plain shape
export const httpSource = (base: string): PriceSource => ({
  async quote(sku) {
    const r = await (await fetch(`${base}/p/${sku}`)).json();
    return { sku, cents: Math.round(r.price * 100) };
  },
});
```

## Language notes
- Dynamic polymorphism (interfaces, protocols, duck typing) is the usual tool; static
  polymorphism (generics, templates) does not avoid recompilation.
- Without polymorphism, function pointers or callbacks work but are riskier.
- Python: dataclasses or TypedDict for crossing data. TypeScript: readonly interfaces.

## Common over-application
- Splitting a monolith into processes to "have boundaries"; source-level lines already count.
- Serializing and marshaling data inside one process for no reason.
- Wrapping trivial primitives in DTOs when nothing detail-specific is leaking.

Source: Martin (2017), Ch. 18.
