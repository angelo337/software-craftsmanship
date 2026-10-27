# Replace Array with Object

## Intent
Replace a list/tuple whose positions mean different things with a class whose named fields say what each slot is.

## Use when
- Code reads like `row[0]`, `row[1]` with a convention about what each index holds.
- Slots have different types or meanings; the array is not a homogeneous collection.
- Parsing/formatting of the slots is repeated by several callers.

## Don't use when
- The elements really are homogeneous (a list of scores, points): keep the collection.
- Short-lived local pair/triple where a named tuple is enough.

## Mechanics
1. Create a class that initially wraps the array in a field and expose it temporarily.
2. Switch all creators and users to the wrapper and run tests.
3. One slot at a time, add an accessor named for its purpose (converting types inside it) and move clients to it; test after each.
4. When no client touches the raw array, make it private.
5. Replace each slot with a real field and point the accessor at it; test after each.
6. Delete the array, then look for behavior to move onto the class.

## Example (Python)
```python
# before
row = ["Liverpool", "15"]
name = row[0]
wins = int(row[1])

# after
from dataclasses import dataclass

@dataclass
class Performance:
    name: str
    wins: int

row = Performance(name="Liverpool", wins=15)
name, wins = row.name, row.wins
# parse CSV-style input once, at the boundary:
row = Performance(vals[0], int(vals[1]))
```

## Language notes
- Python: `dataclass`, `NamedTuple`, or `TypedDict` if you must stay dict-shaped.
- TypeScript: an `interface`/`type` with named props (tuples with labels are a stopgap).
- Java: `record`; C#: `record`; Go: a `struct` with typed fields.
- Parse text-to-number conversion inside the accessor/factory, not at call sites.

## Related refactorings and smells
- Replace Record with Data Class, Move Method, Introduce Parameter Object.
- Smells: Primitive Obsession, Data Clumps.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Array with Object". Page numbers were not reliably visible in the text extract.
