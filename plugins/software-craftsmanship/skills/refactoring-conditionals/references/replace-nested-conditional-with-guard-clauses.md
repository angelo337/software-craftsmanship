# Replace Nested Conditional with Guard Clauses

## Intent
Handle each unusual case at the top with an immediate return (or raise) so the normal path runs straight through, flat and unindented.

## Use when
- If/else chains where one branch is the ordinary case and the others are exceptions.
- A `result` variable assigned in many branches and returned at the end.
- The happy path is buried several indentation levels deep.

## Don't use when
- Both branches are genuine normal behavior; use a symmetric if/else so the code does not suggest one is rare.
- The function must perform shared cleanup on every exit and the language has no `finally`/`defer`/context manager.
- Early exits would skip required side effects.

## Mechanics
1. Take the first special case and turn it into a check that returns (or raises) immediately.
2. Test.
3. Repeat for each special case, one at a time, working from the top.
4. When a check is simpler stated the other way, invert the condition to produce the guard; simplify any resulting `not (a and b)` into `not a or not b`.
5. Return explicit values from guards so the failure outcome is visible.
6. Delete the result variable once it only holds a returned value.
7. If several guards return the same thing, consolidate their conditions.

## Example (Python)
```python
# Before
def shipping(order):
    if order.cancelled:
        cost = 0
    else:
        if order.total >= FREE_OVER:
            cost = 0
        else:
            cost = flat_rate(order.zone)
    return cost

# After
def shipping(order):
    if order.cancelled or order.total >= FREE_OVER:
        return 0
    return flat_rate(order.zone)
```

## Language notes
- Python/TypeScript/Java/C#/Go: all support early return; Go makes it the idiom (`if err != nil { return err }`).
- Throwing/raising is the right guard for invalid arguments; returning a default is for legitimate special cases.
- C# / Java: `ArgumentNullException.ThrowIfNull`, `Objects.requireNonNull` are ready-made guards.
- Python `match` with `case _:` is not a guard replacement; use plain `if` with return.

## Related
Smells: Long Method, Arrow code (deep nesting). Refactorings: Consolidate Conditional Expression, Decompose Conditional, Remove Control Flag, Introduce Assertion.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Replace Nested Conditional with Guard Clauses (about p. 202).
