# Replace Temp with Query

## Intent
Move the expression behind a temp into a method and call it wherever the temp was used. This lets other methods share it and frees the method of a local that blocks extraction.

## Use when
- A temp is assigned once from an expression that has no side effects.
- You plan to Extract Method and locals are in the way.
- Several methods recompute or need the same intermediate value.
- A temp accumulates in a simple loop (duplicate the loop into the query).

## Don't use when
- The temp is assigned several times (Split Temporary Variable first).
- The expression has side effects or is expensive and called many times with a measured cost; separate query from modifier or keep a cached temp.
- The value is a snapshot that must not change mid-method.

## Mechanics
1. Find a temp assigned exactly once; make it read-only to verify.
2. Extract its right-hand side into a method (start private).
3. Confirm the extracted expression has no side effects.
4. Run the tests.
5. Replace each temp reference with a call, then remove the temp.
6. Repeat for the next temp; later extractions get easier.

## Example (Python)
```python
# before
def price(self):
    base = self.qty * self.unit
    factor = 0.95 if base > 1000 else 0.98
    return base * factor
# after
def price(self):
    return self._base() * self._factor()
def _base(self):
    return self.qty * self.unit
def _factor(self):
    return 0.95 if self._base() > 1000 else 0.98
```

## Language notes
- Python: `@property` or `functools.cached_property` suits a pure, stable query (cache only if the inputs cannot change).
- TS/C#: getters/properties play the same role. Java/Go: plain (private) methods.
- IDEs have no one-click version; combine "Extract Method" with "Inline Variable".
- Performance: recomputation is usually cheap; measure before worrying.

## Related
Inline Temp, Split Temporary Variable, Extract Method, Separate Query from Modifier. Smell: Long Method.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Replace Temp with Query" (about pp. 98-102 of the supplied text's numbering).
