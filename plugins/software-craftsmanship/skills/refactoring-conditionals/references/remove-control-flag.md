# Remove Control Flag

## Intent
Eliminate a boolean (or sentinel) variable that exists only to steer loop or conditional flow, by exiting directly with `break`, `continue` or `return`.

## Use when
- A variable such as `done`, `found`, `ok` is set in a loop and re-checked in every iteration or in later conditions.
- Code is shaped by a "single exit point" habit and has extra nesting to support it.
- The flag also carries the result (e.g. a string that starts empty and is filled at the hit).

## Don't use when
- The flag is real state that other code needs after the loop, not just a way to stop it.
- Cleanup logic requires a single exit and your language lacks a clean `finally`/`defer`/`with` equivalent.
- Leaving mid-loop would skip required side effects that you cannot restructure.

## Mechanics
1. Find the flag value that means "stop".
2. Option A (break/continue): replace each assignment of that value with `break` or `continue`; test after each replacement; then delete the flag and its checks.
3. Option B (return, usually preferable): extract the loop into its own function, replace each stop-assignment with `return` (returning the result if the flag doubled as one), and test after each.
4. If the flag carried the result, return it directly; return a clear default after the loop.
5. If the function now mixes a query with side effects, consider Separate Query from Modifier.

## Example (Python)
```python
# Before
def first_blocked(users, blocked):
    hit, done = None, False
    for u in users:
        if not done:
            if u in blocked:
                hit, done = u, True
    return hit

# After
def first_blocked(users, blocked):
    for u in users:
        if u in blocked:
            return u
    return None
```
(Idiomatic alternative: `next((u for u in users if u in blocked), None)`.)

## Language notes
- Python: `for ... else`, `next()` with a generator, `any()` / `all()` often replace the flag entirely.
- TypeScript: `Array.prototype.find/some/every`; remember `forEach` cannot break.
- Java: streams `findFirst/anyMatch`; plain `return` from an extracted method.
- C#: LINQ `FirstOrDefault/Any`.
- Go: early `return` inside a helper; labeled `break` for nested loops.

## Related
Smells: Long Method, Temporary Field (flags as temps). Refactorings: Extract Method, Replace Nested Conditional with Guard Clauses, Separate Query from Modifier.

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Remove Control Flag (about p. 198).
