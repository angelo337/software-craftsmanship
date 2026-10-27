# Introduce Parameter Object

## Intent
Replace a group of parameters that always travel together with a single small object, then move related behavior into it.

## Use when
- The same 2-4 parameters appear across several signatures (start/end, x/y/z, street/city/postcode, min/max).
- The method bodies repeat the same checks or computations on those values.
- Adding one more related value would mean editing many signatures.

## Don't use when
- The parameters are unrelated, or only one method uses them and the group has no domain meaning.
- Concurrent code relies on passing independent immutable values; a shared mutable object would be a hazard (make the new object immutable, or skip).
- A whole object already exists: use Preserve Whole Object.

## Mechanics
1. Create an immutable class for the group (frozen dataclass, record, readonly struct); compile.
2. Add a parameter of the new type to the target method; give existing callers a placeholder (None) or keep the old signature delegating to the new.
3. Remove one old parameter at a time: read it from the object in the body, update callers to build the object; test after each.
4. When all are gone, look for logic that can move into the new class (containment checks, validation, formatting): Extract Method then Move Method.

## Example (Python)
```python
# Before
def flow_between(entries, start, end):
    return sum(e.amount for e in entries if start <= e.date <= end)

# After
@dataclass(frozen=True)
class DateRange:
    start: date
    end: date
    def includes(self, d):
        return self.start <= d <= self.end

def flow_between(entries, period: DateRange):
    return sum(e.amount for e in entries if period.includes(e.date))

# caller: flow_between(entries, DateRange(date(2025, 1, 1), date(2025, 3, 31)))
```

## Language notes
- Python: `@dataclass(frozen=True)`, `NamedTuple`, or `TypedDict` (data only). Validate in `__post_init__`.
- TypeScript: an interface plus a factory/helper functions; `Readonly<T>`.
- Java: `record DateRange(LocalDate start, LocalDate end)` (Java 16+), with compact-constructor validation.
- C#: `record` or `readonly record struct`.
- Go: a small struct passed by value; add methods to it.

## Related
- Preserve Whole Object, Add Parameter, Remove Parameter, Move Method, Extract Class, Replace Data Value with Object.
- Smells: Data Clumps, Long Parameter List, Primitive Obsession.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 239.
