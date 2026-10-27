# Replace Error Code with Exception

## Intent
Signal failure by raising an exception instead of returning a special value, so normal flow and error flow are separate and errors cannot be silently ignored.

## Use when
- A function returns -1, None, "", False, or a status int to mean "failed".
- Callers forget to check the code, or error checks clutter the happy path.
- The detecting code cannot decide what to do; a caller higher up can.

## Don't use when
- The condition is routine and the caller can test it first (see Replace Exception with Test).
- The code lives at a boundary that mandates codes (C ABI, process exit status, HTTP status mapping); translate at the boundary.
- In Go, returning an `error` value is already the idiom; do not introduce panics.

## Mechanics
1. Decide who is responsible for the precondition. If the caller should check first, the failure is a programming error: use an unchecked/standard exception (or an assertion) and add a query the caller can use. If the method itself must handle the situation, use a specific, documented exception callers are expected to catch.
2. Create or choose the exception type.
3. Adjust all callers: for caller-checked errors, test with the query before calling; for method-handled errors, wrap the call in try/except and move the old error branch into the handler.
4. Change the method to raise instead of returning the code, and update its signature or docs (and checked-exception declarations where the language has them).
5. With many callers, do it gradually: add a new exception-raising method, make the old method call it and translate the exception back to the old code, migrate callers one at a time, delete the old method, then rename the new one.

## Example (Python)
```python
# Before
def withdraw(self, amount):
    if amount > self.balance:
        return -1
    self.balance -= amount
    return 0

if acct.withdraw(50) == -1:
    notify_overdrawn()

# After
class InsufficientFunds(Exception): ...

def withdraw(self, amount):
    if amount > self.balance:
        raise InsufficientFunds(f"need {amount}, have {self.balance}")
    self.balance -= amount

try:
    acct.withdraw(50)
except InsufficientFunds:
    notify_overdrawn()
```

## Language notes
- Python: subclass `Exception` (not `BaseException`); use `raise ... from err` to keep causes; `ValueError`/`TypeError` for bad arguments.
- TypeScript: throw `Error` subclasses (`instanceof` works with `target >= ES2015`), or use a Result/discriminated-union return when failures are expected values.
- Java: checked exceptions if callers must handle; unchecked (`IllegalArgumentException`, `IllegalStateException`) for caller bugs.
- C#: no checked exceptions; derive from `Exception`, document with XML `<exception>`; `TryXxx` pattern for expected failures.
- Go: return `error` values (`errors.Is/As`, wrapping with `%w`); reserve `panic` for unrecoverable states.
- Result types (Rust, Kotlin `Result`, Python libraries) are an alternative when failure is an expected, typed outcome.

## Related
- Reverse for expected conditions: Replace Exception with Test. Related: Introduce Assertion, Replace Nested Conditional with Guard Clauses, Rename Method.
- Smells: Switch/if-chains on return codes, Long Method.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 252.
