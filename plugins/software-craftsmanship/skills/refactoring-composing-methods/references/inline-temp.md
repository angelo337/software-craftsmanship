# Inline Temp

## Intent
Replace a single-assignment temporary with the expression it holds, so it stops blocking other refactorings.

## Use when
- A temp is assigned once from a simple expression or a call, and adds no explanatory value.
- It stands in the way of Extract Method or Replace Temp with Query.
- It is the first step of Replace Temp with Query.

## Don't use when
- The name explains a non-obvious expression (keep it, or prefer Introduce Explaining Variable).
- The expression is costly or has side effects and the temp is read several times.
- The temp is assigned more than once.

## Mechanics
1. Make the temp read-only (final, const, readonly, or just confirm it is assigned once) so the compiler or a linter proves single assignment.
2. Replace each reference with the right-hand expression, testing after each.
3. Delete the declaration and assignment.
4. Run the tests.

## Example (Python)
```python
# before
base = order.base_price()
return base > 1000
# after
return order.base_price() > 1000
```

## Language notes
- IDEs: "Inline Variable" (IntelliJ, PyCharm, VS Code, Visual Studio, GoLand) does the whole job.
- Python has no `final`; use `typing.Final` plus mypy/pyright, or search for other assignments. TS/JS: use `const`. C#: `readonly` applies to fields only, so check locals manually.
- Evaluation-order changes matter if the expression has side effects or the data may change between the assignment and the use.

## Related
Replace Temp with Query, Introduce Explaining Variable (inverse). Smell: Long Method (temps encourage it).

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Inline Temp" (about pp. 97-98 of the supplied text's numbering).
