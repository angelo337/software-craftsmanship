# Remove Assignments to Parameters

## Intent
Stop reassigning a parameter inside the body; use a local variable instead, so the parameter always means "what the caller passed".

## Use when
- Code does `param = ...`, `param -= ...` or similar.
- The reader must track whether the parameter currently holds the original or a computed value.
- You want to extract a method and the assigned parameter complicates it.

## Don't use when
- You only mutate the object the parameter refers to (that is a different concern).
- The language uses real output/reference parameters by design (C# `ref`/`out`, C++ references); prefer returning a value, but this is not a bug.

## Mechanics
1. Create a local initialized from the parameter.
2. Replace all references after the assignment with the local.
3. Change the assignment to target the local.
4. Run the tests.
5. For by-reference semantics, check whether callers use the changed value; return it (or a small object for several values) instead.

## Example (Python)
```python
# before
def discount(value, qty):
    if value > 50:
        value -= 2
    if qty > 100:
        value -= 1
    return value
# after
def discount(value, qty):
    result = value
    if value > 50:
        result -= 2
    if qty > 100:
        result -= 1
    return result
```

## Language notes
- Python rebinding a parameter never affects the caller, but mutating a list/dict argument does; also watch for mutable default arguments.
- Java: strictly pass by value of the reference; mark parameters `final` to enforce. JS/TS: ESLint `no-param-reassign`. C#: `ref`/`out` are explicit. Go: parameters are copies; pointers are the escape hatch.
- Linters (pylint `W0642`-style checks, SonarQube) can flag these.

## Related
Split Temporary Variable, Extract Method, Separate Query from Modifier. Smell: Long Method.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Remove Assignments to Parameters" (about pp. 108-111 of the supplied text's numbering).
