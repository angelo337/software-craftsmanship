# Pull Up Field

## Intent
Move a field that several subclasses declare separately into their common superclass, so the data is declared once and shared behavior can follow it up.

## Use when
- Sibling subclasses hold the same data, possibly under different names.
- Methods that use the field are (or could be) identical across the siblings.

## Don't use when
- The fields only look alike: they are used differently or mean different things.
- Only some siblings need it (leave it, or push down instead).

## Mechanics
1. Read every use of the candidate fields; confirm they play the same role.
2. Rename them to one agreed name if they differ; run tests.
3. Declare the field in the superclass (make it visible to subclasses if the language has private/protected distinctions).
4. Delete the field from each subclass; run tests.
5. Consider wrapping access in accessors so subclasses do not depend on raw storage.

## Example (Python)
Before:
```python
class Car(Vehicle):
    def __init__(self, plate): self.plate = plate
class Truck(Vehicle):
    def __init__(self, reg):   self.registration = reg
```
After:
```python
class Vehicle:
    def __init__(self, plate): self.plate = plate
class Car(Vehicle): pass
class Truck(Vehicle): pass
```

## Language notes
- Python: attributes are set in `__init__`; pulling up means assigning in the base `__init__` and calling `super().__init__`.
- TypeScript/Java/C#: use `protected` (or private plus accessor); in TS also declare the property on the base class.
- Go: no inheritance; move the field into an embedded struct shared by both types.

## Related
Pull Up Constructor Body, Pull Up Method, Self Encapsulate Field. Smell: Duplicated Code.

## Source
Fowler et al. (1999), Refactoring, ch. 11, p. 260.
