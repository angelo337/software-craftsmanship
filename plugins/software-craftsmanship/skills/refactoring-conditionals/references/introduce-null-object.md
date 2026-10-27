# Introduce Null Object

## Intent
Replace a nullable value with a real object of the same type whose methods do the sensible "nothing/default" thing, so callers stop checking for null.

## Use when
- Many callers do `if x is None: default else: x.method()` with the same default.
- Absence has a well-defined harmless behavior (empty list, zero, "guest", no-op).
- A chain of calls (`a.b().c()`) is guarded at each step.

## Don't use when
- Absence is an error that should fail loudly; a silent stand-in would hide bugs.
- Most callers need different handling of absence.
- Only one or two call sites check; a local default is cheaper.
- Idiomatic Optional/Maybe or a default parameter already covers it cleanly.

## Mechanics
1. Create a null variant of the class (subclass or same interface) with an `is_null` query that returns true; the real class returns false. A marker interface is an alternative when you cannot modify the source class.
2. Have every producer that could return null return the null object instead (a shared singleton is fine, since it has no state).
3. Replace `== null` checks with `is_null` checks; test.
4. For each client that does "if present do X, else default", override X in the null class to give the default behavior; delete the condition at the call site; test.
5. Where null results lead to other nulls (e.g. history of a missing customer), return the matching null object from the null class.
6. Keep the explicit `is_null` test only for clients that truly want different behavior.
7. Consider distinct null variants (no customer vs unknown customer): this is the broader Special Case pattern.

## Example (Python)
```python
# Before
plan = DEFAULT_PLAN if customer is None else customer.plan
name = "occupant" if customer is None else customer.name

# After
class NoCustomer:
    plan = DEFAULT_PLAN
    name = "occupant"
    def set_plan(self, plan): pass   # ignore writes

NO_CUSTOMER = NoCustomer()
# producer: return found or NO_CUSTOMER
plan, name = customer.plan, customer.name
```

## Language notes
- Python: a plain class or frozen dataclass singleton; `Optional[T]` in hints still helps at boundaries.
- TypeScript: an object literal implementing the interface; avoid `strictNullChecks` off.
- Java: `Optional` suits return values; Null Object suits repeated behavior. `Collections.emptyList()` is a built-in null object.
- C#: `Null` implementations, `Enumerable.Empty<T>()`, nullable reference types for documenting absence.
- Go: nil receivers can implement the no-op behavior; empty structs implementing an interface also work.

## Related
Smells: Switch Statements (null checks as type tests), Duplicated Code. Refactorings: Replace Conditional with Polymorphism, Introduce Assertion (for places where null should no longer appear).

## Source
Fowler et al. (1999), *Refactoring*, Ch. 9, Introduce Null Object (about p. 210).
