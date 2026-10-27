# Pull Up Method

## Intent
Replace identical (or made-identical) methods in sibling subclasses with one method in the superclass, removing a place where fixes can be forgotten.

## Use when
- Subclasses contain copy-pasted methods, or methods that produce the same result.
- A subclass override merely repeats what the superclass method already does.
- Two methods can be made equal by parameterizing them first.

## Don't use when
- The methods are similar but follow the same steps with different details: use Form Template Method.
- The body depends on subclass-only state you cannot lift or abstract.

## Mechanics
1. Compare the methods closely; differences often reveal untested behavior. If they do the same thing but differ in text, substitute one algorithm for the other until identical.
2. Align signatures to the one you want on the superclass.
3. Create the method on the superclass using one body.
4. If the body calls something only the subclasses have, declare it on the superclass as abstract (or pull up the field it uses, or use an abstract getter).
5. Delete one subclass copy; run tests. Repeat until only the superclass version remains.
6. Check callers; widen their declared type to the superclass where possible.

## Example (Python)
Before:
```python
class Regular(Customer):
    def bill(self, d): self.add(d, self.charge_for(self.last, d))
class Preferred(Customer):
    def bill(self, d): self.add(d, self.charge_for(self.last, d))
```
After:
```python
from abc import ABC, abstractmethod
class Customer(ABC):
    @abstractmethod
    def charge_for(self, start, end): ...
    def bill(self, d): self.add(d, self.charge_for(self.last, d))
```

## Language notes
- Python: `abc.ABC` + `@abstractmethod` declares the hook; duck typing means no declaration is strictly required, but the abstract method documents the dependency. Mixins are an option when siblings are not under one base.
- TypeScript/Java/C#: declare `abstract` members on an abstract class.
- Go: put the shared method on an embedded struct; if it needs a varying step, pass a function or interface into it, since embedded types cannot call "overridden" methods of the outer type.

## Related
Form Template Method, Pull Up Field, Substitute Algorithm, Extract Superclass. Smell: Duplicated Code.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 261-263.
