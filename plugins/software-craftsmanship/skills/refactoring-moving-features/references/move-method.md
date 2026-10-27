# Move Method

## Intent
Relocate a method to the class whose data it uses most, so behavior sits beside its data and coupling drops.

## Use when
- The method touches another object's fields or methods more than its own (feature envy).
- A class has too much behavior, or two classes collaborate so heavily they are tangled.
- You just moved a field and the methods using it should follow.

## Don't use when
- The method is overridden in subclasses and the target cannot carry the polymorphism.
- Usage is balanced and the choice is unclear; leave it and revisit after other moves.
- Moving it makes the target depend on something it should not know.

## Mechanics
1. List what the method uses on its home class; decide whether those pieces should move too (a cluster is often easier than one at a time).
2. Check super/subclasses for other declarations of the same method.
3. Declare the method on the target, possibly renaming it to fit the new context.
4. Copy the body and adapt: reach the old owner through a reference, a parameter (the object, or just the needed value).
5. Decide which class should handle any exceptions the body raises.
6. Work out how the source finds the target (existing field/method, or a new link).
7. Turn the source method into a one-line delegate; run tests.
8. Optionally inline the delegate by updating every caller, then delete it; run tests.

## Example (Python)
```python
# before
class Account:
    def overdraft_fee(self):
        return self.kind.base_fee + self.days_over * self.kind.daily_rate
# after: only the kind's data is used, so it moves there
class Kind:
    def overdraft_fee(self, days_over):
        return self.base_fee + days_over * self.daily_rate
class Account:
    def overdraft_fee(self):
        return self.kind.overdraft_fee(self.days_over)
```

## Language notes
- IDEs: PyCharm "Move Instance Method", IntelliJ/Eclipse/VS "Move Instance Method", Rider/ReSharper, GoLand (move func/method between types is limited; often manual). VS Code TS has "Move to file" only, so moving between classes is manual.
- Python: no compiler to catch missed callers; rely on tests, grep and type checking (mypy/pyright). Dynamic attribute access can hide callers.
- TS/Java/C#: the compiler finds stragglers after you delete the old method. Watch interface/virtual declarations.
- Go: methods belong to a type; moving means redefining on the other type and updating receivers.

## Related
Move Field (do it first when both are needed), Extract Method (shrink before moving), Extract Class, Hide Delegate. Smells: Feature Envy, Large Class, Shotgun Surgery.

## Source
Fowler et al. (1999), Chapter 7 (Move Method).
