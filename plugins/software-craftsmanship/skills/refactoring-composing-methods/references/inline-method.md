# Inline Method

## Intent
Replace calls to a method with its body and delete the method, when the body is as clear as the name. This removes indirection that adds nothing.

## Use when
- The method only delegates or restates a trivial expression.
- A group of badly factored methods should be merged and then re-extracted differently.
- You are about to use Replace Method with Method Object and want the helper behavior in one place.
- Delegation chains make it hard to find where work happens.

## Don't use when
- Subclasses override the method (polymorphism would break).
- The method is recursive, has multiple return points, or lives in another object without accessors; these make inlining messy, so leave it.
- The name carries meaning the body lacks.
- It is public API used outside your control.

## Mechanics
1. Verify the method is not overridden.
2. Find every call site.
3. Replace each call with the body, adapting arguments to parameter names.
4. Run the tests (after each call site if there are many).
5. Delete the method definition.

## Example (Python)
```python
# before
def rating(self):
    return 2 if self._more_than_five_late() else 1
def _more_than_five_late(self):
    return self.late_deliveries > 5
# after
def rating(self):
    return 2 if self.late_deliveries > 5 else 1
```

## Language notes
- IDEs: "Inline Method/Function" in IntelliJ, PyCharm, VS Code TS, Visual Studio, GoLand; they refuse or warn on overridden or recursive methods.
- Python: dynamic dispatch means tools cannot always find all callers (getattr, mocks); grep tests and dynamic uses manually.
- Java/C#: check virtual/override and interface implementations. Go: no overriding, so safer, but check exported symbols.

## Related
Extract Method (inverse), Inline Temp. Smells: Middle Man, Speculative Generality.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Inline Method" (about pp. 96-97 of the supplied text's numbering).
