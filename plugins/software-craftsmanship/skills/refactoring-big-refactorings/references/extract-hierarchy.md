# Extract Hierarchy

## Intent
Turn an overgrown class (a "Swiss-army-knife" full of flags and conditionals for several special cases) into a hierarchy where each subclass represents one case.

## Use when
- One class grew by accretion: each new case added a flag and a few tests, until conditionals are everywhere.
- Conditionals test the same properties repeatedly (for example customer category, season, plan type).

## Don't use when
- Variation is minor and stable; simpler lookup data may do.
- The varying aspect changes during the lifetime of the object and you have not yet extracted it with Extract Class (do that first, then use State/Strategy).

## Mechanics
**Variations unclear (step by step):**
1. Identify one variation.
2. If the variation can change during the object's life, Extract Class to pull that aspect into a separate class.
3. Create a subclass for that special case; use Replace Constructor with Factory Method on the original class and make the factory return the subclass when appropriate.
4. One at a time, copy methods containing conditional logic into the subclass and simplify them using what you now know for sure about instances of the subclass. Use Extract Method in the superclass to separate conditional from unconditional parts when needed.
5. Repeat for other special cases. When all are covered, make the superclass abstract, delete method bodies overridden in every subclass, and declare them abstract.

**Variations clear from the start:**
1. Create a subclass for each variation.
2. Use Replace Constructor with Factory Method to return the right subclass. If variations are marked by a type code, use Replace Type Code with Subclasses (or State/Strategy if they change).
3. Apply Replace Conditional with Polymorphism to methods with conditional logic; isolate the varying part with Extract Method if only part of a method varies.

## Tips
- Compare how second and later variations line up with the first: aim for methods with the same signature and intent but different implementations; the pattern tends to stabilize.
- Do not expect to finish in a day; do the easy steps, take a break, return.

## Language notes
- Python/TS: a dict of strategies or sum types with pattern matching can replace subclasses when behavior differences are small.
- Java/C#: abstract base class plus factory method is the textbook outcome.

## Related
Replace Type Code with Subclasses / State-Strategy, Replace Conditional with Polymorphism, Replace Constructor with Factory Method, Extract Class; smells: Large Class, Switch Statements.

Source: Fowler et al. (1999), Ch. 12.
