# Hide Method

## Intent
Reduce a method's visibility to the narrowest scope that works, so the public interface only shows what clients actually need.

## Use when
- No code outside the class (or module/package) calls the method.
- A class grew richer behavior and its raw getters and setters are now only used internally.
- You just removed the last external call to a method.

## Don't use when
- The method is part of a published API, or used via reflection, serialization, dependency injection, or test code you intend to keep calling directly (consider testing through the public interface instead).
- Subclasses need it: make it protected (or the language's equivalent), not private.

## Mechanics
1. Periodically review each method for external callers; use lint rules, IDE "can be private" inspections, or a project-wide search, and re-check after removing any external call.
2. Reduce visibility as far as possible (private, internal, package-private, unexported).
3. Compile or run the type checker and tests after a batch of changes; failures show up as access errors and are easy to trace.
4. If a hidden getter or setter is now only a trivial pass-through to a field, inline it and use the field directly.

## Example (Python)
```python
# Before
class Cart:
    def total(self):
        return self.apply_tax(self.subtotal())

    def subtotal(self):                 # only used here
        return sum(i.price for i in self.items)

    def apply_tax(self, amount):        # only used here
        return amount * 1.19

# After
class Cart:
    def total(self):
        return self._apply_tax(self._subtotal())

    def _subtotal(self):
        return sum(i.price for i in self.items)

    def _apply_tax(self, amount):
        return amount * 1.19
```

## Language notes
- Python: a leading underscore is a convention, not enforcement; use `__all__` and underscore-prefixed modules to mark module-level privacy. Name mangling (`__x`) is rarely needed. Update tests that reach into the method.
- TypeScript: `private` / `protected` (compile-time only) or `#name` (runtime-private); do not export unused symbols.
- Java: `private`, package-private; check frameworks that use reflection.
- C#: `private`, `internal`, `protected internal`; `InternalsVisibleTo` for tests.
- Go: lowercase identifier; unexported names are package-private, and `internal/` directories restrict packages.

## Related
- Remove Setting Method, Encapsulate Field, Move Method (may reveal a method that belongs elsewhere), Separate Query from Modifier (halves left non-public).
- Smells: Inappropriate Intimacy, Data Class.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 246.
