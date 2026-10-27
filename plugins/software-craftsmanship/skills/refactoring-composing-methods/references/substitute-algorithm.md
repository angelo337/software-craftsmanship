# Substitute Algorithm

## Intent
Replace the body of a method with a different, clearer algorithm that yields the same results.

## Use when
- You found a simpler way to solve the same problem.
- A library or built-in already does what your hand-written code does.
- A planned behavior change is easier after switching to a clearer algorithm.
- The method is already decomposed as far as possible and is still hard to follow.

## Don't use when
- The old algorithm is large and not yet broken into small methods (decompose first; big swaps are risky).
- You have no tests to prove equivalence.
- Performance or edge-case behavior of the old code is relied upon and unknown.

## Mechanics
1. Prepare the alternative algorithm so it compiles/runs.
2. Run the existing tests against it; if all pass, finish.
3. If results differ, keep the old version alongside and run both on each failing case to see where they diverge.
4. Fix the new version (or learn that the old one was wrong, and decide deliberately).
5. Delete the old version.

## Example (Python)
```python
# before
def found_person(people):
    for p in people:
        if p == "Don":
            return "Don"
        if p == "John":
            return "John"
        if p == "Kent":
            return "Kent"
    return ""
# after
def found_person(people):
    wanted = {"Don", "John", "Kent"}
    return next((p for p in people if p in wanted), "")
```

## Language notes
- No automated IDE refactoring; rely on tests (property-based or differential testing helps: run old and new on many random inputs).
- Python: stdlib (`itertools`, `any/all`, `sum`, `sorted`, `collections`) often replaces loops. Java: Streams/Collections. C#: LINQ. TS: array methods. Go: `slices`/`maps` packages.
- Keep behavior on edge cases: ordering, ties, empty input, None/null, overflow.

## Related
Extract Method (decompose first), Inline Method. Smells: Duplicated Code, Long Method, reinvented library code.

## Source
Fowler et al. (1999), Refactoring, ch. 6, "Substitute Algorithm" (about pp. 114-115 of the supplied text's numbering).
