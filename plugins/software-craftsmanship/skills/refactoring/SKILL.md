---
name: refactoring
description: Entry point for refactoring existing code safely, following Fowler et al.'s Refactoring catalog (72 named refactorings, code smells, test-first safety net). Use whenever the user asks to refactor, restructure, clean up, simplify, decouple, untangle, reduce duplication, or "improve the design" of existing code, before adding a feature to hard-to-change code, while reviewing a pull request, or when a method/class/hierarchy feels too big or tangled. Also use to choose which refactoring fits a symptom. Spanish triggers - refactorizar, refactorización, limpiar código, mejorar el diseño, código heredado. Routes to the refactoring-* skills.
---

# Refactoring: principles, procedure and router

**Refactoring** (noun): a change to the internal structure of software that makes it easier to understand and cheaper to modify without changing its observable behavior. **Refactor** (verb): apply a series of such changes. Behavior must not change; that is what separates it from rewriting, optimizing or adding features.

Two hats: at any moment you are either *adding function* (new tests, new behavior) or *refactoring* (no new behavior, tests unchanged except for interface changes). Say which hat you are wearing; swap often, never mix them in one step.

## Operating procedure

1. **Safety net first.** Confirm there are fast, self-checking tests covering the code. None or too few? Use `refactoring-building-tests` before touching structure. If the code is so broken it cannot be stabilized, a rewrite may be cheaper than refactoring.
2. **Find the reason.** Refactor in service of something: to understand code you must change, to make a feature easy to add, to find a bug, or in response to review feedback. Avoid refactoring "for its own sake" and avoid scheduling it as a separate phase.
3. **Diagnose smells** with `refactoring-bad-smells`: it maps each smell to the refactorings that cure it.
4. **Pick the refactoring** with `references/catalog-index.md`, then open the chapter skill that holds its mechanics (table below).
5. **Take small steps.** One refactoring at a time, compile/run the tests after each, commit often. If tests fail and the cause is not obvious, revert the step instead of debugging forward.
6. **Rule of three.** The first time, just do it; the second time you wince and duplicate; the third time, refactor.
7. **Stop when the immediate goal is met.** You can come back tomorrow; do not gold-plate.
8. **Report** what changed, which refactorings were used, what was left alone, and test results.

## Which skill holds what

| Need | Skill |
|---|---|
| Spot what is wrong and choose a cure | `refactoring-bad-smells` |
| Add or strengthen tests before refactoring | `refactoring-building-tests` |
| Long methods, temps, unclear expressions | `refactoring-composing-methods` |
| Misplaced behavior, god classes, delegation | `refactoring-moving-features` |
| Primitives, type codes, fields, collections, associations | `refactoring-organizing-data` |
| Nested or complex conditionals, null checks | `refactoring-conditionals` |
| Signatures, parameters, constructors, error handling | `refactoring-method-calls` |
| Inheritance: pull up/down, extract superclass, delegation | `refactoring-generalization` |
| Large, long-running restructurings | `refactoring-big-refactorings` |

## Ground rules

- **Published interfaces:** if callers cannot be found and changed (public library API, external clients), keep the old signature delegating to the new one and deprecate it; never copy the body.
- **Databases:** schema and data migration make refactoring hard; isolate with a mapping layer or accessors and move data and code together.
- **Performance:** refactoring may cost a little speed but makes tuning easier. Build well-factored code first, then profile and optimize hot spots in small, measured steps.
- **Deadlines:** unfinished refactoring is technical debt with interest; do not postpone it just because time is short, but avoid big restructurings right before a release.
- **Tools:** prefer IDE or language-server automated refactorings (rename, extract, move) over hand edits; they are safer and faster. When doing it by hand, follow the mechanics step by step.
- **Disagreeing with the book:** in modern languages some refactorings collapse (extract method becomes a closure, type-code classes become enums or sum types). Each chapter skill notes this.

## References

- `references/catalog-index.md`: all 72 refactorings, grouped by chapter skill, with a one-line trigger each
- `references/source.md`: bibliography and chapter map

Source: Fowler, M., Beck, K., Brant, J., Opdyke, W., & Roberts, D. (1999). *Refactoring: Improving the design of existing code*. Addison-Wesley.
