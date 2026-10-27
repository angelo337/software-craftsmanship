# Encapsulate Collection

## Intent
Stop exposing a mutable collection: return a read-only view and offer add/remove operations so the owner sees every change.

## Use when
- A getter returns the internal list/set/dict and callers mutate it.
- A setter replaces the whole collection and the owner can't intercept it.
- Callers repeat loops and counts that belong on the owner.

## Don't use when
- The collection is an intentionally public, standalone data structure with no invariants.
- A read-only view is too costly and callers never mutate (copy instead, or document).

## Mechanics
1. Add `add`/`remove` methods on the owner and initialize the field to an empty collection.
2. Find setter callers: have them use add/remove, or make the setter copy the elements in (rename it `initialize`/`replace`, never store the caller's object).
3. Find getter callers that mutate and switch them to add/remove, testing each.
4. Change the getter to return a read-only view (or a copy where views don't exist).
5. Look at what callers do with the result; Extract and Move Method for counts, filters and sums onto the owner.
6. Replace arrays with a proper collection while here, if convenient.

## Example (Python)
```python
# before
class Person:
    def __init__(self): self.courses = []
p = Person(); p.courses.append(Course("Refactoring", True))

# after
class Person:
    def __init__(self): self._courses = []
    @property
    def courses(self):
        return tuple(self._courses)        # read-only snapshot
    def add_course(self, c): self._courses.append(c)
    def remove_course(self, c): self._courses.remove(c)
    def initialize_courses(self, cs):
        assert not self._courses
        self._courses.extend(cs)           # copy, don't alias
    @property
    def number_of_advanced_courses(self):
        return sum(c.is_advanced for c in self._courses)
```

## Language notes
- Python: return `tuple(...)`, `frozenset`, or `types.MappingProxyType` for dicts; a copy is O(n), a proxy is a live view.
- Java: `Collections.unmodifiableList` (view) or `List.copyOf` (snapshot).
- C#: expose `IReadOnlyList<T>`/`IReadOnlyCollection<T>`, or `ImmutableArray<T>`; `AsReadOnly()` wraps a list.
- TypeScript: `ReadonlyArray<T>`/`readonly T[]` (compile-time only; copy if you need runtime safety).
- Go: slices are references, so return `slices.Clone(s)` or an iterator; never return the backing slice.
- Read-only views are still live and shallow: elements remain mutable.

## Related refactorings and smells
- Encapsulate Field, Extract Method, Move Method, Replace Array with Object, Remove Setting Method.
- Smells: Data Class, Feature Envy, Inappropriate Intimacy.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Encapsulate Collection". Page numbers were not reliably visible in the text extract.
