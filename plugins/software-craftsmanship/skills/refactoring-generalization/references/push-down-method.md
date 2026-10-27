# Push Down Method

## Intent
Move a superclass method into only the subclasses that actually use it, so the parent's interface stays truthful.

## Use when
- Behavior on the base class is meaningful for just some subclasses.
- You are in the middle of Extract Subclass.

## Don't use when
- Clients call it through the superclass type and every subclass needs a version: keep it (abstract if appropriate).
- Most subclasses use it; moving it duplicates code.

## Mechanics
1. Copy the method into each subclass that needs it; loosen visibility of fields it touches if required.
2. Remove it from the superclass. Fix callers that relied on the superclass type (change declared types to the subclass). If the superclass is abstract and clients still need polymorphic access, leave an abstract declaration.
3. Run tests.
4. Delete the method from subclasses that do not need it; run tests.

## Example (Python)
Before:
```python
class Shape:
    def radius(self): return self._r   # only circles have one
class Circle(Shape): ...
class Square(Shape): ...
```
After:
```python
class Shape: ...
class Circle(Shape):
    def radius(self): return self._r
class Square(Shape): ...
```

## Language notes
- Python: callers are unchecked, so grep and rely on tests; a type checker (mypy/pyright) will flag callers still typed as the base.
- TypeScript/Java/C#: the compiler finds callers needing a narrower type.
- Go: move the method to the specific struct type; interfaces satisfied implicitly may change, so recheck.

## Related
Push Down Field, Extract Subclass, Pull Up Method (inverse). Smell: Refused Bequest.

## Source
Fowler et al. (1999), Refactoring, ch. 11, p. 267.
