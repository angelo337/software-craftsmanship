# Adapter (Wrapper)

## Intent
Convert one class's interface into the interface your clients expect, so classes with incompatible interfaces can cooperate without modifying either.

## Use when
- You call a third-party SDK, legacy module or generated client whose method names, units, or argument shapes differ from what your code expects, and you cannot (or should not) edit it.
- The same conversion code (`x.get_extent()` to bounding box, cents to decimal, camelCase to snake_case) is copy-pasted across call sites.
- You want your domain to depend on your own small interface (a port) and isolate vendor details in one class.
- You have several existing subclasses to fit to one interface: wrap the parent type once (object adapter) instead of subclassing each.

## Don't use when / cheaper alternative
- You own both sides: change the interface directly.
- Only one call site needs a one-off conversion: write a function or lambda.
- The mismatch is only a name: in dynamic languages an alias or small mapping function suffices.
- You want to add behavior, not convert: that is Decorator. You want to simplify many classes: that is Facade.

## Participants & structure
Target (interface the client wants), Client (uses Target), Adaptee (existing class with the wrong interface), Adapter (implements Target, translates calls to Adaptee).

```
Client --> Target <|-- Adapter --has-a--> Adaptee
```
Object adapter holds an Adaptee (preferred; works with its subclasses). Class adapter inherits from Adaptee as well (needs multiple inheritance; commits to one concrete class). The adapter may also supply operations the adaptee lacks.

## Consequences
- Reuses code without touching it; localizes translation in one place.
- Adds a layer; adapted objects no longer satisfy the Adaptee interface, so they are not drop-in for code expecting the original (a two-way adapter can implement both).
- Effort ranges from renaming methods to bridging entirely different operation sets; keep it thin.

## Implementation tips
- Define the narrowest Target you need (2-3 methods). A narrow interface is cheap to adapt and easy to fake in tests.
- Prefer composition (object adapter) so one adapter serves the adaptee and its subclasses.
- Pluggable adapters: let a generic component accept callbacks or a delegate for the narrow operations (e.g. `get_children`, `render`) instead of subclassing.
- Translate errors and units at the boundary too, not just method names.
- Do not leak adaptee types through the Target interface.

## Language mapping
- Python: a small class, or just a function/`functools.partial`; duck typing means you often only need to rename. `typing.Protocol` documents the Target.
- TypeScript/JavaScript: object literal or class implementing an `interface`; `adaptFoo(foo): Bar` functions are common.
- Java: class implementing the Target interface holding the Adaptee; `Arrays.asList`, `InputStreamReader` are classic adapters.
- C#: same; extension methods can adapt for convenience but cannot satisfy an interface.
- Go: define the interface at the consumer, write a struct wrapping the vendor type; or a function type with a method (`type HandlerFunc func(...)`) as a one-line adapter.

## Example (Python)
```python
class LegacyGateway:                      # cannot change
    def charge_cents(self, card, cents): ...

class Payments:                           # Target the app expects
    def pay(self, card, amount: "Decimal") -> None: ...

class GatewayAdapter(Payments):
    def __init__(self, gw: LegacyGateway): self._gw = gw
    def pay(self, card, amount):
        self._gw.charge_cents(card, int(amount * 100))
```

## Related patterns
Bridge (same shape, but designed up front to vary abstraction and implementation). Decorator (same interface, adds behavior). Proxy (same interface, controls access). Facade (new interface over many objects).

## Source
Gamma et al., 1995, Design Patterns, p. 139.
