# Replace Subclass with Fields

## Intent
Collapse subclasses that differ only by constant-returning methods into one class holding those constants as fields.

## Use when
- Subclasses override only methods that return hard-coded values.
- The hierarchy carries no variant behavior, so each subclass is dead weight (Lazy Class).

## Don't use when
- Subclasses hold real behavior differences or are expected to soon.
- Callers rely on `isinstance` checks you can't first replace.
- Many instances share a few fixed variants: consider an enum with fields, which achieves the same thing.

## Mechanics
1. Replace each subclass constructor call with a factory method on the superclass.
2. Replace remaining references to the subclasses with the superclass.
3. Add immutable fields on the superclass for each constant method, and a constructor that sets them.
4. Have each subclass call that constructor.
5. Implement each constant method in the superclass to return its field; remove it from the subclasses; test after each.
6. Inline the subclass constructor into the factory method, delete the now-empty subclass, and repeat for the rest.

## Example (Python)
```python
# before
class Person:
    def is_male(self): raise NotImplementedError
    def code(self): raise NotImplementedError
class Male(Person):
    def is_male(self): return True
    def code(self): return "M"
class Female(Person):
    def is_male(self): return False
    def code(self): return "F"

# after
class Person:
    def __init__(self, is_male: bool, code: str):
        self._is_male, self._code = is_male, code
    def is_male(self): return self._is_male
    def code(self): return self._code
    @staticmethod
    def create_male(): return Person(True, "M")
    @staticmethod
    def create_female(): return Person(False, "F")
```

## Language notes
- Python: also consider a frozen dataclass or `Enum` whose members carry values.
- Java: an enum with constructor fields; C#: static readonly instances; TypeScript: object literals typed with an interface.
- Go: a struct with fields and constructor functions; there is rarely a subclass to remove.
- Update serialization and `isinstance` checks before deleting classes.

## Related refactorings and smells
- Replace Constructor with Factory Method, Inline Method, Replace Type Code with Subclasses (the opposite direction).
- Smell: Lazy Class.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Subclass with Fields". Page numbers were not reliably visible in the text extract.
