# Extract Subclass

## Intent
Create a subclass to hold features that apply only to some instances of a class, replacing flags or type codes with the hierarchy itself.

## Use when
- Some methods or fields matter only when a boolean/type code has a certain value.
- You want polymorphism instead of repeated `if is_x` checks.

## Don't use when
- The kind of an object must change after creation (a subclass is fixed at construction): use delegation / State / Strategy (Extract Class).
- The class already varies along another axis you inherit for; only one axis fits inheritance.

## Mechanics
1. Define the subclass; give it a constructor that calls the parent's.
2. Make callers that need the special case construct the subclass (consider a factory to hide the choice).
3. Tidy constructor parameters so each class takes only what it needs.
4. Push down methods one at a time, then the data they use; test after each.
5. Remove the flag/type-code field: expose it through a method each class answers with a constant, then replace conditionals with polymorphism.
6. If the parent can no longer stand alone, make it abstract.

## Example (Python)
Before:
```python
class Item:
    def __init__(self, price, qty, labor=False, rate=0):
        self.price, self.qty, self.labor, self.rate = price, qty, labor, rate
    def unit_price(self): return self.rate if self.labor else self.price
```
After:
```python
class Item:
    def __init__(self, price, qty): self.price, self.qty = price, qty
    def unit_price(self): return self.price
class LaborItem(Item):
    def __init__(self, qty, rate): super().__init__(0, qty); self.rate = rate
    def unit_price(self): return self.rate
```

## Language notes
- Python: constructors are not overloaded, so callers choose the class directly or via a factory function; `@dataclass` subclasses work but mind default ordering.
- TypeScript: discriminated unions are a lighter alternative for data-only variants.
- Java/C#: use a static factory and keep the parent constructor protected.
- Go: no subclassing; use an interface with two struct types or a strategy field.

## Related
Push Down Method/Field, Replace Type Code with Subclasses/State-Strategy, Replace Conditional with Polymorphism, Extract Class. Smells: Switch Statements, Temporary Field.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 268-273.
