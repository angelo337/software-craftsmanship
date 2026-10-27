# Inline Class

## Intent
Fold a class that no longer earns its keep into the class that uses it most, then delete it.

## Use when
- A class is left with very little after other refactorings moved its duties away.
- A class is a thin wrapper that adds indirection with no abstraction.
- You want to merge two classes before re-splitting them along a better line.

## Don't use when
- The class has a distinct role that other clients depend on, even if it is small.
- It is a deliberate extension point, interface or value type documenting the domain.
- Merging would recreate a Large Class.

## Mechanics
1. On the absorbing class, declare the public protocol of the source class as delegating methods (extract an interface first if the source's API deserves one).
2. Redirect every reference from the source class to the absorbing class. Renaming or hiding the old class helps the compiler flag leftovers.
3. Run tests.
4. Move Method and Move Field until the source is empty.
5. Delete the source class.

## Example (Python)
```python
# before
class Phone:
    def __init__(self, area, number): self.area, self.number = area, number
    def __str__(self): return f"({self.area}) {self.number}"
class Person:
    def __init__(self, name, phone): self.name, self.phone = name, phone
# after
class Person:
    def __init__(self, name, area, number):
        self.name, self.area, self.number = name, area, number
    def phone(self): return f"({self.area}) {self.number}"
```

## Language notes
- Python: grep for imports and attribute chains (`p.phone.area`); no compiler will list them. Type checkers help.
- Java/C#/TS: rename the old class temporarily so the compiler lists remaining references. IDEs: IntelliJ "Inline Class" (Java), Eclipse inline refactorings, ReSharper "Inline"; Python IDEs mostly manual.
- Go: embedding the small struct is a lighter alternative to full merging.

## Related
Extract Class (inverse), Move Method, Move Field, Remove Middle Man. Smells: Lazy Class, Speculative Generality.

## Source
Fowler et al. (1999), Chapter 7 (Inline Class).
