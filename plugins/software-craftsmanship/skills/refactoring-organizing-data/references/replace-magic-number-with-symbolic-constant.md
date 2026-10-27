# Replace Magic Number with Symbolic Constant

## Intent
Give a literal with special meaning a name, so readers see why it is there and you change it in one place.

## Use when
- A literal (9.81, 86400, 0.21, 3) carries domain meaning, or appears in several places.
- A reader must guess what the number is for.

## Don't use when
- The literal is self-evident (0, 1, -1 as index/step; 2 in `x / 2`) and naming it adds noise.
- The number is a type code: use Replace Type Code with Class or an enum.
- It is an array length: iterate over the collection instead.
- The value is configuration that varies per environment: use config, not a constant.

## Mechanics
1. Declare a constant with the literal's value, named for its meaning, not its value.
2. Find every occurrence and check each truly has the same meaning before replacing; equal digits can mean different things.
3. Replace matching occurrences and run the build.
4. Test; changing the constant's value temporarily is a good check that all uses are wired.

## Example (Python)
```python
# before
def potential_energy(mass, height):
    return mass * 9.81 * height

# after
from typing import Final

GRAVITATIONAL_ACCELERATION: Final = 9.81   # m/s^2

def potential_energy(mass, height):
    return mass * GRAVITATIONAL_ACCELERATION * height
```

## Language notes
- Python: module-level `UPPER_CASE` with `typing.Final`; use `enum.Enum`/`IntEnum` for related sets.
- TypeScript: `const` (or `as const` objects, `enum`); Java: `static final`; C#: `const` for compile-time values, `static readonly` otherwise.
- Go: `const` with typed values and `iota` for sequences.
- Include the unit in the name or a comment when it matters.

## Related refactorings and smells
- Replace Type Code with Class, Extract Variable, Introduce Parameter Object.
- Smell: Magic Numbers (a classic readability smell).

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Magic Number with Symbolic Constant". Page numbers were not reliably visible in the text extract.
