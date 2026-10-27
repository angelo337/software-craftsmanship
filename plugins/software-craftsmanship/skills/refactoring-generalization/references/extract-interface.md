# Extract Interface

## Intent
Name a subset of a class's operations as an interface, so clients depend on the role they need rather than the whole class.

## Use when
- Several clients use the same narrow slice of a class.
- Two or more classes should be usable interchangeably by some code.
- A class plays distinct roles for different callers, or you want to describe its outbound dependencies so servers can be swapped.

## Don't use when
- Only one implementation and one client will ever exist and the name adds nothing.
- You need to share code, not just a contract: Extract Superclass (or delegate to a component).

## Mechanics
1. Create an empty interface.
2. Add the operations that form the shared subset.
3. Declare the class(es) as implementing it.
4. Change client variable, parameter and return types to the interface wherever only that subset is used; run tests.

## Example (Python)
Before:
```python
def charge(emp, days):
    base = emp.rate() * days
    return base * 1.05 if emp.has_special_skill() else base
```
After:
```python
from typing import Protocol
class Billable(Protocol):
    def rate(self) -> int: ...
    def has_special_skill(self) -> bool: ...
def charge(emp: Billable, days: int) -> float:
    base = emp.rate() * days
    return base * 1.05 if emp.has_special_skill() else base
```

## Language notes
- Python: `typing.Protocol` (structural, no inheritance needed) or `abc.ABC` (nominal, enforced at instantiation).
- TypeScript: `interface` is structural; no `implements` is required, though it documents intent.
- Java/C#: explicit `implements`; C# may use explicit interface implementation to hide members.
- Go: interfaces are satisfied implicitly and are idiomatically small; define them at the consumer.

## Related
Extract Superclass, Extract Class, Replace Delegation with Inheritance. Smells: Duplicated Code (interfaces alone can duplicate implementations), Inappropriate Intimacy.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 278-280.
