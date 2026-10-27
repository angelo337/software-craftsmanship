# Acyclic Dependencies Principle (ADP)

## Core statement
The component dependency graph must have no cycles; it must be a directed acyclic graph.
Why: independent teams can work against released versions of what they use.
A cycle removes that independence (the "morning after" problem: yesterday's
working code breaks because someone changed what you depend on).

## Why cycles hurt
- Every member of a cycle effectively becomes one large component: same release, same version.
- Testing one member forces building all the others.
- Build order becomes ambiguous or impossible, and build trouble grows quickly with module count.
- Release impact is hard to trace; in a DAG you follow arrows backward to find who is affected.

## Symptoms
- A unit test of one module needs half the repo on the classpath.
- "Which do I build first?" has no answer; build tool reports circular dependency.
- Two packages import each other (directly or via a third).
- Releases must be coordinated across several teams.

## Fix steps
1. Detect: build the component graph, find strongly connected components (cycle sets).
2. Pick the edge that was added last or is semantically wrong direction.
3. Option A, DIP: define an interface in the component that needs the service;
   make the other component implement it. The edge now points the other way.
4. Option B, extract: move the classes both sides need into a new component both depend on.
5. Re-run detection; add a CI check that fails on any new cycle.
6. Expect cycles to return as the system grows: the structure is meant to evolve,
   so new components appearing is normal. Do not design the full graph upfront;
   it emerges from CCP, CRP and cycle-breaking.

## Example (original)
`orders` uses `Customer` from `accounts`; later `accounts.Customer` needs `orders.OrderHistory` for a credit check.
```
orders ---> accounts ---> orders      # cycle
```
Option A:
```python
# accounts/credit.py
class HistoryReader(Protocol):
    def total_spent(self, customer_id: str) -> int: ...
# orders/history.py implements HistoryReader; accounts no longer imports orders
```
Option B: move the shared `CustomerId` and money types into `shared_types`.
```
orders ---> accounts ---> (nothing from orders)
```

## Language notes
- Python: cycles between modules inside one package are tolerated at import time
  until they fail on partial init; between top-level packages, use `import-linter` or `pydeps`.
- npm workspaces: package.json cycles cause install/build-order issues; `madge --circular` finds file cycles.
- Java: Maven refuses cyclic modules; within a module, packages may still cycle (check with jdepend/ArchUnit).
- Go: the compiler forbids import cycles between packages, so the fix is mandatory (interfaces defined at the consumer).
- .NET: project references cannot be circular; namespaces inside an assembly can.

Source: Martin (2017), Ch. 14.
