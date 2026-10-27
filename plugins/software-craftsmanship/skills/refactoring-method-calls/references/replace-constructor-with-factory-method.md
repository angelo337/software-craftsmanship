# Replace Constructor with Factory Method

## Intent
Create objects through a named function instead of a raw constructor, so creation can choose a subclass, reuse instances, validate, or describe itself.

## Use when
- A type code is being replaced by subclasses and callers should not know which subclass they get.
- Construction must return a cached or shared instance, or a subtype, or may fail without throwing from `__init__`.
- Several ways to build the same type need distinct names (`from_csv`, `from_json`, `empty`) rather than overloads.

## Don't use when
- The constructor is already trivial and the class has no subtype or caching needs.
- A framework requires direct construction (some serializers, ORMs, DI containers).
- Hiding the constructor would break published callers: keep it public and add the factory alongside.

## Mechanics
1. Create a factory function whose body calls the existing constructor.
2. Replace every direct constructor call with the factory; test after each replacement.
3. Make the constructor private/non-public (or document it as internal).
4. Run tests.
5. If the factory selects subclasses from a code, choose between a fixed set of explicit factories (type-safe, needs a new one per subclass) and a lookup by name or registry (flexible, errors only at runtime); you can switch with Parameterize Method or Replace Parameter with Explicit Methods.

## Example (Python)
```python
# Before
class Employee:
    def __init__(self, kind):
        self.kind = kind

e = Employee("manager")

# After
class Employee:
    _registry = {}

    def __init_subclass__(cls, **kw):
        super().__init_subclass__(**kw)
        Employee._registry[cls.__name__.lower()] = cls

    @classmethod
    def create(cls, kind):
        try:
            return cls._registry[kind]()
        except KeyError:
            raise ValueError(f"unknown employee kind: {kind}") from None

class Manager(Employee): ...
class Engineer(Employee): ...

e = Employee.create("manager")
```

## Language notes
- Python: `@classmethod` alternative constructors (`from_dict`); `__new__` can return other types but is obscure, so prefer factories. Cannot truly make `__init__` private; document it.
- TypeScript: `static create()` with a `private constructor`.
- Java: `static` factory methods (`List.of`) with a private constructor; Effective Java style names (`of`, `from`, `valueOf`).
- C#: static factory with private constructor; `Create...` naming.
- Go: `NewX` functions are the norm and can return an interface, hiding the concrete type.

## Related
- Replace Type Code with Subclasses/State-Strategy, Replace Parameter with Explicit Methods, Parameterize Method, Change Value to Reference (needs factories), Inline Method (avoid inlining the factory).
- Smells: Switch Statements on type codes, Primitive Obsession.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 247.
