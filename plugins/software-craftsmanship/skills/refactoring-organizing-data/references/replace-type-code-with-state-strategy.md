# Replace Type Code with State/Strategy

## Intent
Delegate type-dependent behavior to a separate state (or strategy) object chosen by the code, when subclassing the owner is impossible.

## Use when
- The code drives behavior and the object can change kind over its life (promotion, status changes).
- The owner is already subclassed for another reason.
- You want to swap algorithms at runtime.

## Don't use when
- Kind is fixed at creation and the class is free to subclass: Replace Type Code with Subclasses is simpler.
- No behavior varies by code: use Replace Type Code with Class.
- Only one trivial branch exists; the extra objects aren't worth it.

## Mechanics
1. Self Encapsulate the type code.
2. Create a state class named for the purpose of the code, with an abstract code query.
3. Add one subclass per code, each returning its code. Add them all at once.
4. Add a field in the owner for the state object.
5. Change the owner's code getter to delegate, and its setter to assign the right state subclass.
6. Test, then move code-to-state mapping into a factory on the state class, remove the old constants from the owner.
7. Apply Replace Conditional with Polymorphism so behavior moves into the states.

## Example (Python)
```python
# before: plan can change at runtime
class Subscription:
    def __init__(self, plan): self.plan = plan
    def price(self, seats):
        if self.plan == "free": return 0
        if self.plan == "team": return 8 * seats
        raise ValueError(self.plan)

# after
class Plan:
    def price(self, seats): raise NotImplementedError
    @staticmethod
    def named(n): return {"free": Free, "team": Team}[n]()
class Free(Plan):
    def price(self, seats): return 0
class Team(Plan):
    def price(self, seats): return 8 * seats

class Subscription:
    def __init__(self, plan): self._plan = Plan.named(plan)
    def change_plan(self, plan): self._plan = Plan.named(plan)
    def price(self, seats): return self._plan.price(seats)
```

## Language notes
- Name it State when the object transitions between kinds, Strategy when you swap one algorithm; the mechanics are identical.
- Python: plain classes, or callables/dict of functions for simple strategies.
- TypeScript: interface + objects, or a map of functions; Java/C#: interface or abstract class; enums with abstract methods work in Java.
- Go: an interface field set by the owner; idiomatic and cheap.

## Related refactorings and smells
- Replace Type Code with Subclasses, Replace Conditional with Polymorphism, Replace Constructor with Factory Method, Self Encapsulate Field.
- Smells: Switch Statements.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Replace Type Code with State/Strategy". Page numbers were not reliably visible in the text extract.
