# Change Value to Reference

## Intent
Turn many equal, copy-per-use instances into one shared object per real-world entity, so a change is visible to everyone who refers to it.

## Use when
- The object represents a real thing with identity (customer, account) and you need to attach changeable data to it.
- Duplicate copies drift out of sync or waste memory.
- Updates to one instance must be seen by every holder.

## Don't use when
- The object is a true value (money, date, range): equality by content is correct and copies are harmless.
- You cannot name a single owner/registry for lookups; sharing without lifecycle control leaks memory.
- The system is distributed/concurrent and sharing mutable state is risky.

## Mechanics
1. Replace the constructor with a factory method so creation is under your control, and update callers.
2. Make the constructor private (or module-private by convention).
3. Choose who hands out instances: a registry/repository object, or a static dictionary on the class.
4. Decide pre-created versus created on demand; if pre-created, ensure loading happens before first use.
5. Make the factory return the existing instance, and decide what happens for an unknown key (error or create).
6. Rename the factory to signal lookup (e.g. get_named / find) and run tests.

## Example (Python)
```python
# before: each Order gets its own Customer copy
class Customer:
    def __init__(self, name): self.name = name; self.credit = 0
class Order:
    def __init__(self, name): self.customer = Customer(name)

# after: one Customer per name
class Customer:
    _instances: dict[str, "Customer"] = {}
    def __init__(self, name): self.name = name; self.credit = 0
    @classmethod
    def get_named(cls, name):
        if name not in cls._instances:
            cls._instances[name] = cls(name)   # or raise if pre-loaded only
        return cls._instances[name]

class Order:
    def __init__(self, name): self.customer = Customer.get_named(name)
```

## Language notes
- Python: classmethod registry, `functools.lru_cache` on a factory, or a repository object injected in; `__new__` tricks are rarely worth it.
- Java/C#: a static map or, better, a repository/DI-managed service; mind thread safety (`ConcurrentHashMap`).
- TypeScript: a module-level `Map` or repository class.
- Go: pointer types give reference semantics; keep a `map[string]*Customer` behind a mutex-protected registry.
- ORMs already provide an identity map: prefer it over hand-rolled registries.

## Related refactorings and smells
- Change Reference to Value (the inverse), Replace Constructor with Factory Method, Replace Data Value with Object.
- Smells: Shotgun Surgery when the same data is duplicated across copies.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Change Value to Reference". Page numbers were not reliably visible in the text extract.
