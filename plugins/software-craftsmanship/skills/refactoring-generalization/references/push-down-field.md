# Push Down Field

## Intent
Move a field that only some subclasses use out of the superclass into those subclasses.

## Use when
- A base-class attribute is meaningless (always None/unused) for part of the hierarchy.
- You are finishing Extract Subclass after pushing down the methods that use the field.

## Don't use when
- Some code that every subclass inherits still reads it: push the methods down first (or replace the conditional with polymorphism).
- Most subclasses use it.

## Mechanics
1. Declare the field in every subclass that uses it.
2. Remove it from the superclass; run tests.
3. Remove it from subclasses that turn out not to need it; run tests.
If step 2 breaks a method, treat that as a sign to push that method down too.

## Example (Python)
Before:
```python
class Item:
    def __init__(self, qty, employee=None):
        self.qty = qty; self.employee = employee   # labor only
```
After:
```python
class Item:
    def __init__(self, qty): self.qty = qty
class LaborItem(Item):
    def __init__(self, qty, employee):
        super().__init__(qty); self.employee = employee
```

## Language notes
- Python: attributes live per instance, so "pushing down" means moving the assignment into the subclass `__init__`; class-level declarations and `__slots__` must move too.
- TypeScript/Java/C#: move the declaration; adjust constructors.
- Go: move the field from the embedded base struct into the specific struct.

## Related
Push Down Method, Extract Subclass, Pull Up Field (inverse). Smells: Refused Bequest, Temporary Field.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 267-268.
