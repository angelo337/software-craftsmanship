# Consolidate Duplicate Conditional Fragments

## Intent
Hoist statements that run identically in every branch out of the conditional, so the branches contain only what actually differs.

## Use when
- Every branch begins or ends with the same statement(s).
- A try block and all its handlers repeat the same cleanup or follow-up.
- Adding a new branch tempts you to copy the shared lines again.

## Don't use when
- The shared statement only looks identical but depends on a variable assigned inside the branch in a way that changes its effect.
- Moving it would change ordering relative to a side effect in the branch.
- A branch exits early (return/raise) before the shared code; it is not truly shared.

## Mechanics
1. Identify code that runs the same regardless of the condition.
2. If it is at the start of each branch, move it before the conditional.
3. If it is at the end, move it after the conditional.
4. If it is in the middle, check whether the code around it can be reordered past it without changing results; if so, shift it to an end and proceed.
5. If it spans several statements, extract them into a function first.
6. For exceptions, move shared trailing code into `finally`.

## Example (Python)
```python
# Before
if order.is_express:
    fee = base * 1.5
    log.info("order %s priced", order.id)
else:
    fee = base * 1.0
    log.info("order %s priced", order.id)

# After
fee = base * (1.5 if order.is_express else 1.0)
log.info("order %s priced", order.id)
```

## Language notes
- Python/Java/C#: `try/finally` (or `with` / `using`) for shared cleanup.
- TypeScript: `finally` blocks; remember `await` in the shared code keeps its position.
- Go: use `defer` for shared cleanup rather than repeating it in each branch.
- Languages with expression-style `if`/`match` (Python ternary, Rust, Kotlin, Scala) let the branch only produce the differing value.

## Related
Smells: Duplicated Code. Refactorings: Extract Method, Decompose Conditional, Consolidate Conditional Expression.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Consolidate Duplicate Conditional Fragments (about p. 197).
