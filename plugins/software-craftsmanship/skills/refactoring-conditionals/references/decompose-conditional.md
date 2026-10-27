# Decompose Conditional

## Intent
Turn a complicated if/else into a short statement whose condition and branches are calls to well-named functions, so the reader sees the reason for the branch, not the arithmetic.

## Use when
- The condition is a multi-part boolean that needs a moment to decode.
- Branch bodies are several lines long and obscure what each case means.
- You catch yourself writing a comment above an `if` to explain it.

## Don't use when
- The condition and branches are already one-liners with obvious meaning.
- The conditional is nested and the inner checks are really special cases: use Guard Clauses first, then decompose what remains.
- The extracted name would just restate the code (e.g. `check_condition`).

## Mechanics
1. Pick the condition expression and extract it into a predicate named for the business meaning, not the mechanics.
2. Extract the then-branch into a function named for its intent.
3. Extract the else-branch the same way.
4. Run tests after each extraction, not only at the end.
5. If the nesting is deep, decide first whether guard clauses fit better.

## Example (Python)
```python
# Before
if d < SUMMER_START or d > SUMMER_END:
    fee = units * WINTER_RATE + WINTER_SURCHARGE
else:
    fee = units * SUMMER_RATE

# After
def is_off_season(d): return d < SUMMER_START or d > SUMMER_END
def off_season_fee(units): return units * WINTER_RATE + WINTER_SURCHARGE
def season_fee(units): return units * SUMMER_RATE

fee = off_season_fee(units) if is_off_season(d) else season_fee(units)
```

## Language notes
- Python: small module-level functions or `@property` predicates; a conditional expression is fine for the final one-liner.
- TypeScript: arrow-function predicates can be type guards (`x is Foo`), which also narrow types.
- Java: private methods; `Predicate<T>` only if the predicate is passed around.
- C#: local functions keep helpers close; expression-bodied members for one-liners.
- Go: unexported helper funcs; named boolean results are rarely needed.

## Related
Smells: Long Method, Comments (used as deodorant). Refactorings: Extract Method, Replace Nested Conditional with Guard Clauses, Consolidate Conditional Expression.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Decompose Conditional (about p. 193).
