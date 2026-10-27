# Pull Up Constructor Body

## Intent
Give the superclass a constructor that performs the shared initialization, and have subclass constructors call it, since constructors are not inherited and cannot be moved like ordinary methods.

## Use when
- Subclass constructors begin with the same assignments or setup.
- You are pulling up fields and want them initialized (and kept private) in the superclass.

## Don't use when
- Construction logic is complicated enough that a Factory Method is clearer.
- The shared code depends on state set later by the subclass (see mechanics step 5).

## Mechanics
1. Define a superclass constructor taking the shared parameters.
2. Move the common leading statements into it; try to arrange the common code first.
3. Call the superclass constructor at the start of each subclass constructor, then run tests.
4. For common code that must run after subclass setup, extract it into a method, pull that method up, and call it at the end of each subclass constructor.

## Example (Python)
Before:
```python
class Manager(Employee):
    def __init__(self, name, id, grade):
        self.name = name; self.id = id; self.grade = grade
```
After:
```python
class Employee:
    def __init__(self, name, id): self.name = name; self.id = id
class Manager(Employee):
    def __init__(self, name, id, grade):
        super().__init__(name, id); self.grade = grade
```

## Language notes
- Python: use `super().__init__(...)`; with multiple inheritance, accept `**kwargs` and cooperate. Dataclass inheritance: fields with defaults must come after those without.
- Java/C#: `super(...)` / `: base(...)` must be the first call. Avoid calling overridable methods from a constructor.
- TypeScript: `super(...)` before touching `this`.
- Go: no constructors; use a `NewBase` function and call it from `NewDerived` when building the embedded value.

## Related
Pull Up Field, Pull Up Method, Replace Constructor with Factory Method, Extract Method.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 264-266.
