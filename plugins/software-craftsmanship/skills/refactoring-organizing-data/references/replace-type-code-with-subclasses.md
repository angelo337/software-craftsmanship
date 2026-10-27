# Replace Type Code with Subclasses

## Intent
Model each value of an immutable type code as a subclass so conditionals on the code can become polymorphic methods.

## Use when
- The code selects behavior in switch/if chains, and the object's kind never changes after creation.
- Some fields or methods are meaningful only for certain codes (push them down).
- New variants appear regularly.

## Don't use when
- The type must change during the object's lifetime: use State/Strategy.
- The class is already subclassed on another axis (single inheritance): use State/Strategy.
- No behavior depends on the code: Replace Type Code with Class is lighter.
- Language lacks inheritance (Go): use interfaces/composition.

## Mechanics
1. Self Encapsulate the type code.
2. If the code is a constructor argument, replace the constructor with a factory method.
3. Create one subclass per code, overriding the code accessor to return its fixed value; update the factory to build it; test after each subclass.
4. Remove the code field from the superclass and make the accessor abstract.
5. Run tests, then use Replace Conditional with Polymorphism and Push Down Method/Field.

## Example (Python)
```python
# before
class Account:
    BASIC, PREMIUM = 0, 1
    def __init__(self, kind): self.kind = kind
    def monthly_fee(self):
        if self.kind == Account.BASIC: return 0
        if self.kind == Account.PREMIUM: return 20
        raise ValueError(self.kind)

# after
class Account:
    @staticmethod
    def create(kind):
        return {"basic": BasicAccount, "premium": PremiumAccount}[kind]()
    def monthly_fee(self): raise NotImplementedError

class BasicAccount(Account):
    def monthly_fee(self): return 0
class PremiumAccount(Account):
    def monthly_fee(self): return 20
```

## Language notes
- Python: factory via dict of classes; `abc.ABC` for the abstract base.
- Java: abstract class or sealed hierarchy; C#: abstract class; TypeScript: abstract class or discriminated union with functions.
- Go: an interface with one struct per kind and a constructor function.
- Keep the single remaining switch inside the factory only.

## Related refactorings and smells
- Replace Conditional with Polymorphism, Push Down Method, Push Down Field, Replace Constructor with Factory Method, Self Encapsulate Field.
- Smells: Switch Statements, Parallel Inheritance Hierarchies (watch for them).

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Type Code with Subclasses". Page numbers were not reliably visible in the text extract.
