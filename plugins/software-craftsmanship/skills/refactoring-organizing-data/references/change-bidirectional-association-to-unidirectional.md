# Change Bidirectional Association to Unidirectional

## Intent
Remove the back pointer of a two-way link that is no longer pulling its weight, cutting coupling and zombie-object risk.

## Use when
- One class never needs to reach the other any more.
- Maintaining both ends keeps producing bugs or leaks (objects kept alive by stale references).
- The two classes live in different modules and the cycle is hurting dependencies.

## Don't use when
- A real client still needs backward navigation and has no substitute.
- Removing it forces awkward argument passing everywhere; check feasibility first.

## Mechanics
1. List every reader of the pointer field and the callers above them; decide if the removal is feasible.
2. For each reader, find another way to get the other object: pass it as an argument, look it up through a query/repository.
3. If clients need the getter, Self Encapsulate the field and rewrite the getter body (Substitute Algorithm) so it no longer uses the field.
4. Otherwise convert readers one at a time, testing after each.
5. When nothing reads the field, strip all writes (use a single setter first if writes are scattered, empty it, then delete it).
6. Delete the field and the controlling code on the other side, then run tests.

## Example (Python)
```python
# before: Order keeps customer, and uses it internally
class Order:
    def discounted_price(self):
        return self.gross * (1 - self.customer.discount)

# after: caller supplies the customer
class Order:
    def discounted_price(self, customer):
        return self.gross * (1 - customer.discount)

class Customer:
    def price_for(self, order):
        assert order in self.orders
        return order.discounted_price(self)   # customer passes itself in
```

## Language notes
- Python: replace with a lookup on the owning side or a repository query.
- If you keep the getter, the association is still two-way in the interface; the coupling remains.
- ORMs: drop `back_populates`/inverse navigation properties when queries suffice.
- Check serialization and caches that may silently depend on the back pointer.

## Related refactorings and smells
- Change Unidirectional Association to Bidirectional (the inverse), Substitute Algorithm, Self Encapsulate Field.
- Smells: Inappropriate Intimacy, Shotgun Surgery.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Change Bidirectional Association to Unidirectional". Page numbers were not reliably visible in the text extract.
