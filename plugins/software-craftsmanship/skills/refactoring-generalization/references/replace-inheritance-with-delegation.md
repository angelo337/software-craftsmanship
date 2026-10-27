# Replace Inheritance with Delegation

## Intent
Stop subclassing a class you only partly want: hold an instance of it in a field and forward only the operations you need.

## Use when
- The subclass uses just part of the parent's interface, so the inherited API misrepresents it.
- It inherits data or protected methods that make no sense for it.
- Substitutability fails (a Stack that is-a List and allows insertion in the middle).

## Don't use when
- The subclass honors the entire parent contract and uses most of it: inheritance is fine and the forwarding methods would be pure boilerplate.
- Clients rely on instanceof/isinstance with the parent and you cannot update them.

## Mechanics
1. In the subclass add a field referencing the superclass type, initialized to `self`/`this`.
2. Rewrite each subclass method to go through the field; test after each. (Methods calling the parent version of themselves can wait: they would recurse.)
3. Remove the extends clause and assign a fresh instance to the field.
4. Add a simple forwarding method for each parent method clients still use.
5. Compile/test; a missed forwarder shows up as a failure.

## Example (Python)
Before:
```python
class Stack(list):
    def push(self, x): self.insert(0, x)
    def pop(self):     return super().pop(0)
```
After:
```python
class Stack:
    def __init__(self): self._items = []
    def push(self, x):  self._items.insert(0, x)
    def pop(self):      return self._items.pop(0)
    def __len__(self):  return len(self._items)
    def empty(self):    return not self._items
```

## Language notes
- Python: `__getattr__` can forward everything but re-exposes the full interface; prefer explicit methods. Use `collections.abc` mixins to get `__len__`-derived behavior cheaply.
- TypeScript/Java/C#: prefer private field plus interface; "composition over inheritance".
- Go: composition is the default; embedding promotes all methods, so use a named field (not embedding) to limit the surface.

## Related
Replace Delegation with Inheritance (inverse), Extract Interface, Remove Middle Man. Smell: Refused Bequest.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 288-290.
