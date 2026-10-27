# Extract Superclass

## Intent
Introduce a common parent for two classes that do similar things, and move the shared data and behavior into it.

## Use when
- Two unrelated classes share fields, methods, or a role (for example, both have a name and an annual cost).
- They share an interface as well as behavior, so they are truly substitutable.

## Don't use when
- They only share a few incidental members: compose a helper instead (Extract Class).
- Substitutability fails; delegation is safer, and you can switch later with Replace Inheritance with Delegation.
- You only need a shared contract, no code: Extract Interface.

## Mechanics
1. Create an empty abstract superclass; make the originals extend it.
2. Move shared members up one at a time: fields first, then constructor bodies, then methods. Test after each.
3. Rename methods with the same purpose to one name before pulling up. If the signature matches but bodies differ, declare it abstract in the parent. If bodies differ but do the same thing, substitute one algorithm.
4. Look for common fragments inside the remaining methods: Extract Method then pull up, or Form Template Method.
5. Change clients that use only the shared members to depend on the superclass.

## Example (Python)
Before:
```python
class Employee:
    def __init__(self, name, cost): self.name, self._cost = name, cost
    def annual_cost(self): return self._cost
class Department:
    def __init__(self, name): self.name, self.staff = name, []
    def annual_cost(self): return sum(e.annual_cost() for e in self.staff)
```
After:
```python
from abc import ABC, abstractmethod
class Party(ABC):
    def __init__(self, name): self.name = name
    @abstractmethod
    def annual_cost(self): ...
class Employee(Party): ...      # keeps its own annual_cost
class Department(Party): ...    # staff: list[Party]
```

## Language notes
- Python: ABCs, or `typing.Protocol` if only the contract matters; mixins help when classes already have parents.
- TypeScript: abstract class; structural typing often makes an interface enough.
- Java/C#: single inheritance, so choose the parent wisely; interfaces cover extra roles.
- Go: embed a base struct for shared data/methods, define an interface for the contract.

## Related
Pull Up Field/Method/Constructor Body, Extract Interface, Extract Class, Form Template Method. Smell: Duplicated Code. Once both are a common type, a Composite becomes possible.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 273-278.
