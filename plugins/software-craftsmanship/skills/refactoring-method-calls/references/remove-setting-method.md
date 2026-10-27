# Remove Setting Method

## Intent
Delete the setter for a field that should be fixed at creation, so the interface states the field is immutable and nobody can change it by accident.

## Use when
- A field is given its value in the constructor and never legitimately changes (ids, creation timestamps, currency of a money value).
- Setters exist only because of habit (always going through accessors, even in constructors).
- Mutation of this field has caused aliasing or consistency bugs.

## Don't use when
- Callers legitimately update the field after construction.
- An ORM, serializer, or framework requires setters (check; many support constructor or field injection).
- The field is a collection exposed via a setter: replace it with add/remove operations instead (Encapsulate Collection).

## Mechanics
1. Run tests.
2. Confirm the setter is called only from the constructor or methods the constructor calls.
3. Change the constructor to assign the field directly.
4. Run tests.
5. Delete the setter and mark the field immutable (final/readonly/frozen).
6. If initialization needs real logic or subclasses must set a superclass field, use a superclass constructor parameter or a clearly named initialization method (`initialize_id`), never a name that looks like a setter.

## Example (Python)
```python
# Before
class Account:
    def __init__(self, acct_id):
        self.set_id(acct_id)

    def set_id(self, value):
        self._id = "AC-" + value          # also callable later by anyone

# After
@dataclass(frozen=True)
class Account:
    id: str

    def __post_init__(self):
        object.__setattr__(self, "id", "AC-" + self.id)
```
A plain-class alternative: assign `self._id` in `__init__` and expose a read-only `@property def id`.

## Language notes
- Python: `@dataclass(frozen=True)`, `NamedTuple`, `__slots__`, or a getter-only `@property`. Python cannot enforce true immutability for plain attributes, so rely on convention plus frozen dataclasses.
- TypeScript: `readonly` fields or `private readonly`; `Object.freeze` for runtime protection.
- Java: `private final` field, constructor assignment; records are immutable by default.
- C#: `get; init;` properties or `readonly` fields.
- Go: unexported fields with no setter method; construct via `New...` functions.

## Related
- Hide Method (for setters that must stay but not publicly), Encapsulate Field, Encapsulate Collection, Introduce Parameter Object (immutable by design).
- Smells: Data Class, Inappropriate Intimacy.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 243.
