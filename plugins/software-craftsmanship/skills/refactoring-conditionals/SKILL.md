---
name: refactoring-conditionals
description: Simplify tangled conditional logic using the Fowler "Simplifying Conditional Expressions" catalog. Use whenever code has deeply nested if/else, long or repeated boolean expressions, a switch/if-chain on a type or kind, repeated null checks, control flags like `done`/`found`, identical statements in every branch, or unstated assumptions. Covers Decompose Conditional, Consolidate Conditional Expression, Consolidate Duplicate Conditional Fragments, Remove Control Flag, Guard Clauses, Replace Conditional with Polymorphism, Introduce Null Object, Introduce Assertion. Trigger on "simplify conditional", "guard clause", "null object", "early return", "if anidados", "condicional complejo", "reemplazar switch", "demasiados if", "clean up this if/else".
---

# Refactoring Conditionals

Behavior-preserving techniques from Chapter 9 of Fowler et al., *Refactoring* (1999). Goal: make the branching logic say *why* it branches, and make the normal path obvious. Details live in `references/`; load only the file you need.

## Decision table: symptom -> refactoring

| Symptom | Refactoring | Reference |
|---|---|---|
| Condition or branch bodies are hard to read; code says *what*, not *why* | Decompose Conditional | `references/decompose-conditional.md` |
| Several consecutive checks lead to the same result | Consolidate Conditional Expression | `references/consolidate-conditional-expression.md` |
| Same statement(s) at the start/end of every branch | Consolidate Duplicate Conditional Fragments | `references/consolidate-duplicate-conditional-fragments.md` |
| A boolean variable only exists to stop a loop or skip later checks | Remove Control Flag | `references/remove-control-flag.md` |
| Nested if/else where one branch is the normal path and the rest are exceptions | Replace Nested Conditional with Guard Clauses | `references/replace-nested-conditional-with-guard-clauses.md` |
| Same switch/if-chain on a type appears in several places | Replace Conditional with Polymorphism | `references/replace-conditional-with-polymorphism.md` |
| Many callers check `x is None` and all do the same fallback | Introduce Null Object | `references/introduce-null-object.md` |
| Code silently relies on a precondition or invariant | Introduce Assertion | `references/introduce-assertion.md` |

## Choosing between close calls

**Guard clause vs if/else.** Ask whether both outcomes are normal. If both are ordinary, equally likely paths (e.g. member vs guest price), keep a symmetric if/else. If one outcome is a rare or exceptional case (invalid input, dead/retired/empty), guard it: return or raise at the top so the main path stays unindented. Do not obey a "single exit" rule for its own sake; pick whichever reads clearer.

**Polymorphism vs table/dict/match.** Polymorphism pays off when the same type switch is repeated in many places, when branches carry real behavior (multiple methods per type), or when new types are added by third parties. Prefer a lookup table (dict, map, enum with data) when branches only differ by a value or a single small function. Prefer a `match`/`switch` expression when there is one switch, it is exhaustive (compiler- or type-checker-checked), and no one else switches on the same kind. Rule of thumb: one switch -> match or table; the same switch in three places -> polymorphism.

## Generic safe procedure

1. Confirm tests cover every branch; add characterization tests for the ones that do not.
2. Check the conditions for side effects (calls that mutate, I/O, short-circuit-dependent evaluation). Side effects restrict reordering and merging.
3. Apply one refactoring in the smallest step you can; run tests after each step.
4. Prefer extraction (a well-named function or predicate) over comments to explain a condition.
5. Re-read the result: the normal path should be visible, every condition should have a name or an obvious meaning.
6. Stop when the code reads clearly; do not chain every refactoring just because it is available.

## When NOT to apply

- The conditional is already short and its meaning is obvious; extra indirection would only add noise.
- The checks are truly independent concepts that merely share a result today; merging them hides intent.
- A single, stable switch on a closed set of values that nobody else touches; polymorphism adds classes for no gain.
- You lack tests and cannot reason about equivalence (especially around short-circuiting and side effects).
- Performance-critical inner loops where measurement shows the extra calls matter.
- Null Object when absence must be handled differently by most callers, or when silent defaults would hide real bugs.
- Assertions for input validation at system boundaries; use real errors there.

## Related smells and companion refactorings

Smells: Long Method, Switch Statements, Duplicated Code, Speculative Generality, Temporary Field. Companions: Extract Method, Move Method, Replace Type Code with Subclasses or State/Strategy, Separate Query from Modifier, Replace Magic Number with Symbolic Constant.

## Source

Fowler, M., Beck, K., Brant, J., Opdyke, W., Roberts, D. (1999). *Refactoring: Improving the Design of Existing Code*, Chapter 9. All text here is paraphrased; examples are original.
