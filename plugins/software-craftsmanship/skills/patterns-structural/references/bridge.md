# Bridge (Handle/Body)

## Intent
Split an abstraction from its implementation into two hierarchies connected by composition, so each can vary and be extended independently.

## Use when
- Class names multiply as a product of two axes: `PdfInvoice`, `HtmlInvoice`, `PdfReceipt`, `HtmlReceipt`; adding one value on either axis means N new classes.
- The implementation must be chosen or swapped at runtime (storage backend, renderer, platform driver).
- Client code is cluttered with `if platform == ...` branches or instantiates platform-specific subclasses.
- You need to change an implementation without recompiling or redeploying clients (stable ABI / public API with hidden internals).
- Several abstractions should share one implementation object.

## Don't use when / cheaper alternative
- Only one implementation exists and no second is planned: a plain class (optionally an interface later). A one-implementation split is useful only to hide internals from clients.
- Only one axis varies: use inheritance or Strategy.
- You are fitting an already-existing incompatible class: Adapter.
- A simple parameter or callback covers the variation.

## Participants & structure
Abstraction (high-level operations, holds an Implementor), RefinedAbstraction (extends it), Implementor (interface of primitive operations; need not mirror the Abstraction's), ConcreteImplementor (one per variant).

```
Abstraction <|-- RefinedAbstraction
Abstraction --has-a--> Implementor <|-- ConcreteImplementorA/B
```
Abstraction implements its operations by calling Implementor primitives.

## Consequences
- Implementation is not bound at compile time; can be configured or swapped at runtime.
- Both hierarchies extend independently; adding a variant costs one class, not a row of them.
- Hides implementation details (including sharing and ref-counting) from clients.
- Adds indirection and an extra interface to design; designing the right primitive operations is the hard part.

## Implementation tips
- Make the Implementor interface small and primitive; let the Abstraction compose higher-level behavior from it.
- Choose the implementor in the constructor from parameters, switch later by usage (e.g. list vs hash table by size), or inject it via a factory so the abstraction never names a concrete class.
- Multiple inheritance is not a bridge: it binds the pairing statically.
- Constructor injection is the idiomatic wiring in all languages.

## Language mapping
- Python: pass the implementor (or a Protocol-typed object) into `__init__`; duck typing removes the need for a formal interface class.
- TypeScript/JavaScript: constructor takes an object satisfying an `interface`; plain objects or classes both work.
- Java: abstract class/interface for Implementor; Abstraction holds a field. JDBC `Driver` and SLF4J-style facades over loggers show the idea.
- C#: same, usually wired through dependency injection (`IRenderer` injected into `Report`).
- Go: Abstraction struct with an interface field; no inheritance, so "refined abstractions" are just other structs embedding or wrapping it.

## Example (TypeScript)
```ts
interface Renderer { line(x1:number,y1:number,x2:number,y2:number): void }
class Shape {
  constructor(protected r: Renderer) {}
}
class Box extends Shape {
  constructor(r: Renderer, private w: number, private h: number) { super(r); }
  draw() {
    this.r.line(0,0,this.w,0); this.r.line(this.w,0,this.w,this.h);
    this.r.line(this.w,this.h,0,this.h); this.r.line(0,this.h,0,0);
  }
}
// new Box(new SvgRenderer(), 4, 2); new Box(new CanvasRenderer(), 4, 2)
```

## Related patterns
Adapter (post-hoc fix with similar structure). Abstract Factory (can build and configure a bridge, choosing the implementor). Strategy (similar wiring, but swaps one algorithm rather than a whole implementation hierarchy).

## Source
Gamma et al., 1995, Design Patterns, p. 151.
