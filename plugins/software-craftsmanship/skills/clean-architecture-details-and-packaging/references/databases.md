# Databases Are Details

## Core statement
The shape of your data (the data model) is architecturally significant. The database product, SQL dialect, tables and ORM are mechanisms for moving bytes between disk and memory. Keep them in the outermost ring so use cases and entities never learn them. Rationale: once data is in RAM you reshape it into lists, maps and trees anyway; tables are just a storage convenience born from slow disks.

## Symptoms
- Use cases import the ORM, session, or SQL strings.
- ORM entities (with lazy-loading or annotations) are returned by services and rendered by the UI.
- Business rules cannot be unit-tested without a running DB.
- Changing a column forces edits in controllers and templates.
- A DBMS was chosen on day one before the access patterns were known.
- Performance tuning (denormalizing, indexes) alters domain classes.

## How to apply
1. Write the use case against a small gateway interface named in domain language (`Orders`, `Customers`), not `OrderTable` or `OrderDao`.
2. Define plain domain entities or DTOs. Map ORM rows to them inside the adapter.
3. Start with an in-memory or file adapter; it makes tests fast and delays the DBMS decision.
4. Implement the real adapter (SQL, document store, search index) in an outer module; wire it in Main.
5. Keep performance work inside the adapter: indexes, caching, batching, read models.
6. If stakeholders demand a particular DBMS for non-technical reasons, add it as an adapter on the side through a narrow channel rather than moving it into the core.

## Example (Python)
```python
from typing import Protocol

class Orders(Protocol):                      # domain-owned port
    def by_customer(self, cid: str) -> list["Order"]: ...

class InMemoryOrders:                        # tests, early development
    def __init__(self, items): self.items = items
    def by_customer(self, cid): return [o for o in self.items if o.cid == cid]

class SqlOrders:                             # outer ring; rows never escape
    def __init__(self, conn): self.conn = conn
    def by_customer(self, cid):
        rows = self.conn.execute("select id, total from orders where cid=?", (cid,))
        return [Order(id=r[0], cid=cid, total=r[1]) for r in rows]
```

## Language and framework notes
- JPA/Hibernate, Django ORM, SQLAlchemy, Prisma, TypeORM: treat their model classes as persistence models; map to separate domain types when the domain has real rules. For simple CRUD, a shared model is a conscious trade-off.
- Repositories in Spring Data or Django managers are adapters; keep their interfaces out of use-case signatures.
- Search engines, object stores and data lakes are databases too; the same rule applies.

## Common over-application
- Mapping every row to a separate class in a trivial CRUD app. Accept the coupling there, and isolate it when the domain grows.
- Believing "detail" means unimportant: schema design, transactions and query cost still need care.
- Building multiple store implementations nobody will use. One real adapter plus an in-memory fake is usually enough.

## Source
Martin (2017), Ch. 30 The Database Is a Detail.
