# Builder (Object Creational)

## Intent
Separate the step-by-step construction of a complex object from the final representation, so one construction process (the director) can produce different results by using different builders.

## Use when (code signals)
- A constructor takes many parameters, several optional (telescoping constructors, long runs of `null`/default arguments).
- The same parsing/assembly algorithm must output different formats or object types (RTF -> text/HTML/widget; query spec -> SQL/Elasticsearch DSL).
- Objects are built in stages and must be valid only when finished (validate in a final `build()`).
- Tree/composite structures are assembled bottom-up.

## Don't use when / cheaper alternative
- Few fields: use a plain constructor.
- Optional fields only: use keyword/named arguments, default values, or an options object/record.
- Only one representation ever: a builder adds nothing but ceremony unless the sole goal is readable staged construction.
- Cheaper: a factory function with defaults; an immutable record with `copy/with` helpers.

## Participants & structure
- Builder: abstract interface with one operation per part (default no-ops so concrete builders override only what they care about).
- ConcreteBuilder: assembles parts, keeps the representation it is building, exposes a way to fetch the result.
- Director: drives the algorithm by calling builder operations in order.
- Product: the finished complex object (different builders often yield unrelated product types).

```
Client -> Director.construct(builder)
            |-- builder.build_part_a()
            |-- builder.build_part_b()
Client <- builder.get_result()
```
Collaboration: client picks and configures a concrete builder, hands it to the director, then collects the product from the builder.

## Consequences
Benefits:
- Internal representation can vary: add a new builder, leave the director untouched.
- Construction and representation code are isolated; one builder can serve many directors.
- Finer control over the process than one-shot factories; the product is retrieved only when complete.
Liabilities:
- A builder class per representation; more code than a constructor.
- Products often share no base type, so clients must know which builder they used.

## Implementation tips
- Design the builder interface general enough for every concrete builder; appending parts is usually enough, but allow access to earlier parts when needed (e.g. connect two existing rooms).
- Give default empty methods so builders can ignore irrelevant steps.
- Do not force an abstract product class; representations may differ too much.
- Modern fluent form (the "builder" without a director): chained setters ending in `build()`; validate required fields there and return an immutable product.
- Reset or recreate the builder state per product to avoid leaking data between builds.

## Language mapping
- Python: keyword arguments + `dataclass(frozen=True)` replace most builders; use a builder class only for multi-step or multi-representation work.
- TypeScript/JavaScript: options object with defaults (`{retries = 3, ...opts}`); fluent class if validation is staged.
- Java: classic static nested `Builder` with `build()` (Lombok `@Builder`, records with builders).
- C#: object initializers, `init` properties, `required` members; builder only for staged assembly (e.g. `StringBuilder`, `WebApplicationBuilder`).
- Go: functional options (`New(opts ...Option)`) or a config struct.
See [language-mapping.md](language-mapping.md).

## Short example (Python)
```python
class HtmlBuilder:                      # concrete builder
    def __init__(self): self.parts = []
    def text(self, s): self.parts.append(f"<p>{s}</p>")
    def result(self): return "".join(self.parts)

class TextBuilder:
    def __init__(self): self.parts = []
    def text(self, s): self.parts.append(s)
    def result(self): return "\n".join(self.parts)

def render(doc, builder):               # director: same steps, any builder
    for line in doc: builder.text(line)
    return builder.result()
```

## Related patterns
- Abstract Factory: also builds complex objects, but returns them immediately and stresses product families.
- Composite: the structure a builder often constructs.
- Factory Method / Prototype: one-shot creation, no staged protocol.

## Source
Gamma et al., 1995, Design Patterns, p. 97-106 (Related Patterns p. 105-106).
