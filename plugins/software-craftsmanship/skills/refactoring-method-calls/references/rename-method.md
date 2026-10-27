# Rename Method

## Intent
Change a method's name so it states what the method does, because readers navigate code by names and a misleading name taxes every future reader.

## Use when
- You have to open the body to learn what the method does.
- The name describes how (`do_loop`) instead of what, or reuses a term the domain does not use.
- A comment above the method explains its purpose: turn that comment into the name.
- Parameter order or naming is confusing (the same procedure also covers reordering parameters).

## Don't use when
- The method is part of a published API and you cannot update callers: add the new name and deprecate the old one instead of removing it.
- The method overrides or implements an inherited signature and you cannot rename the whole hierarchy together.

## Mechanics
1. Check whether the method is declared in a superclass, subclass, or interface; if so, repeat every step for each declaration.
2. Create a method with the new name and the same body.
3. Turn the old method into a one-line delegation to the new one.
4. Run tests.
5. Replace each caller of the old name with the new name, testing after each batch. Include dynamic references (strings, reflection, config, mocks).
6. Delete the old method, or keep it marked deprecated if outsiders depend on it.
7. Run tests and the type checker.

## Example (Python)
```python
# Before
class Invoice:
    def calc(self):                      # calc what?
        return sum(l.qty * l.price for l in self.lines)

# After
class Invoice:
    def subtotal(self):
        return sum(l.qty * l.price for l in self.lines)

    def calc(self):                      # temporary shim for outside callers
        warnings.warn("use subtotal()", DeprecationWarning, stacklevel=2)
        return self.subtotal()
```

## Language notes
- Python: no compiler will find missed callers; use the IDE rename, `grep -w`, and tests. `warnings.warn(DeprecationWarning)` flags stragglers. Rename in `__all__` and docs too.
- TypeScript: the language server's rename symbol is reliable; use `/** @deprecated */` on the old export.
- Java: `@Deprecated` plus Javadoc `@deprecated`; IDE refactor handles overrides.
- C#: `[Obsolete("use X")]`, optionally with error=true after migration.
- Go: exported names are API; use a `// Deprecated:` comment and `gopls` rename. Interfaces force renaming implementers.

## Related
- Add Parameter, Remove Parameter (same delegate-then-migrate procedure).
- Smells: Comments (a comment that explains a name), Alternative Classes with Different Interfaces.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 222.
