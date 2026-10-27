# Introduce Local Extension

## Intent
Group several missing methods for an unmodifiable class in a new class that is a subclass or a wrapper of it.

## Use when
- You need more than a couple of extra methods on a library class.
- Foreign methods are spreading across clients.
- You want one well-named home for domain-specific additions.

## Don't use when
- One or two methods suffice (Foreign Method).
- You can modify the original class.
- Subclassing is impossible (final/sealed) and the wrapper's loss of identity or equality would hurt.

## Mechanics
1. Create the extension as a subclass or a wrapper of the original. Prefer a subclass (less work) unless instances must be shared and mutable, in which case use a wrapper so changes affect the same underlying object.
2. Add a converting constructor taking the original (subclass: copy state through the super constructor; wrapper: store the reference).
3. Add the new features.
4. Replace the original with the extension where needed.
5. Move any existing foreign methods for that class onto the extension.
6. With wrappers, do not override equality to accept the raw type: this breaks symmetry. Use a differently named method.

## Example (Python)
```python
# subclass version
class Money(Decimal):
    def cents(self): return int(self * 100)
    def split(self, n): return [Money(self / n)] * n
price = Money(Decimal("9.90"))  # converting constructor
```

## Language notes
- Python: subclassing builtins mostly works but operators return the base type; wrapper plus `__getattr__` is also common. Do not monkey patch to avoid creating a class.
- C#/Kotlin: extension methods cover simple cases without a new type; use a wrapper when you need extra state.
- Java: subclass or composition; `final` classes force a wrapper. TS: subclass, or a class holding the original plus helper functions.
- Go: define `type Mine Original` (methods are not inherited) or embed it in a struct and add methods.
- Beware identity, serialization and framework mapping when swapping types.

## Related
Introduce Foreign Method, Move Method, Extract Class. Smell: Incomplete Library Class.

## Source
Fowler et al. (1999), Chapter 7 (Introduce Local Extension).
