# Encapsulate Field

## Intent
Make a public field private and expose it through accessors so the owner controls how its data is read and changed.

## Use when
- Other classes read or assign a public field directly.
- You need validation, derived values, or a place to put behavior near the data.

## Don't use when
- The class is a deliberate plain record with no invariants (a DTO, a Python dataclass): public fields are fine there.
- In Python, a plain public attribute can become a property later without breaking callers, so do it only when you need logic.

## Mechanics
1. Create getter and setter for the field.
2. Find every outside user; replace reads with the getter and assignments with the setter. If a client calls a modifier on the object held in the field, that is a read.
3. Test after each change.
4. Make the field private once no direct users remain.
5. Test, then look for behavior in the clients that belongs in this class and Move Method it.

## Example (Python)
```python
# before
class Person:
    def __init__(self, name): self.name = name

# after: same call syntax for clients, now controlled
class Person:
    def __init__(self, name): self._name = name
    @property
    def name(self): return self._name
    @name.setter
    def name(self, value):
        if not value.strip(): raise ValueError("name required")
        self._name = value
```

## Language notes
- Python: `@property` keeps `obj.name` syntax; consider read-only (no setter) first.
- TypeScript: `private`/`#field` plus `get`/`set`; Java: private field with getters; C#: properties with `{ get; private set; }` or `init`.
- Go: lowercase field names are unexported; provide methods.
- Prefer omitting the setter when the field never changes after construction.

## Related refactorings and smells
- Encapsulate Collection, Self Encapsulate Field, Move Method, Remove Setting Method.
- Smell: Data Class (often what remains afterward; follow with Move Method).

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Encapsulate Field". Page numbers were not reliably visible in the text extract.
