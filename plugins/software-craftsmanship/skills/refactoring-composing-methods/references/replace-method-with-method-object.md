# Replace Method with Method Object

## Intent
Turn a long method into its own class whose fields are the old locals, so you can split it into small methods without passing arguments around.

## Use when
- Extract Method keeps failing because of many interdependent locals and parameters.
- Replace Temp with Query would not untangle the variables.
- The computation is complex enough to deserve its own object (and tests).

## Don't use when
- Simpler fixes work: Replace Temp with Query, Split Temporary Variable, or choosing a different fragment.
- The method is short; a new class is overhead.

## Mechanics
1. Create a class named after the method.
2. Add a read-only field for the original object (the source) and one field per parameter and per temp.
3. Write a constructor taking the source and all parameters.
4. Add a `compute`-style method and copy the original body into it, routing calls to the original object through the source field.
5. Compile/run the tests.
6. Make the original method create the object and call `compute`.
7. Extract smaller methods from `compute`; no parameters needed because state is in fields.

## Example (Python)
```python
# before
def gamma(self, a, q):
    v1 = a * q + self.delta()
    v2 = a * 10
    if v2 - v1 > 100:
        v2 -= 20
    return v2 * 7 - 2 * v1
# after
def gamma(self, a, q):
    return _Gamma(self, a, q).compute()
class _Gamma:
    def __init__(self, acct, a, q):
        self.acct, self.a, self.q = acct, a, q
    def compute(self):
        self.v1 = self.a * self.q + self.acct.delta()
        self.v2 = self.a * 10
        self._adjust()
        return self.v2 * 7 - 2 * self.v1
    def _adjust(self):
        if self.v2 - self.v1 > 100:
            self.v2 -= 20
```

## Language notes
- No IDE does this end to end; IntelliJ's "Replace Method with Method Object" exists, Rider/ReSharper offer similar; elsewhere do it by hand.
- Python: a callable class (`__call__`) or a dataclass fits well. TS/Java/C#: a small private/internal class. Go: a struct with methods.
- Inlining helper methods first can make this easier. Method objects hold mutable state; keep them short-lived and not shared across threads.

## Related
Extract Method, Replace Temp with Query, Inline Method. Smells: Long Method, Long Parameter List.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Replace Method with Method Object" (about pp. 111-114 of the supplied text's numbering).
