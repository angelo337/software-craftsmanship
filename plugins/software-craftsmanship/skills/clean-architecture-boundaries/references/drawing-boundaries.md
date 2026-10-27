# Drawing Boundaries

## Core statement
A boundary separates what matters (business rules) from what does not (UI, database,
frameworks), with every crossing dependency pointing at the business side. Early lines
exist to defer premature decisions; later lines appear when an axis of change shows up.

## Symptoms
- Business code imports the ORM, web framework, or SQL strings.
- A schema or page-layout change breaks domain logic or its tests.
- The database or web framework was chosen first and shapes the domain model.
- Tests need a running database to check a pricing rule.
- A team built a distributed topology for scale that was never needed.

## How to apply
1. List components: core rules, plus each optional or replaceable function (UI, storage, delivery).
2. For each pair, ask "does one care about the other?" Draw the line where one does not.
3. Put the interface in the inner (business) component; the outer component implements it.
4. Start with stubs, then in-memory, then a cheap real implementation (file); choose the
   heavy technology last, possibly never.
5. Check by swapping: could the UI or store be replaced without touching the core?
6. Justify each line by an axis of change (different reasons, different rates).

## Example (Python)
```python
from typing import Protocol

class InvoiceStore(Protocol):          # owned by business side
    def save(self, invoice_id: str, total_cents: int) -> None: ...

def issue_invoice(store: InvoiceStore, invoice_id: str, items: list[int]) -> int:
    total = sum(items)
    store.save(invoice_id, total)
    return total

class MemoryStore:                      # detail; SQL/file version comes later
    def __init__(self): self.rows = {}
    def save(self, invoice_id, total_cents): self.rows[invoice_id] = total_cents

assert issue_invoice(MemoryStore(), "a1", [100, 250]) == 350
```

## Language notes
- Python: `Protocol` or ABC; duck typing makes the line implicit, so enforce it with import rules.
- TypeScript: `interface` in the domain package; ban domain imports of adapters via lint (eslint boundaries, dependency-cruiser).
- Java/C#: interface in the core module, enforced by module or assembly references.

## Common over-application
- A boundary for every class, with no axis of change behind it.
- Treating the database as "the" detail while ignoring other real axes.
- Interfaces shaped by the implementation (leaky), which defeats the swap.

Source: Martin (2017), Ch. 17.
