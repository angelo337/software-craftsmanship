# Replace Parameter with Explicit Methods

## Intent
Replace a method that branches on a flag, enum, or string argument with one method per value, so the call site says what it wants and the conditional disappears.

## Use when
- The body is an if/elif/switch over the parameter and each branch does something different.
- Callers always pass a literal (`save(True)`, `set_mode("fast")`), so the argument is really a method name in disguise.
- Invalid values are possible and you want the compiler or type checker to catch them.

## Don't use when
- Callers compute the value at runtime from data (then the dispatch belongs to them, or use a map/polymorphism).
- The set of values changes often: each new value means a new method. Use a plain setter if you only assign a field, or Replace Conditional with Polymorphism if behavior differs.
- The branches share most of their logic: Parameterize Method may be the better direction.

## Mechanics
1. Create an explicit method for each parameter value.
2. In the original method, replace each branch body with a call to the matching explicit method; test after each branch.
3. Change each caller to call the explicit method directly; test.
4. When no callers use the dispatching method, delete it (and any constants that only existed for it).

## Example (Python)
```python
# Before
class Light:
    def set_state(self, on):
        self._on = on
        self._log("on" if on else "off")

light.set_state(True)

# After
class Light:
    def turn_on(self):
        self._on = True
        self._log("on")

    def turn_off(self):
        self._on = False
        self._log("off")

light.turn_on()
```

## Language notes
- Python: `typing.Literal["a", "b"]` and `Enum` give some checking without splitting methods; split only if the call-site clarity is worth the extra API surface. Boolean flag arguments are the most common target; keyword-only (`*, urgent=False`) is a lighter alternative.
- TypeScript: string-literal unions or discriminated unions offer compile-time safety; explicit methods still read better for booleans.
- Java/C#: enum parameters give type safety; replace with explicit methods when each constant leads to different code.
- Go: no enums-as-types safety; separate functions (`NewEngineer`, `NewManager`) are idiomatic.

## Related
- Reverse: Parameterize Method. Related: Replace Constructor with Factory Method (explicit creation methods), Replace Conditional with Polymorphism, Replace Type Code with Subclasses.
- Smells: Switch Statements, Long Method, flag arguments.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 231.
