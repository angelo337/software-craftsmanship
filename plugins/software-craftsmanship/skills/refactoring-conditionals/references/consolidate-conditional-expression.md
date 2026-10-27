# Consolidate Conditional Expression

## Intent
Merge a run of checks that all produce the same outcome into one boolean expression, then name it. This shows that it is a single decision, and prepares an extraction.

## Use when
- Consecutive `if` statements return the same value or run the same action.
- Nested ifs with no else and no other code between them (an AND in disguise).
- The merged condition has a nameable meaning ("not eligible", "can skip").

## Don't use when
- The checks represent separate, independently evolving rules; merging hides intent.
- Any check has side effects, or later checks depend on state changed by earlier ones.
- Different checks need different error messages or logging.

## Mechanics
1. Verify none of the conditions has side effects and that evaluation order does not matter (or preserve it with short-circuit operators).
2. Combine sequential checks with `or`; combine nested checks with `and`.
3. Run tests.
4. Extract the combined expression into a named predicate.
5. If the whole function is now just the test, consider a single conditional expression.

## Example (Python)
```python
# Before
def monthly_benefit(emp):
    if emp.years < 2:
        return 0
    if emp.months_disabled > 12:
        return 0
    if emp.part_time:
        return 0
    return emp.base * 0.6

# After
def is_ineligible(emp):
    return emp.years < 2 or emp.months_disabled > 12 or emp.part_time

def monthly_benefit(emp):
    if is_ineligible(emp):
        return 0
    return emp.base * 0.6
```

## Language notes
- Python: `any([...])` / `all([...])` help for long lists, but they evaluate every element eagerly; use generator expressions if laziness matters.
- TypeScript/Java/C#/Go: `||` and `&&` short-circuit, so ordering is preserved; keep cheap checks first.
- C# and modern Java: pattern matching (`is`, `switch` with `when`) can express combined conditions compactly.
- Go: no ternary; keep the `if pred(x) { return 0 }` form.

## Related
Smells: Duplicated Code, Long Method. Refactorings: Extract Method, Decompose Conditional, Replace Nested Conditional with Guard Clauses (whose guards often consolidate afterward).

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Consolidate Conditional Expression (about p. 195).
