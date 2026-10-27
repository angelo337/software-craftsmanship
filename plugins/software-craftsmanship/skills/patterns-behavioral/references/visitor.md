# Visitor

**Intent.** Represent an operation over the elements of an object structure as a separate object, so new operations can be added without changing the element classes.

## Use when (code signals)
- A stable set of node types (AST, document tree, file system, shape hierarchy) and a growing list of operations (render, export, validate, size, optimize).
- `isinstance` / `instanceof` / type-switch chains over a hierarchy repeated in many places.
- Unrelated operations are polluting node classes (nodes have `to_html`, `to_json`, `check_types`...).
- An operation must accumulate state while walking a structure.

## Don't use when
- New element types appear often: each one forces changes in every visitor (the pattern's main cost).
- The language has sum types + exhaustive matching: write a function with `match`.
- There is one operation: a method on the nodes is simpler.
- Elements cannot expose enough data without breaking encapsulation.

## Participants & structure
Visitor (a `visit_X` per element type) ; ConcreteVisitor ; Element (`accept(visitor)`) ; ConcreteElement (calls `visitor.visit_X(self)`, double dispatch) ; ObjectStructure (can enumerate elements).
```
node.accept(v)  ->  v.visit_Circle(node)     # dispatch on both node and visitor type
```

## Consequences
+ Adding operations is easy; related behavior stays together; state accumulates in the visitor.
- Adding element classes is hard; every visitor changes.
- Elements must expose internals to visitors.
- Traversal responsibility must be decided (structure, visitor or iterator).

## Implementation tips
- Decide who traverses: the elements (composites call `accept` on children), the visitor, or a separate iterator.
- Use default no-op methods or a base visitor so visitors only override what they need.
- Return a value (generic visitor `Visitor<R>`) instead of using mutable fields where possible.
- Consider the Acyclic Visitor or reflection to ease adding elements, at the price of safety.

## Language mapping
- Python: `functools.singledispatch` or `match`; TS: discriminated unions + exhaustive `switch` (use `never` check); Java 21: sealed interfaces + pattern-matching `switch`; C#: `switch` expression or `dynamic` dispatch; Go: type switch, or visitor interface when closed set is generated.
- Languages with sum types (Rust, F#, Scala, Kotlin sealed) make Visitor mostly unnecessary.

## Example (TypeScript)
```ts
type Shape = { k: "circle"; r: number } | { k: "rect"; w: number; h: number };
const area = (s: Shape): number => {
  switch (s.k) {
    case "circle": return Math.PI * s.r ** 2;
    case "rect":   return s.w * s.h;
  }  // adding a variant becomes a compile error here
};
```

## Related
Composite (structure visited), Interpreter (visitor can do the evaluation), Iterator (traversal), Strategy (compare: choosing algorithm rather than walking structure).

## Source
Gamma et al., 1995, p. 331.
