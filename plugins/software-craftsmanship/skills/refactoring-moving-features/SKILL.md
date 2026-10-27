---
name: refactoring-moving-features
description: Move responsibilities to the class where they belong, using Fowler's Chapter 7 refactorings - Move Method, Move Field, Extract Class, Inline Class, Hide Delegate, Remove Middle Man, Introduce Foreign Method, Introduce Local Extension. Use whenever code shows feature envy, a god class or "clase muy grande", a class doing two jobs, an anemic or lazy class, message chains (a.b().c().d()), a class that only forwards calls (middle man), or a method you need on a library/third-party class you cannot modify. Trigger on "move method", "move field", "extract class", "inline class", "feature envy", "mover método", "mover campo", "extraer clase", "responsabilidades", "demasiadas responsabilidades", "god class", "middle man", "law of Demeter", even when the user does not name the refactoring.
---

# Moving Features Between Objects

## Purpose
Where a responsibility lives is the most basic design decision, and it is rarely right the first time. These refactorings relocate methods, fields and whole classes so each class owns one clear job and data sits next to the code that uses it. Source: Fowler et al. (1999), Chapter 7.

## Decision table: symptom -> refactoring

| Symptom | Refactoring | Open |
|---|---|---|
| Method uses another class's data more than its own (feature envy) | Move Method | references/move-method.md |
| Field is read/written mostly by another class's code | Move Field | references/move-field.md |
| One class has two clusters of fields+methods that change for different reasons | Extract Class | references/extract-class.md |
| Class does almost nothing, left over after other moves | Inline Class | references/inline-class.md |
| Client chains `a.b().c()`, so it knows the structure behind `a` | Hide Delegate | references/hide-delegate.md |
| Class is mostly one-line forwarding methods | Remove Middle Man | references/remove-middle-man.md |
| Need 1-2 extra methods on a class you cannot edit | Introduce Foreign Method | references/introduce-foreign-method.md |
| Need 3+ extra methods on a class you cannot edit | Introduce Local Extension | references/introduce-local-extension.md |

### Trade-offs to decide explicitly
- **Hide Delegate vs Remove Middle Man**: hiding reduces client coupling to the structure, but every new delegate feature needs a new forwarding method on the server. When forwarders pile up, reverse it. Neither is permanent; pick by current pain. Mixed is fine: hide for most clients, expose for a few.
- **Extract Class vs Inline Class**: opposites. Split when a class is hard to hold in your head or has data that moves together; merge when a class lost its reason to exist. A cheap test: if removing one field makes several others meaningless, they belong together in their own class.
- **Foreign Method vs Local Extension**: one or two missing methods -> foreign method; more, or the same ones needed in many classes -> extension. Both are workarounds; prefer asking the owner to add the method.

## Generic safe procedure
1. Make sure tests cover the code you will touch; if not, add characterization tests first. This protects behavior while structure changes.
2. Identify what moves and what it depends on (fields, helpers, overrides in sub/superclasses). Moving a dependency first (usually the field) makes the method move trivial.
3. Create the destination and a link from source to target before moving anything.
4. Move one element at a time. Copy it, adapt it, make the old one delegate to the new one, run tests.
5. Redirect callers, then delete the old forwarder (or keep it deliberately if it is a public API).
6. Re-run tests after every step; revert the last step if they fail rather than debugging forward.
7. Re-read both classes: shrink interfaces, drop back-links that turned out unneeded.

## When NOT to apply
- The decision is a coin flip: leave it. It is cheap to move later.
- Polymorphism blocks the move (method overridden in subclasses and you cannot express that on the target).
- The code is about to be deleted or rewritten, or no tests exist and the change is risky.
- Moving would create a cycle or a dependency from a stable/core module onto a volatile one.
- Splitting a class only to hit a size number, with no cohesive cluster to extract.
- Public API consumers you cannot update: keep a delegating method instead of deleting.

## Language-agnostic notes
Apply the dependency-order rule: fields before methods, low-level methods before callers. Open the matching reference for mechanics, a Python before/after, language notes and related smells. Related chapters: composing methods (Extract Method) and organizing data (Self Encapsulate Field, Change Value to Reference).
