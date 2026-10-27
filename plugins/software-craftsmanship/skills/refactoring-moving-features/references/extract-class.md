# Extract Class

## Intent
Split a class that does two jobs into two cohesive classes by moving the related data and behavior into a new one.

## Use when
- A class is large and a subset of its fields and methods clearly go together.
- Some data changes together or depends on other data in the group.
- Deleting one field would make a group of other fields and methods meaningless.
- Subtyping affects only part of the class, or different features need different subtypes.

## Don't use when
- There is no cohesive cluster; you would just scatter code.
- The extracted piece would need constant two-way access to the original (a sign of wrong seam).
- You need atomic updates across both parts and would have to add locking or transactions you cannot afford.

## Mechanics
1. Decide how to split responsibilities; rename the original if its name no longer fits.
2. Create the new class.
3. Link old to new (add the back-link only if needed).
4. Move Field for each field in the group; test after each.
5. Move Method, lowest-level (called) methods first, then callers; test after each.
6. Review both interfaces; remove the back-link if possible.
7. Decide whether to expose the new class to clients, and if so whether as a shared reference object or an immutable value object (to avoid surprising aliasing).

## Example (Python)
```python
# before
class Person:
    def __init__(self, name, area, number):
        self.name, self.area, self.number = name, area, number
    def phone(self): return f"({self.area}) {self.number}"
# after
class Phone:
    def __init__(self, area, number): self.area, self.number = area, number
    def __str__(self): return f"({self.area}) {self.number}"
class Person:
    def __init__(self, name, phone): self.name, self.phone = name, phone
```

## Language notes
- Python: `@dataclass(frozen=True)` makes the extracted class an immutable value, avoiding aliasing bugs. Use `__getattr__` forwarding sparingly.
- Java/C#: records / init-only types serve the same purpose. IDEs: IntelliJ "Extract Delegate/Extract Class", Eclipse "Extract Class", Rider/ReSharper "Extract Class". PyCharm and VS Code lack a full automated version; do it by steps.
- TS: extract to a class or plain type plus functions. Go: extract a new struct and embed or hold it.
- Splitting also lets concurrent code lock the parts separately.

## Related
Inline Class (the inverse), Move Field, Move Method, Replace Data Value with Object, Change Value to Reference. Smells: Large Class, Divergent Change, Data Clumps.

## Source
Fowler et al. (1999), Chapter 7 (Extract Class).
