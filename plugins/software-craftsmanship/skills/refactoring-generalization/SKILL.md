---
name: refactoring-generalization
description: Guides refactoring of class hierarchies (Fowler et al. 1999, ch. 11, Dealing with Generalization). Use for duplicated code across sibling classes, fields or methods used by only some subclasses, a class with behavior used only in some instances, similar classes with no common parent, wrong inheritance, or a subclass using few superclass features. Covers pull up method/field/constructor body, push down method/field, extract subclass/superclass/interface, collapse hierarchy, form template method, and replace inheritance with delegation (and back). Trigger on "pull up method", "push down", "extract superclass", "extract interface", "template method", "inheritance vs composition", "herencia", "composición sobre herencia", "subclase", "superclase".
---

# Refactoring: Dealing with Generalization

## Purpose
Reshape a class hierarchy without changing behavior: move members up or down, create or remove classes, or swap inheritance for delegation. Goal: each piece of knowledge lives in exactly one place, and each class honestly reflects what it is.

## Decision table: symptom -> refactoring

| Symptom | Refactoring | Reference |
|---|---|---|
| Same field in sibling subclasses | Pull Up Field | references/pull-up-field.md |
| Same/equivalent method in siblings | Pull Up Method | references/pull-up-method.md |
| Subclass constructors repeat the same assignments | Pull Up Constructor Body | references/pull-up-constructor-body.md |
| Superclass method used by only some subclasses | Push Down Method | references/push-down-method.md |
| Superclass field used by only some subclasses | Push Down Field | references/push-down-field.md |
| Class features used only by some instances (flag/type code) | Extract Subclass | references/extract-subclass.md |
| Two unrelated classes share data and behavior | Extract Superclass | references/extract-superclass.md |
| Clients use only a slice of a class, or several classes play one role | Extract Interface | references/extract-interface.md |
| Subclass adds nothing over its parent | Collapse Hierarchy | references/collapse-hierarchy.md |
| Sibling methods follow the same steps but steps differ | Form Template Method | references/form-template-method.md |
| Subclass uses little of parent, or refuses inherited data/methods | Replace Inheritance with Delegation | references/replace-inheritance-with-delegation.md |
| Hand-written delegation of the delegate's whole interface | Replace Delegation with Inheritance | references/replace-delegation-with-inheritance.md |

## Choosing between close alternatives
- **Extract Subclass vs Extract Class**: subclass is simpler, but an object cannot change class after creation and only one axis of variation fits in the hierarchy. If the variation changes at runtime or has several axes, use delegation (Extract Class / strategy).
- **Extract Superclass vs Extract Interface**: superclass shares code *and* contract; interface shares contract only. Pick a superclass when real behavior or data is common; pick an interface when you only need a role or a narrow client view, or the class already has a parent.
- **Extract Superclass vs Extract Class**: inheritance if both classes truly share an interface and are substitutable; delegation otherwise.
- **Inheritance vs Delegation**: inherit only for a genuine "is-a" where the subclass honors the whole parent contract (substitutability). If it needs a subset, rejects inherited data, or the parent is only an implementation convenience, delegate. If you delegate every method of a class, inherit instead (unless the delegate is shared and mutable). Either choice is reversible with the paired refactoring.

## Generic safe procedure
1. Confirm tests exist and pass; add characterization tests for any behavior you are unsure of.
2. Read how each candidate member is really used; names can differ while meaning is the same, or match while meaning differs.
3. Make the smallest step: one field, one method, one class at a time.
4. Run tests (and type checker/linter) after every step; revert the step on failure instead of debugging forward.
5. When a move is blocked by a dependency (a member on the subclass), resolve it first: pull up/declare the dependency abstractly, or rename to align signatures.
6. Afterwards, update callers to depend on the most general type that works.

## When NOT to apply
- Duplicates that merely look alike but change for different reasons: unifying couples them.
- A hierarchy with one subclass and no foreseeable second: do not extract speculatively.
- Public API consumers you cannot update (frameworks, libraries): moving members changes their contract; deprecate first.
- No test coverage and no way to add it: add tests first.
- Inheritance used for code reuse across unrelated concepts: prefer composition, not a deeper tree.

## Which reference to open
Open only the reference for the refactoring you chose; each lists intent, use/avoid conditions, numbered mechanics, a Python before/after, language notes (Python, TypeScript, Java, C#, Go) and related smells. When unsure which applies, use the decision table first, then read the one or two candidate files.

Source: Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, ch. 11. Content here is paraphrased.
