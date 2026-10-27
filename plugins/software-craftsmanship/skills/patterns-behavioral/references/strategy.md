# Strategy

**Intent.** Define a family of interchangeable algorithms behind one interface, so each can be selected or swapped independently of the code that uses it.

## Use when (code signals)
- `if/elif/switch` on a "type" or "mode" that picks among algorithms (sorting, pricing, compression, routing, validation, retry/backoff).
- Several classes differ only in one behavior, tempting inheritance.
- Algorithm needs data the client should not see; or you want to test algorithms in isolation.
- Callers need to choose or swap behavior at runtime.

## Don't use when
- One algorithm and no foreseeable second: YAGNI.
- A language function parameter does it: pass a function, no class needed.
- The behavior depends on the object's own lifecycle and switches itself: that is State.
- Variations are tiny parameters (a number, a flag): use configuration.

## Participants & structure
Strategy (common interface) ; ConcreteStrategies ; Context (holds a strategy, delegates, may pass itself or data).
```
Context.compute(data) -> strategy.apply(data)
```

## Consequences
+ Families of algorithms; replaces subclassing and conditionals; runtime swap.
- Clients must know the differences to pick one.
- Interface must serve all strategies (some get unused params).
- More objects, unless strategies are stateless (share them).

## Implementation tips
- Keep the interface minimal; pass the data in, not the whole context, to limit coupling.
- Provide a sensible default strategy so the context works without configuration.
- Make strategies stateless to share and reuse them safely.
- Register strategies in a dict/map keyed by name for config-driven selection.

## Language mapping
- Python/JS/TS: a first-class function (`sorted(key=...)`, `arr.sort(cmp)`). Class only when it needs state.
- Java: functional interface + lambda (`Comparator`). C#: `Func<>`/delegate, `IComparer<T>`. Go: `func` type or small interface (`sort.Interface`, `http.Handler`).

## Example (Python)
```python
PRICING = {
    "regular": lambda p: p,
    "member":  lambda p: p * 0.9,
    "bulk":    lambda p: p * 0.8 if p > 1000 else p,
}
def total(price, tier="regular"):
    return PRICING[tier](price)
```

## Related
State (same structure, different intent), Template Method (inheritance versus delegation), Flyweight (share stateless strategies), Command (what versus how), Decorator (changes skin, Strategy changes guts).

## Source
Gamma et al., 1995, p. 315.
