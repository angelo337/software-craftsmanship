# Replace Conditional with Polymorphism

## Intent
Move each branch of a type-based conditional into an overriding method on the matching class, so callers invoke one method and each type supplies its own behavior.

## Use when
- A switch or if-chain selects behavior from a type code, kind string or enum.
- The same switch appears in several methods; adding a type means editing them all.
- Each branch contains real logic (not just a different constant).

## Don't use when
- There is one switch, it is exhaustive, and it is stable; a `match`/`switch` expression is simpler.
- Branches differ only by data; use a lookup table or a small value object.
- The type can change during an object's life and you cannot use state/strategy.
- The conditional tests values or ranges, not kinds.

## Mechanics
1. Ensure an inheritance (or interface) structure exists: use subclasses for fixed types, or state/strategy when the type changes at runtime or the class is already subclassed.
2. If the conditional is inside a larger method, extract it into its own method.
3. Move that method to the top class of the hierarchy if it lives elsewhere.
4. Pick one subtype; override the method there with that branch's body, adjusting access to data (you may have to widen visibility or pass the context object).
5. Test, then delete that branch from the base method; test again.
6. Repeat for every branch.
7. Make the base method abstract (or the protocol/interface method required).

## Example (Python)
```python
# Before
def area(shape):
    if shape.kind == "circle":
        return 3.14159 * shape.r ** 2
    if shape.kind == "rect":
        return shape.w * shape.h
    raise ValueError(shape.kind)

# After
class Circle:
    def __init__(self, r): self.r = r
    def area(self): return 3.14159 * self.r ** 2

class Rect:
    def __init__(self, w, h): self.w, self.h = w, h
    def area(self): return self.w * self.h
```
(`shape.area()` replaces the function; a new shape needs no edits elsewhere.)

## Language notes
- Python: duck typing or `typing.Protocol`; dataclasses; for one switch, `match` or a dict of callables is often enough.
- TypeScript: discriminated unions with exhaustive `switch` are a legitimate alternative; use classes/interfaces when behavior is open for extension.
- Java: sealed interfaces plus pattern-matching `switch` give closed, checked dispatch; abstract classes for open hierarchies.
- C#: abstract members, or `switch` expressions over records for closed sets.
- Go: interfaces with per-type methods; no inheritance, so this is the natural form.

## Related
Smells: Switch Statements, Duplicated Code, Speculative Generality (if overdone). Refactorings: Replace Type Code with Subclasses / State-Strategy, Extract Method, Move Method, Introduce Null Object.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Replace Conditional with Polymorphism (about p. 206).
