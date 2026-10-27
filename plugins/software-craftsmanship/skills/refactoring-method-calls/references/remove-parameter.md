# Remove Parameter

## Intent
Delete a parameter the method no longer uses, so callers stop computing and passing values that do nothing.

## Use when
- The body never reads the parameter, and it is not required by an inherited signature.
- A previous refactoring made the value derivable elsewhere.
- The parameter was kept "in case we need it later": that is speculation, so drop it and re-add it when needed.

## Don't use when
- The method is polymorphic and any override, subclass, or interface implementation uses the parameter.
- The method is a callback with a fixed signature imposed by a framework (event handlers, `__exit__`, visitor interfaces).
- The method is public and outside callers pass the argument positionally: deprecate first.

## Mechanics
1. Check superclasses, subclasses, and interfaces; if any implementation uses the parameter, stop. Optionally add a second parameterless method for callers that know the concrete type.
2. Create a method without the parameter (remove several together) and copy the body.
3. Make the old method delegate to the new one, ignoring the argument.
4. Run tests.
5. Update each caller to the new signature, testing as you go; also delete code that existed only to compute the dropped argument.
6. Remove the old method, or deprecate if public.
7. Run tests.

## Example (Python)
```python
# Before
class Report:
    def render(self, title, locale):          # locale is never read
        return f"== {title} ==\n{self.body}"

# After
class Report:
    def render(self, title):
        return f"== {title} ==\n{self.body}"

    def _render_compat(self, title, locale):  # temporary, only if outsiders call it
        return self.render(title)
```

## Language notes
- Python: unused-argument linters (pylint W0613, ruff ARG) find candidates. Callers using keywords fail loudly with `TypeError`; positional callers may silently shift, so check counts. Accept `**_` only as a short transition.
- TypeScript: `noUnusedParameters` finds candidates; removing a trailing parameter is source-compatible for callers who passed more, so tests matter.
- Java/C#: IDE "Change Signature" updates callers; check overrides explicitly.
- Go: the compiler rejects extra arguments, so migration is mechanical; unused parameters are allowed by the compiler, so use a linter (`unparam`).

## Related
- Rename Method, Add Parameter, Replace Parameter with Method (produces unused parameters).
- Smells: Speculative Generality, Long Parameter List.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 224.
