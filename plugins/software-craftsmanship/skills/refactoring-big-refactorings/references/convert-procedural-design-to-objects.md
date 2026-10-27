# Convert Procedural Design to Objects

## Intent
Turn procedural code (long routines plus passive data records) into objects that own their behavior.

## Use when
- You see long procedural methods in one class and "dumb" data classes with only accessors.
- A team uses an object-oriented language without really using objects (classes as namespaces, static methods everywhere).

## Don't use when
- The procedural style is deliberate and small (for example a small strategy object or a pure function pipeline in a functional design). Not every behavior must live in a data-holding class.

## Mechanics
1. Turn each record type (and each database table, if there is one) into a plain data object with accessors.
2. Gather all the procedural code into a single class; make it a singleton or give it static methods for easy reinitialization.
3. For each long procedure, apply Extract Method and its related refactorings to break it down; as pieces emerge, Move Method each to the data class whose data it uses.
4. Continue until all behavior has left the original class. If it was purely procedural, delete it.
5. Now work on the intelligent objects with the usual refactorings (Replace Conditional with Polymorphism, Extract Class, ...).

## Language notes
- Python: dataclasses first, then move functions into them as methods; modules of free functions are fine when no state is involved.
- Functional-leaning languages: converting to objects may not be the right goal; consider immutable data plus focused functions instead.

## Related
Extract Method, Move Method, Replace Record with Data Class; smells: Data Class, Feature Envy, Long Method.

Source: Fowler et al. (1999), Ch. 12 (and the Ch. 1 example, where a statement routine is broken up and distributed).
