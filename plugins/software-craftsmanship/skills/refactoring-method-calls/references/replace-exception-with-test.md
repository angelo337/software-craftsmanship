# Replace Exception with Test

## Intent
Stop using exceptions for conditions that are ordinary and checkable up front; test first and branch, keeping exceptions for truly unexpected failures.

## Use when
- A try/except handles something that happens routinely (empty pool, missing key, index past the end).
- The caller could cheaply check the condition before the operation.
- Exceptions are being used as a control-flow shortcut and make the happy path hard to read.

## Don't use when
- The check is racy or non-atomic (file exists, then open; another thread may change state in between): catching is correct. Prefer EAFP when the check cannot be made reliable.
- The failure comes from outside your control (I/O, network, parsing untrusted input).
- The check would duplicate expensive work already done by the operation.

## Mechanics
1. Add an up-front test and copy the handler's logic into that branch.
2. Put an assertion that fails if the handler runs, in the catch/except block.
3. Run tests; if the assertion never fires, proceed.
4. Remove the try/except entirely (when it has no other handlers).
5. Run tests, then simplify the now-visible conditionals (for example Consolidate Duplicate Conditional Fragments).

## Example (Python)
```python
# Before
def acquire(self):
    try:
        res = self._free.pop()
    except IndexError:
        res = Resource()
    self._used.append(res)
    return res

# After
def acquire(self):
    res = self._free.pop() if self._free else Resource()
    self._used.append(res)
    return res
```

## Language notes
- Python: culture favors EAFP, so apply this only when the exception is clearly part of normal flow or hot-path cost matters; `dict.get`, `getattr(obj, n, default)`, `if x in d` are standard tests. Do not introduce time-of-check/time-of-use races.
- TypeScript: avoid `try { arr[i] }`-style logic; check bounds or use optional chaining and `??`.
- Java: checks like `isEmpty()`, `containsKey`; exceptions are costly to create (stack traces).
- C#: `TryGetValue`, `int.TryParse` exist to avoid exceptions for expected failures.
- Go: idiomatic: `v, ok := m[k]`, length checks before indexing.

## Related
- Reverse: Replace Error Code with Exception. Related: Introduce Assertion, Consolidate Duplicate Conditional Fragments, Replace Nested Conditional with Guard Clauses.
- Smells: exceptions as flow control, Long Method.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 256.
