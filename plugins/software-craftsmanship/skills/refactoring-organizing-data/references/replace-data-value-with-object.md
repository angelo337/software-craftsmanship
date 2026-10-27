# Replace Data Value with Object

## Intent
Promote a raw primitive (string, number) that has grown extra data or behavior into its own small class so the behavior has a home.

## Use when
- A phone number, money amount, customer name, or similar primitive needs formatting, validation, parsing, or extra attributes.
- The same helper functions on that primitive are duplicated across classes (Feature Envy, Primitive Obsession).
- Several fields always travel together (a Data Clump) and share rules.

## Don't use when
- The value has no behavior and no foreseeable attributes; a wrapper adds ceremony only.
- A language type already models it well (dates, decimals, URLs): use that instead of inventing one.

## Mechanics
1. Create a class for the value holding one immutable field of the original type, with a constructor and getter.
2. Change the owner's field to the new type; keep its public getter returning the primitive for now (delegate to the new object).
3. Update the owner's constructor/setter to build the new object from the primitive; treat it as a value (new instance per assignment).
4. Rename the owner's accessors to say whether they return the raw value or the object; adjust parameter names.
5. Run tests, then migrate behavior onto the new class with Move Method.
6. If instances must be shared and mutable later, continue with Change Value to Reference.

## Example (Python)
```python
# before
class Order:
    def __init__(self, customer: str): self.customer = customer
# callers: order.customer.upper() ... == name comparisons everywhere

# after
from dataclasses import dataclass

@dataclass(frozen=True)
class Customer:
    name: str
    def display(self) -> str: return self.name.title()

class Order:
    def __init__(self, customer_name: str):
        self._customer = Customer(customer_name)
    @property
    def customer_name(self) -> str: return self._customer.name
    @property
    def customer(self) -> Customer: return self._customer
```

## Language notes
- Python: `@dataclass(frozen=True)`, `NamedTuple`, or `typing.NewType` when only type-safety is wanted.
- TypeScript: a class or a branded type (`type Email = string & {__b: 'Email'}`) plus factory.
- Java: `record` (16+) gives equals/hashCode for free.
- C#: `record` or `readonly record struct`.
- Go: `type PhoneNumber string` with methods is the idiomatic cheap form; use a struct when there are several fields.

## Related refactorings and smells
- Change Value to Reference, Move Method, Introduce Parameter Object, Replace Type Code with Class.
- Smells: Primitive Obsession, Data Clumps, Feature Envy.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Data Value with Object". Page numbers were not reliably visible in the text extract.
