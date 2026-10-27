# Remove Middle Man

## Intent
Let clients call the delegate directly when the server's forwarding methods have become noise.

## Use when
- Most methods of a class just forward to another object.
- Each new feature of the delegate forces another forwarding method on the server.
- The server adds no logic, validation or abstraction of its own.

## Don't use when
- The forwarders protect clients from a delegate that really is likely to change.
- The server is a facade or adapter by design, or is a published API.
- Exposing the delegate would leak mutable internals; consider keeping some forwarders.

## Mechanics
1. Add an accessor that exposes the delegate.
2. For each forwarded method, change the callers to go through the accessor, then delete the forwarder.
3. Test after each method.
4. Keep a few forwarders if convenient, or hide the delegate from some clients and expose it to others.

## Example (Python)
```python
# before
class Person:
    def manager(self): return self.department.manager
    def budget(self):  return self.department.budget
boss = person.manager()
# after: expose the delegate, drop the forwarders
class Person:
    department = None
boss = person.department.manager
```

## Language notes
- Python: a public attribute or `@property` is the accessor; trivial. `__getattr__` forwarding is the opposite smell, replace it with direct access.
- Java/C#/TS: after deleting forwarders, the compiler lists callers that still need updating.
- IDE support: usually inline-method refactorings (IntelliJ, Eclipse, ReSharper) handle each forwarder; Python needs search and replace.
- Go: export the field or add a getter.

## Related
Hide Delegate (inverse), Inline Method, Inline Class. Smell: Middle Man.

## Source
Fowler et al. (1999), Chapter 7 (Remove Middle Man).
