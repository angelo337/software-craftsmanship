# Encapsulate Downcast

## Intent
Make a method return the most specific type it really returns, so callers stop casting its result to a narrower type.

## Use when
- Callers repeatedly cast the result (`(Reading) list.last()`, `cast(Reading, x)`, `as Reading`).
- A method returns a generic base type (`Object`, `Any`, `object`, untyped collection element) but always produces a specific type.
- A wrapper around a collection exposes the collection and forces callers to downcast elements.

## Don't use when
- The method truly returns different types depending on state; use polymorphism, a union return type, or generics instead.
- Narrowing would violate the contract of an overridden method (covariant returns must still honor the superclass contract).
- The language gives you generics and you can fix the type at the source instead of casting inside.

## Mechanics
1. Find call sites that cast the method's return value.
2. Move the cast into the method and narrow the declared return type.
3. If the method hands out a collection or iterator, give the owner class intention-revealing methods (`last_reading()`) instead (Encapsulate Collection), then do the cast in one place.
4. Remove casts at call sites; run tests and the type checker.

## Example (Python)
```python
# Before
class Site:
    def __init__(self):
        self.readings = []              # list of Any

    def last(self):
        return self.readings[-1]

r = cast(Reading, site.last())          # every caller casts

# After
class Site:
    def __init__(self):
        self._readings: list[Reading] = []

    def last_reading(self) -> Reading:
        return self._readings[-1]

r = site.last_reading()
```

## Language notes
- Python: use type annotations and generics (`list[Reading]`, `TypeVar`) so checkers infer the type; `typing.cast` is the escape hatch to avoid at call sites.
- TypeScript: generics and type guards (`x is Reading`) reduce `as` assertions; return the specific type from the method.
- Java: generics (since Java 5) remove most casts; covariant return types allow a subclass override to narrow its type.
- C#: generics, `OfType<T>()`, covariant returns (C# 9) on overrides.
- Go: generics (1.18+) or return a concrete type instead of `interface{}`/`any`.

## Related
- Encapsulate Collection, Move Method, Replace Constructor with Factory Method (returning concrete types).
- Smells: Message Chains, Primitive Obsession, Inappropriate Intimacy with the collection.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 250.
