# Replace Parameter with Method

## Intent
Remove a parameter whose value the callee can obtain itself (by calling a method or reading its own state), shortening signatures and removing a way for callers to pass inconsistent values.

## Use when
- The caller computes a value from state both sides can see, then passes it down.
- The calculation does not depend on the caller's other arguments or local variables.
- The callee already has a reference to the object that knows the answer.

## Don't use when
- The value depends on the caller's parameters or locals that vary per call.
- The callee has no access to the source and giving it one would create an unwanted dependency.
- You are keeping the parameter for a planned variation: still remove it; re-add when the variation exists, unless changing the interface is truly painful (long builds, embedded code, published API).

## Mechanics
1. If the computation is inline, extract it into a method.
2. In the callee's body, replace each use of the parameter with a call to that method; test after each.
3. Apply Remove Parameter to the now-unused parameter (delegate, migrate callers, delete old).
4. Delete caller temporaries that existed only to feed it.

## Example (Python)
```python
# Before
class Order:
    def total(self):
        base = self.qty * self.unit_price
        tier = 2 if self.qty > 100 else 1
        return self._discounted(base, tier)

    def _discounted(self, base, tier):
        return base * (0.10 if tier == 2 else 0.05)

# After
class Order:
    def total(self):
        return self._discounted()

    def _tier(self):
        return 2 if self.qty > 100 else 1

    def _base(self):
        return self.qty * self.unit_price

    def _discounted(self):
        return self._base() * (0.10 if self._tier() == 2 else 0.05)
```

## Language notes
- Python: `@property` or `functools.cached_property` suits derived values that are pure; avoid caching if inputs mutate.
- TypeScript: getters work the same; beware of derived values that must stay in sync with mutated fields.
- Java/C#: private helper methods; with injected collaborators, let the callee ask the collaborator instead of receiving its answer.
- Go: unexported methods on the receiver; keep them cheap or document cost.

## Related
- Remove Parameter, Extract Method, Inline Method (often the last step), Preserve Whole Object (alternative when the caller holds an object).
- Smells: Long Parameter List, Temp variables that only forward values.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 236.
