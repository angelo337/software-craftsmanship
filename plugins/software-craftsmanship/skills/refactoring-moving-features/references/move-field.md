# Move Field

## Intent
Put a piece of state in the class that uses it most, so data and the code that reads it live together.

## Use when
- More methods in another class read or write the field than in its own class (directly or via accessors).
- You are in the middle of Extract Class: fields move first, methods follow.
- The value really varies per target object, not per source (for example, a rate per account type rather than per account).

## Don't use when
- Methods that use it fit well where they are; consider moving those methods instead.
- The value is genuinely per-instance in the source; moving it would force sharing or duplication.
- You cannot reach the target from the source without introducing an awkward link.

## Mechanics
1. If the field is public, encapsulate it first. If many methods touch it, consider self-encapsulating it so only accessors change.
2. Run tests.
3. Create the field plus getter/setter on the target; compile.
4. Decide how the source reaches the target (existing path or new link).
5. Remove the field from the source so the compiler/tests expose any missed access.
6. Redirect every read to the target getter and every write to the setter; check subclasses if the field was visible.
7. Run tests.

## Example (Python)
```python
# before
class Account:
    def __init__(self, kind):
        self.kind, self.rate = kind, 0.02
    def interest(self, amount, days):
        return self.rate * amount * days / 365
# after
class Kind:
    rate = 0.02
class Account:
    def __init__(self, kind): self.kind = kind
    def interest(self, amount, days):
        return self.kind.rate * amount * days / 365
```

## Language notes
- Python: properties let you redirect access without touching callers (`@property def rate(self): return self.kind.rate`) as a transitional step. Dataclass fields need removing from `__init__` too.
- TS/Java/C#: removing the field gives compile errors at each missed use. Serialization or ORM mappings may reference the field name; update them.
- Go: struct field moves require updating literals and embedded-struct promotions.
- IDEs: "Move Field" exists in IntelliJ/Eclipse/Rider; PyCharm supports moving static/class attributes.

## Related
Self Encapsulate Field, Encapsulate Field, Move Method, Extract Class. Smells: Inappropriate Intimacy, Data Clumps, Shotgun Surgery.

## Source
Fowler et al. (1999), Chapter 7 (Move Field).
