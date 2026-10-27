# Hide Delegate

## Intent
Stop clients from navigating through one object to reach another, by adding forwarding methods on the server so structure changes stay local.

## Use when
- Client code reads `person.department.manager`, knowing how the server is built internally.
- Changing the delegate would force edits across many callers.
- You want to apply the "talk to your neighbors" idea (Law of Demeter).

## Don't use when
- The server is turning into a pile of one-line forwarders (do Remove Middle Man).
- The delegate is a stable, well-known abstraction clients legitimately work with directly.
- Only one caller exists and it is unlikely to grow.

## Mechanics
1. For each delegate method clients use, add a simple forwarding method on the server.
2. Change the client to call the server; if they live in different packages, adjust visibility.
3. Test after each method.
4. When no client needs the delegate, remove the server's accessor for it.
5. Test.

## Example (Python)
```python
# before: caller knows about Department
boss = person.department.manager
# after
class Person:
    def manager(self):
        return self.department.manager
boss = person.manager()
```

## Language notes
- Python: avoid `__getattr__` auto-forwarding; it hides the API and breaks type checking. Write explicit methods.
- Java/C#/TS: make the delegate accessor package/internal/private once clients are moved so the compiler enforces the boundary.
- Go: unexported fields give the same enforcement across packages.
- IDEs: IntelliJ "Generate delegate methods" and Eclipse "Generate Delegate Methods" produce the forwarders; ReSharper has similar generation.

## Related
Remove Middle Man (inverse, tune the balance), Extract Class, Move Method. Smells: Message Chains, Inappropriate Intimacy, Middle Man.

## Source
Fowler et al. (1999), Chapter 7 (Hide Delegate).
