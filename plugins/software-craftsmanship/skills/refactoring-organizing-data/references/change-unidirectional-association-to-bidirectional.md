# Change Unidirectional Association to Bidirectional

## Intent
Add a back pointer so the referred-to class can navigate to its referrers, with one side controlling updates so both ends stay consistent.

## Use when
- A client of class B needs the A objects that reference it and no cheap alternative lookup exists.
- Navigating through a query or index would be more costly or awkward than a pointer.

## Don't use when
- You can find the other side another way (pass it as an argument, query a repository); two-way links add coupling and zombie-object risk.
- The association is rarely traversed backward.

## Mechanics
1. Add a field on the target class for the back pointer (a set for one-to-many, a reference for one-to-one).
2. Pick the controlling side: the "one" side in a one-to-many between references; the composite in a whole-part pair; either in many-to-many.
3. On the non-controlling side, add a narrowly scoped helper that gives the controller raw access to the back-pointer field; name it to warn others off.
4. If the existing modifier is on the controlling side, make it remove itself from the old target, set the new target, then add itself to the new target.
5. If the existing modifier is on the other side, make it delegate to the controller's modifier.
6. Add a test for the round trip: this is one of the few accessor changes that earns one.

## Example (Python)
```python
class Customer:
    def __init__(self): self._orders = set()
    def add_order(self, order): order.customer = self   # delegate to controller
    def _friend_orders(self): return self._orders        # only for Order

class Order:
    def __init__(self): self._customer = None
    @property
    def customer(self): return self._customer
    @customer.setter
    def customer(self, new):
        if self._customer: self._customer._friend_orders().discard(self)
        self._customer = new
        if new: new._friend_orders().add(self)

c, o = Customer(), Order()
c.add_order(o)
assert o in c._orders and o.customer is c
```

## Language notes
- Python: no package-private; rely on a leading underscore and a comment. Consider `weakref` for the back pointer to avoid cycles.
- Java: package-private helper; C#: `internal`; TypeScript: no friend access, so use a clearly named method or a shared module.
- Go: keep both types in one package and use unexported helpers.
- ORMs (SQLAlchemy `back_populates`, EF Core) maintain both ends for you: use them.

## Related refactorings and smells
- Change Bidirectional Association to Unidirectional (the inverse), Encapsulate Collection, Self Encapsulate Field.
- Smells: Inappropriate Intimacy (a controlled coupling here).

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Change Unidirectional Association to Bidirectional". Page numbers were not reliably visible in the text extract.
