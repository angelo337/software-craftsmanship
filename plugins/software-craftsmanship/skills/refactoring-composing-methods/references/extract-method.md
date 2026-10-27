# Extract Method

## Intent
Turn a cohesive fragment of code into its own method whose name states its purpose. Do it because a reader then sees the "what" at the call site and can skip the "how".

## Use when
- The method is long, or a block needs a comment to explain what it does.
- The same fragment appears in several places.
- A higher-level method should read like an outline of steps.
- Finer-grained methods would be easier to reuse or override.

## Don't use when
- The new name would not say more than the code itself.
- The fragment writes to several locals that are used afterwards and cannot be split (reduce temps first, or use Replace Method with Method Object).

## Mechanics
1. Create a new method named after the intent of the fragment, not its mechanism.
2. Copy the fragment into it.
3. List the locals and parameters of the source method that the fragment touches.
4. Temps used only inside the fragment: declare them in the new method.
5. Locals only read by the fragment: pass them as parameters.
6. A local assigned by the fragment and used afterwards: return it (one such variable is fine). If there are several, pick a different fragment, split the temp, replace temps with queries, or move to a method object.
7. Replace the fragment in the source with a call; delete now-unneeded declarations.
8. Run the tests.

## Example (Python)
```python
# before
def print_owing(self):
    total = 0.0
    for o in self.orders:
        total += o.amount
    print(f"name: {self.name}")
    print(f"amount: {total}")
# after
def print_owing(self):
    self._print_details(self._outstanding())
def _outstanding(self):
    return sum(o.amount for o in self.orders)
def _print_details(self, total):
    print(f"name: {self.name}")
    print(f"amount: {total}")
```

## Language notes
- Every mainstream IDE automates it: PyCharm/VS Code (Pylance, Rope) "Extract Method/Function", IntelliJ, Visual Studio/Rider, GoLand "Extract function", VS Code TS "Extract to function/method".
- Python: nested closures can read outer locals but need `nonlocal` to rebind them; prefer returning values. Return tuples for two outputs only if it stays readable.
- TypeScript/JS: extract as a private method or a module-level function; arrow functions capture locals implicitly (convenient, but hides coupling).
- Java/C#: output parameters are rare; return one value or use a small record. C# has local functions; Go has multiple return values, which relax the "one value out" rule.

## Related
Replace Temp with Query, Split Temporary Variable, Replace Method with Method Object, Inline Method (inverse). Smells: Long Method, Duplicated Code, Comments.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Extract Method" (about pp. 90-95 of the supplied text's numbering).
