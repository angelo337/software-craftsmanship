# Parameterize Method

## Intent
Collapse several near-duplicate methods that differ only in a literal value into one method that takes that value as an argument.

## Use when
- Methods like `add_five_percent()` and `add_ten_percent()` have identical bodies except for a constant.
- A tiered calculation repeats the same arithmetic with different range boundaries.
- You expect more variants of the same shape.

## Don't use when
- The variants differ in logic, not just values: that is Replace Parameter with Explicit Methods territory.
- The values are a closed set of meaningful named modes and callers benefit from named entry points (`turn_on()` beats `set_state(True)`).
- Only part of the body is repetitive: first Extract Method on that fragment, then parameterize the extracted method.

## Mechanics
1. Write one method whose parameters cover the differing values; make it general enough for all variants.
2. Run tests.
3. Replace the body of one old method with a call to the new method, passing its constants.
4. Run tests; repeat for each old method.
5. Once callers can pass values directly, migrate them and delete the thin wrappers (or keep a wrapper when the name carries domain meaning).

## Example (Python)
```python
# Before
def usage_low(units):  return min(units, 100) * 0.03
def usage_mid(units):  return max(min(units, 200) - 100, 0) * 0.05
def usage_high(units): return max(units - 200, 0) * 0.07

# After
def usage_in_band(units, start, end, rate):
    return max(min(units, end) - start, 0) * rate

def bill(units):
    return (usage_in_band(units, 0, 100, 0.03)
            + usage_in_band(units, 100, 200, 0.05)
            + usage_in_band(units, 200, float("inf"), 0.07))
```

## Language notes
- Python: default values and keyword arguments keep call sites readable; `float("inf")` and `math.inf` model open-ended bands.
- TypeScript: use a typed union for the parameter if values are a closed set (`"low" | "mid"`), which keeps type safety.
- Java/C#: an enum or constant table (map of band to rate) can replace the parameters when the values are fixed data.
- Go: pass a small struct for several related values; table-driven data often removes the methods entirely.

## Related
- Reverse: Replace Parameter with Explicit Methods. Related: Extract Method, Introduce Parameter Object (when several parameters travel together), Replace Magic Number with Symbolic Constant.
- Smells: Duplicated Code.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 229.
