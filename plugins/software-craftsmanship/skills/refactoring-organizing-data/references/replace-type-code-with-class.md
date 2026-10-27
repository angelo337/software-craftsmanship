# Replace Type Code with Class

## Intent
Replace an integer or string code that merely labels something with a dedicated type, so the compiler/type checker rejects invalid values.

## Use when
- A numeric or string constant selects a category (blood group, status label) and no conditional behavior depends on it.
- Bugs come from passing unrelated integers or misspelled strings.
- The code needs a place for per-value data or helpers.

## Don't use when
- The code drives behavior in switch/if chains: use subclasses or State/Strategy.
- The set is open-ended and externally defined (arbitrary tags).

## Mechanics
1. Create a class (or enum) for the type, with one fixed instance per allowed code and a lookup from the raw code.
2. Switch the owner to store the new type while keeping the old code-based API temporarily, converting at the edges.
3. Run tests; the lookup now validates codes at runtime.
4. For each code-using method on the owner, add a version taking/returning the new type; rename old ones to mark them legacy.
5. Migrate clients one at a time, testing after each.
6. Delete the old code-based interface and the raw constants; privatize the code accessor.

## Example (Python)
```python
# before
class Person:
    O, A, B, AB = 0, 1, 2, 3
    def __init__(self, blood_group: int): self.blood_group = blood_group
Person(7)   # silently accepted

# after
from enum import Enum

class BloodGroup(Enum):
    O = "O"; A = "A"; B = "B"; AB = "AB"

class Person:
    def __init__(self, blood_group: BloodGroup):
        self.blood_group = blood_group
Person(BloodGroup("AB"))     # BloodGroup("X") raises ValueError
```

## Language notes
- Python: `enum.Enum` / `StrEnum` / `IntEnum` (use IntEnum only for legacy int interop).
- TypeScript: string-literal unions or `enum`; Java: `enum` (can carry fields and methods); C#: `enum` (not type-safe against casts) or a smart-enum class.
- Go: `type Color int` with `iota` constants and a `String()` method; validate at construction.
- Serialize by name, not ordinal, so reordering is safe.

## Related refactorings and smells
- Replace Type Code with Subclasses, Replace Type Code with State/Strategy, Replace Magic Number with Symbolic Constant, Move Method.
- Smell: Primitive Obsession.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Type Code with Class". Page numbers were not reliably visible in the text extract.
