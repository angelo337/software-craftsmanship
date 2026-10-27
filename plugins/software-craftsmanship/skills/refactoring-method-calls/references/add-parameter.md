# Add Parameter

## Intent
Give a method an extra input it needs from its callers, while keeping the cost of longer signatures in mind.

## Use when
- The method's change requires information that no existing argument, field, or reachable object can provide.
- Several callers already hold that information and the callee cannot sensibly look it up.

## Don't use when
- An existing parameter (or `self`) can supply the data through a query: use that, or add a method to the object that owns the data.
- The behavior using the new data belongs on the object that has the data: Move Method instead.
- The list is already long or the new value belongs with existing ones: consider Introduce Parameter Object.
- The signature is public and the new parameter would break callers: add it with a default or create an overload.

## Mechanics
1. Check for superclass, subclass, or interface declarations of the same signature; handle each.
2. Create a new method with the extra parameter (add several at once if you need several) and copy the body.
3. Make the old method call the new one, passing a recognizable placeholder (None/null, or an odd sentinel for numbers, not 0) so unmigrated calls are easy to spot.
4. Run tests.
5. Migrate callers one at a time, supplying the real value; test after each.
6. Remove the old method, or deprecate it if it is public.
7. Run tests.

## Example (Python)
```python
# Before
def format_price(amount):
    return f"${amount:,.2f}"

# After: new keyword-only parameter with a default keeps old callers valid
def format_price(amount, *, currency="USD"):
    symbols = {"USD": "$", "EUR": "€"}
    return f"{symbols[currency]}{amount:,.2f}"

# callers migrate gradually: format_price(9.5, currency="EUR")
# once all callers pass it, delete the default if a missing value is now a bug
```

## Language notes
- Python: a defaulted keyword-only parameter (`*, currency="USD"`) replaces the delegating-method step and is safe for existing callers. Remove the default later if it hides forgotten call sites.
- TypeScript: optional parameter `currency?: string` or an options object; prefer an options object when more parameters may follow.
- Java/C#: add an overload that delegates (C# also allows optional parameters, but they bake defaults into callers at compile time).
- Go: no overloads or defaults; add a new function name or an options struct / functional options.

## Related
- Rename Method, Remove Parameter, Introduce Parameter Object, Preserve Whole Object, Replace Parameter with Method.
- Smells: Long Parameter List, Data Clumps.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 223.
