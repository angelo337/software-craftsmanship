---
name: clean-code
description: Entry point for writing, reviewing or refactoring code the Clean Code way (Robert C. Martin). Use whenever the user asks to write, implement, review, refactor, clean up or "mejorar" code in any language, or mentions clean code, código limpio, readability, maintainability, code quality, or the Boy Scout rule. Sets the core principles and routes to the specialised clean-code-* skills (names, functions, comments-formatting, objects-classes, errors-boundaries, tests, concurrency, refactoring-smells). Load this first for any non-trivial coding task, even if the user does not say "clean".
---

# Clean Code: core principles and router

Clean code is code that another developer can read, understand and change cheaply. Code is read far more often than it is written, so every choice is judged by what it costs the next reader. The rules below are heuristics that serve that goal, not laws: apply judgment, and match the conventions already present in the codebase.

## Working loop

1. **Understand first.** Know what the code must do and how the surrounding code is organised before writing. Code that merely passes the tests you thought of is not understood code.
2. **Make it work, then make it clean.** A first draft is allowed to be messy. Then refine it: rename, split, remove duplication, with tests green after each step.
3. **Leave it cleaner than you found it (Boy Scout rule).** In files you touch, make at least one small improvement, but keep unrelated cleanups out of the diff when the user wants a focused change.
4. **Before finishing,** re-read the result as a stranger would and run the checklist below.

## Principles that apply everywhere

- Intent must be visible: names and structure should explain what and why, so comments are rarely needed.
- Small units that do one thing: functions, classes and modules each have one reason to change.
- No duplication: each piece of knowledge lives in exactly one place.
- Least surprise: code does what a reasonable reader expects from its name and location.
- Fewest moving parts: no dead code, no speculative generality, no clutter.
- Safety nets: tests exist, failures are explicit, nothing is silently ignored.

## Which skill to load

| Situation | Skill |
|---|---|
| Naming variables, functions, classes, files | `clean-code-names` |
| Writing or splitting functions/methods, arguments, conditionals | `clean-code-functions` |
| Adding/removing comments, layout, file organisation | `clean-code-comments-formatting` |
| Designing classes, data structures, modules, dependencies, system structure | `clean-code-objects-classes` |
| Exceptions, null handling, third-party APIs, adapters | `clean-code-errors-boundaries` |
| Writing or fixing tests | `clean-code-tests` |
| Threads, async shared state, locks | `clean-code-concurrency` |
| Reviewing or refactoring existing code; spotting smells | `clean-code-refactoring-smells` |

For a typical "implement X" task, read names + functions (+ tests) before writing. For "review/clean this", start with refactoring-smells. If a sibling skill is not installed, apply the summary below directly.

## Final checklist

- Can each name be understood without reading its body? (names)
- Does each function do one thing, at one level of abstraction, with ≤3 arguments and no hidden side effects? (functions)
- Is every comment saying something the code cannot, and is there no commented-out code? (comments)
- Is anything duplicated, dead, magic-numbered or in the wrong place? (smells)
- Are errors raised explicitly rather than returned as codes or `null`? (errors)
- Is there a fast, readable test for each behaviour and boundary? (tests)
- Did I follow the project's existing conventions and keep the diff focused?

## Source

Martin, R. C. (2009). *Clean code: A handbook of agile software craftsmanship*. Prentice Hall. The skills paraphrase its principles with language-neutral examples.
