# Change Reference to Value

## Intent
Replace a small, effectively immutable shared object with a value object compared by content, removing registries and identity management.

## Use when
- The reference object is small and immutable (currency, unit, code) and the factory/registry is just friction.
- Distributed or concurrent code makes shared identity costly.
- You keep needing to ask a controller for the canonical instance.

## Don't use when
- The object is mutable and others must observe changes; value semantics would cause aliasing bugs.
- It truly represents an entity with identity (a customer with a changing address).

## Mechanics
1. Confirm the object is immutable, or can be made so by removing setters; abandon the refactoring if it cannot.
2. Define content-based equality and a matching hash from the same fields.
3. Run tests; verify two separately built instances compare equal and hash alike.
4. Optionally drop the factory and registry and make the constructor public.

## Example (Python)
```python
# before: identity comparison, registry required
class Currency:
    _all = {}
    def __init__(self, code): self.code = code
    @classmethod
    def get(cls, code): return cls._all.setdefault(code, cls(code))
assert Currency("USD") is not Currency("USD")

# after: value object
from dataclasses import dataclass

@dataclass(frozen=True)
class Currency:
    code: str

assert Currency("USD") == Currency("USD")
assert len({Currency("USD"), Currency("USD")}) == 1
```

## Language notes
- Python: frozen dataclass gives `__eq__` and `__hash__`; plain classes must define both.
- Java: override `equals` and `hashCode` together, or use a `record`.
- C#: `record`/`record struct`, or override `Equals`+`GetHashCode`.
- TypeScript: no structural `==` on objects; add an `equals()` method or compare serialized keys.
- Go: comparable structs already compare by value with `==`.

## Related refactorings and smells
- Change Value to Reference (the inverse), Replace Data Value with Object, Remove Setting Method.
- Smells: Speculative Generality in an unnecessary registry.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Change Reference to Value". Page numbers were not reliably visible in the text extract.
