# Introduce Explaining Variable

## Intent
Name a piece of a complicated expression with a well-named local so the whole reads as a sequence of understandable parts.

## Use when
- A condition has several clauses and the reader must decode each one.
- A formula has steps that deserve names (base price, discount, shipping).
- Extract Method is hard because many locals are in play.
- You want to see the structure before deciding on a later extraction.

## Don't use when
- Extract Method works easily: a method is reusable across the class and usually preferable.
- The expression is already clear, or the name would only repeat it.
- A comment would be shorter and the expression is used only once (still, prefer a name).

## Mechanics
1. Pick a sub-expression and assign it to a new read-only local with an intention-revealing name.
2. Replace that sub-expression in the original with the local (repeat occurrences one at a time).
3. Run the tests.
4. Repeat for the other parts; delete comments the names made redundant.

## Example (Python)
```python
# before
if "MAC" in platform.upper() and "IE" in browser.upper() and resize > 0:
    relayout()
# after
is_mac = "MAC" in platform.upper()
is_ie = "IE" in browser.upper()
was_resized = resize > 0
if is_mac and is_ie and was_resized:
    relayout()
```

## Language notes
- IDEs: "Introduce Variable" / "Extract Variable" (IntelliJ, PyCharm, VS Code, Visual Studio, GoLand) and "Extract to constant/local" in TS.
- Python 3.8+: the walrus operator can introduce a name inside a condition, but a separate statement is clearer.
- Be wary of eager evaluation: pulling a clause into a variable defeats short-circuiting (for example a null check guarding a later clause).

## Related
Extract Method (preferred when possible), Replace Temp with Query, Inline Temp. Smells: Comments, Long Method.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Introduce Explaining Variable" (about pp. 102-105 of the supplied text's numbering).
