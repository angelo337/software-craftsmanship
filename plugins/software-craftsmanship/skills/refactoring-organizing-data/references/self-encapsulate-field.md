# Self Encapsulate Field

## Intent
Make a class read and write its own fields only through accessors, so subclasses and future logic (validation, laziness, notification, computed values) can hook in without touching every use site.

## Use when
- A subclass must replace a superclass field's value with a computed or capped one.
- You need lazy initialization, validation, or change notification on a field already used in many places.
- It is the preparatory step for Replace Type Code with Subclasses/State-Strategy or Duplicate Observed Data.

## Don't use when
- The field is private, simple and nothing varies; direct access reads better.
- The team convention is direct access and no hook is needed yet. Do it when it starts to hurt; this refactoring is cheap later.
- Python/C#/Kotlin: a plain attribute can later become a property without changing callers, so adding accessors up front is noise.

## Mechanics
1. Create a getter and a setter for the field (setter only if the field is ever reassigned).
2. Replace every read inside the class with the getter and every assignment with the setter.
3. Temporarily rename the field, or let the compiler/linter flag leftovers, to prove no direct access remains.
4. Make the field private.
5. Decide how the constructor initializes: setters often hold change-time logic that must not run during construction, so use direct assignment or a dedicated init method there.
6. Run the tests.

## Example (Python)
```python
# before
class Range:
    def __init__(self, low, high): self._low, self._high = low, high
    def includes(self, x): return self._low <= x <= self._high

# after: reads go through properties
class Range:
    def __init__(self, low, high): self._low, self._high = low, high
    @property
    def low(self): return self._low
    @property
    def high(self): return self._high
    def includes(self, x): return self.low <= x <= self.high

class CappedRange(Range):          # now overridable without edits to Range
    def __init__(self, low, high, cap):
        super().__init__(low, high); self._cap = cap
    @property
    def high(self): return min(super().high, self._cap)
```

## Language notes
- Python: use `@property`; subclasses override the property. Skip until needed.
- TypeScript: `get`/`set` accessors; `#private` or `private` fields.
- Java: plain getters; make them non-final so subclasses can override.
- C#: `virtual` properties; auto-properties are enough until logic is needed.
- Go: no inheritance, so the payoff is smaller; use unexported fields plus methods, and an interface if variation is needed.

## Related refactorings and smells
- Replace Type Code with Subclasses, Replace Type Code with State/Strategy, Duplicate Observed Data, Encapsulate Field.
- Smell: Inappropriate Intimacy between a subclass and superclass fields.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Self Encapsulate Field". Page numbers were not reliably visible in the text extract.
