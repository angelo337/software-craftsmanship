# Collapse Hierarchy

## Intent
Merge a superclass and a subclass that have become too similar, removing a class that no longer earns its place.

## Use when
- After other moves, a subclass adds little or nothing over its parent (or the parent over the child).
- A layer in the hierarchy exists only historically.

## Don't use when
- Other subclasses still rely on the intermediate class.
- The extra class is a deliberate extension point with a real planned second variant.

## Mechanics
1. Pick which class survives.
2. Move the other class's members into it with Pull Up or Push Down Field/Method; test each move.
3. Update every reference to the removed class (type annotations, instantiation, isinstance checks, imports).
4. Delete the empty class; run tests.

## Example (Python)
Before:
```python
class Account:
    def __init__(self, bal): self.bal = bal
    def deposit(self, n): self.bal += n
class SavingsAccount(Account):      # nothing else ever added
    pass
acct = SavingsAccount(10)
```
After:
```python
class Account:
    def __init__(self, bal): self.bal = bal
    def deposit(self, n): self.bal += n
acct = Account(10)
```

## Language notes
- Python: search for `isinstance`, pickles, serializers, and string-based class lookups that name the removed class.
- TypeScript/Java/C#: the compiler finds references; check reflection, DI registrations and serialization names.
- Go: collapse by merging an embedded struct into its host.

## Related
Pull Up/Push Down Field and Method, Inline Class. Smells: Lazy Class, Speculative Generality.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 280-281.
