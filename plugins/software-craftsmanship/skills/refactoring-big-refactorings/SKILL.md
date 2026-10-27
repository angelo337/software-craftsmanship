---
name: refactoring-big-refactorings
description: Plan and carry out large, long-running restructurings (Fowler and Beck's Big Refactorings, plus the book's reality-check and tooling advice). Use whenever the user faces a tangled inheritance hierarchy, procedural code in an object-oriented language, GUI or controller classes full of business logic, or a Swiss-army-knife class full of flags and conditionals, or asks how to refactor incrementally in a production system or a big legacy codebase. Spanish triggers - refactorización grande, código legado, separar dominio de presentación, jerarquía enredada, convertir código procedural a objetos.
---

# Big refactorings

Small refactorings are predictable and finish in minutes. Big ones set the direction for many changes, last weeks or months, and cannot be fully specified in advance because every mess differs. The work is judgment guided by small, safe steps.

## How to run a big refactoring

1. **Name the destination** and get the team to agree; others must make their changes consistent with it, or you will push in opposite directions.
2. **Nibble, do not stop the world.** Refactor as you add features or fix bugs in the area; do as much as the current task needs and come back tomorrow. Managers rarely approve a two-month pause, and you rarely need one.
3. **Keep tests green at every step** (`refactoring-building-tests`) and commit small.
4. **Take the easy, obvious steps first,** then switch to visible work for a while and return when you have learned more.
5. **Address the biggest risk first.** If mixing concerns is the risk, separate them before anything else; if a pricing rule is, get that logic out first.
6. **Expect to add classes before you remove them.** Extra structure in the middle is normal; the extracted piece usually simplifies dramatically afterward.
7. **Use the small refactorings as the moves:** Extract Method/Class, Move Method/Field, Replace Constructor with Factory Method, Replace Type Code..., Replace Conditional with Polymorphism. Find them via `refactoring` -> `references/catalog-index.md`.

## The four big refactorings

| Refactoring | Symptom | Open |
|---|---|---|
| Tease Apart Inheritance | One hierarchy does two jobs; subclass names repeat the same adjectives at each level (e.g. `TabularActiveDeal`, `TabularPassiveDeal`) | `references/tease-apart-inheritance.md` |
| Convert Procedural Design to Objects | Long procedures plus dumb data records with only accessors | `references/convert-procedural-design-to-objects.md` |
| Separate Domain from Presentation | UI classes contain domain logic and database calls (two-tier style) | `references/separate-domain-from-presentation.md` |
| Extract Hierarchy | A class accreted flags and conditionals for many special cases | `references/extract-hierarchy.md` |

## Reality check (when to proceed, when not to)

- **Rewrite instead** when the code does not work well enough to stabilize with tests. A compromise: refactor the system into well-encapsulated components, then decide refactor-versus-rebuild per component.
- **Not near a deadline:** the payoff arrives after it. Treat unfinished refactoring as debt with interest, and pay it down regularly.
- **Do not hide behind "no time":** lacking time to refactor usually means you need to refactor.
- **Design that is hard to refactor** (security, data schemas, published APIs): imagine the refactoring first; if the path is easy, choose the simplest design; if not, invest more design effort up front.
- **Published interfaces:** keep the old interface delegating to the new one and deprecate it; avoid publishing interfaces within a team unnecessarily.
- **Tools:** automated refactoring tools (IDE, language server) preserve behavior reliably and speed small steps; good tools work on the real syntax tree, keep formatting, are fast enough to run often, and integrate with the build and tests.

## Why developers resist (and responses)

Resistance usually comes from fear of breaking code, lack of tests, unclear payoff and deadline pressure. Counter with tests first, small steps, tying each refactoring to a task at hand, and showing the time saved on the next feature.

Source: Fowler, M., Beck, K., Brant, J., Opdyke, W., & Roberts, D. (1999). *Refactoring: Improving the design of existing code* (Ch. 12-14). Addison-Wesley.
