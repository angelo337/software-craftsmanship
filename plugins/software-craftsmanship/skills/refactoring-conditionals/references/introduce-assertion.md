# Introduce Assertion

## Intent
Make an unstated assumption about program state executable, so readers see the precondition and bugs surface near their origin.

## Use when
- A comment says "must have X or Y" or "never empty here".
- Code only works if some invariant holds, and a violation would be a programming error.
- A later failure (null dereference, wrong result) is far from the actual cause.

## Don't use when
- Validating user input, external data or API arguments: raise a real error, because assertions can be disabled.
- The code works fine if the condition is false; the assertion would only add noise.
- The check merely repeats logic already stated elsewhere.
- The assertion has side effects or is costly in hot paths.

## Mechanics
1. Identify an assumption that must be true for correctness.
2. Add an assertion stating it; adding one does not change behavior when the assumption holds.
3. Ask: if this assertion failed, would the code still work? If yes, delete it.
4. Extract complex or repeated assertion conditions into named predicates.
5. Keep assertions free of side effects, since they may be stripped in production.
6. Make failures unmistakable (clear message, unchecked exception).

## Example (Python)
```python
# Before
def expense_limit(self):
    # needs a personal limit or a primary project
    if self.limit is not None:
        return self.limit
    return self.project.member_limit

# After
def expense_limit(self):
    assert self.limit is not None or self.project is not None, \
        "employee needs a limit or a primary project"
    if self.limit is not None:
        return self.limit
    return self.project.member_limit
```

## Language notes
- Python: `assert` is stripped under `python -O`; never rely on it for validation.
- TypeScript: `console.assert` does not throw; use a small `assert(cond, msg): asserts cond` helper.
- Java: `assert` needs `-ea`; `Objects.requireNonNull`/Guava `Preconditions` are for argument checks, not internal invariants.
- C#: `Debug.Assert` is compiled out of release builds; use exceptions for contracts that must hold in production.
- Go: no assert keyword; use `if !cond { panic("...") }` for invariants, errors for expected failures.

## Related
Smells: Comments (an assertion replaces a "must be" comment). Refactorings: Extract Method (for assertion predicates), Replace Nested Conditional with Guard Clauses (guards handle expected cases; assertions handle impossible ones), Introduce Null Object.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Introduce Assertion (about p. 217).
