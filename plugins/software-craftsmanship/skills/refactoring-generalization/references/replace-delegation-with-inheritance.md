# Replace Delegation with Inheritance

## Intent
Make a delegating class a subclass of its delegate when it forwards nearly the delegate's whole interface, deleting the boilerplate forwarders.

## Use when
- You write simple pass-through methods for every public operation of the delegate.
- The relationship is a true is-a and the delegate is not shared.

## Don't use when
- You use only part of the delegate's interface: a subclass must honor the whole parent contract. Consider Remove Middle Man, Extract Superclass or Extract Interface instead.
- The delegate is shared by several objects and mutable: inheritance cannot share state between instances. (Immutable delegates are safe to copy.)

## Mechanics
1. Make the delegating class extend the delegate; compile/run to reveal method clashes (same name, different return type, exceptions, or visibility) and fix them with renames.
2. Point the delegate field at the object itself.
3. Delete the simple forwarding methods (leaving them causes infinite recursion); test.
4. Replace remaining uses of the field with direct calls on self.
5. Remove the field.

## Example (Python)
Before:
```python
class Person:
    def __init__(self): self.name = ""
    def last_name(self): return self.name.split()[-1]
class Employee:
    def __init__(self): self._p = Person()
    def get_name(self): return self._p.name
    def __str__(self):  return "Emp: " + self._p.last_name()
```
After:
```python
class Employee(Person):
    def __str__(self): return "Emp: " + self.last_name()
```

## Language notes
- Python: subclassing is cheap; watch for name clashes and multiple-inheritance MRO effects.
- TypeScript/Java/C#: check `final`/`sealed` delegates and constructor requirements.
- Go: embed the delegate struct to promote its methods, which achieves this without a class hierarchy.

## Related
Replace Inheritance with Delegation (inverse), Remove Middle Man, Extract Superclass, Extract Interface. Smell: Middle Man.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 290-293.
