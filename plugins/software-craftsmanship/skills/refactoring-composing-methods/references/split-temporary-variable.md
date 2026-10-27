# Split Temporary Variable

## Intent
Give each purpose of a reused temp its own variable, so each name and value matches exactly one meaning.

## Use when
- A temp is assigned more than once and is neither a loop variable nor an accumulator.
- Names like `temp`, `result`, `x` carry two different ideas at different points.
- A reused temp stops you from extracting or replacing it with a query.

## Don't use when
- It is a loop counter or a collecting variable (`total += ...`, string building, appending to a list); those legitimately change.
- The "reuse" is a deliberate state machine variable.

## Mechanics
1. At the first assignment, rename the temp to describe that first purpose.
2. Make it read-only if the language allows.
3. Rename every reference up to the second assignment.
4. At the second assignment, declare a fresh variable named for its purpose.
5. Run the tests.
6. Repeat for each further assignment.

## Example (Python)
```python
# before
temp = 2 * (h + w)
print(temp)
temp = h * w
print(temp)
# after
perimeter = 2 * (h + w)
print(perimeter)
area = h * w
print(area)
```

## Language notes
- IDEs: rename-symbol helps for each stage, but the splitting itself is manual; some linters (pylint `redefined-outer-name`, ESLint `no-param-reassign`/`prefer-const`) flag candidates.
- Python lacks block scope, so a reused name leaks across the whole function; this makes the smell easy to miss.
- TS/JS: use `const` to enforce. Go: `:=` shadowing can hide a split mistake. Java/C#: `final`/`readonly` locals.

## Related
Replace Temp with Query, Extract Method, Remove Assignments to Parameters. Smell: Long Method.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Split Temporary Variable" (about pp. 105-108 of the supplied text's numbering).
