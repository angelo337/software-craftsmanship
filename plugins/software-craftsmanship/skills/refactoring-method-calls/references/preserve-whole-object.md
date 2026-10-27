# Preserve Whole Object

## Intent
Pass the object that several values came from, instead of extracting those values and passing them one by one, so the signature survives future needs for more data.

## Use when
- Callers write `f(obj.a, obj.b, obj.c)` (or compute those from the same source).
- The callee later needs another field and you would have to touch every caller.
- The callee does a lot with the values; the logic may belong on the whole object.

## Don't use when
- Passing the object would create an unwanted dependency, for example a low-level module learning about a high-level type, or a cycle.
- The values come from different objects or are independent concepts.
- The callee should stay usable with plain values (tests, scripts) and the object type is heavy.

## Mechanics
1. Add a parameter for the whole object (the old parameters stay for now).
2. Run tests.
3. Pick one old parameter and replace its uses in the body with calls on the whole object.
4. Remove that parameter from the signature and callers; test.
5. Repeat for each parameter obtainable from the object.
6. Delete caller code that only existed to extract the values.
7. Consider moving logic into the whole object (Move Method).

## Example (Python)
```python
# Before
def within_plan(room, plan):
    low, high = room.temps.low, room.temps.high
    return plan.within_range(low, high)

class Plan:
    def within_range(self, low, high):
        return low >= self.range.low and high <= self.range.high

# After
def within_plan(room, plan):
    return plan.within_range(room.temps)

class Plan:
    def within_range(self, temps):
        return self.range.includes(temps)   # logic moved to TempRange
```

## Language notes
- Python: use `typing.Protocol` to depend on the few attributes you need instead of a concrete class, which reduces the coupling cost.
- TypeScript: accept an interface/structural type (`{low: number; high: number}`), which keeps callers decoupled.
- Java/C#: pass an interface the object implements; avoid pulling a heavy entity into a utility.
- Go: define a small interface at the consumer side (`interface{ Low() int; High() int }`).

## Related
- Introduce Parameter Object (when no whole object exists), Move Method (when the callee uses many fields of the argument), Replace Parameter with Method, Remove Parameter.
- Smells: Long Parameter List, Feature Envy, Data Clumps.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 233.
