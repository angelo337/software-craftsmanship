---
name: clean-code-refactoring-smells
description: Review and refactor existing code using the Clean Code catalog of smells and heuristics (Successive Refinement, Smells and Heuristics). Use whenever the user asks to review, audit, clean up, refactor or "improve" code or a pull request, or when you spot duplication, dead code, magic numbers, feature envy, long parameter lists, commented-out code, inconsistent style or unclear structure. Triggers on "code review", "refactor", "code smell", "limpiar este código", "revisar código", "tech debt".
---

# Refactoring and smells

Messy code is cleaned incrementally, never by a big rewrite. Each step is small, behaviour-preserving, and verified by tests.

## Refactoring procedure

1. **Make sure there are tests** that pin current behaviour (add characterisation tests if missing). No tests, no safe refactor: say so and add them first.
2. **Read and understand the code** and note what each part is for. Don't change what you don't understand.
3. **Find smells** with `references/smells-catalog.md` (grouped by Comments, Environment, Functions, General, Names, Tests, plus language notes). Rank by impact on readability and change risk.
4. **Apply one small transformation at a time:** rename, extract function, move to the right class, introduce explanatory variable, replace magic number, remove duplication, replace conditional with polymorphism, delete dead code.
5. **Run tests after every step;** revert any step that breaks them.
6. **Stop when the code reads clearly,** and do not gold-plate: three rules of simple design (tests pass, no duplication, expressive) take precedence over cosmetic tweaks.
7. **Report:** list what changed and why, grouped by smell, and what you chose not to touch.

## Review output format

For each finding give: location, smell code and name (e.g. `G5 Duplication`), why it hurts here, and a concrete fix. Order by severity. Distinguish must-fix (bugs, hidden coupling, duplication, dead code) from nice-to-have (style).

## Principles behind the catalog

- Smells are symptoms; none is an absolute law. Use judgment and the project's conventions.
- Duplication is the root of many smells: remove it first.
- Prefer deleting code to commenting it out or keeping it "just in case".
- Fix the cause at the abstraction level where it lives, not at call sites.
- Leave the campsite cleaner than found, within the scope the user requested.

## Source

Martin, R. C. (2009). *Clean code* (Ch. 14-17; esp. Ch. 17, "Smells and Heuristics", which builds on Fowler et al., 1999). Prentice Hall.
