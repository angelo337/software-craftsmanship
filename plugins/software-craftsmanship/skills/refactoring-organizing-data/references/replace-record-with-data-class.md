# Replace Record with Data Class

## Intent
Wrap a record-like structure from outside the object model (database row, JSON, legacy struct, dict) in a dedicated data class so the rest of the code deals with a typed object.

## Use when
- Untyped dicts or rows with known keys flow through the code.
- You interface with a legacy record, wire format or API payload.
- Key typos fail only at runtime.

## Don't use when
- The data is genuinely dynamic (arbitrary key-value bag).
- A generated or ORM model already exists for it; use that.

## Mechanics
1. Create a class that mirrors the record, one field per data item.
2. Give each field an accessor (or a typed public attribute in languages where that is idiomatic).
3. Convert at the boundary: one function that builds the object from the raw record, one that dumps it back.
4. Replace uses of the raw record with the class and test.
5. Treat this as a first step: later move behavior in, and separate persistence format from domain shape if they diverge.

## Example (Python)
```python
# before
row = {"id": "7", "name": "Ana", "balance": "12.50"}
total += float(row["balance"])

# after
from dataclasses import dataclass

@dataclass
class AccountRecord:
    id: int
    name: str
    balance: float

    @classmethod
    def from_row(cls, row: dict) -> "AccountRecord":
        return cls(int(row["id"]), row["name"], float(row["balance"]))

total += AccountRecord.from_row(row).balance
```

## Language notes
- Python: `dataclass`, `TypedDict` (typing only), `pydantic` for validation at the boundary.
- TypeScript: `interface` plus a parser (zod, io-ts) since types vanish at runtime.
- Java: `record`; C#: `record`; Go: struct with `json:` tags.
- Keep the class dumb at first; resist adding logic until the shape is stable.

## Related refactorings and smells
- Replace Array with Object, Encapsulate Field, Move Method.
- Smells: Primitive Obsession, Data Class (acceptable here as a boundary adapter).

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Record with Data Class". Page numbers were not reliably visible in the text extract.
