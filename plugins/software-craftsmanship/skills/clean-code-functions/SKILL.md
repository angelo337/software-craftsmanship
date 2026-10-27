---
name: clean-code-functions
description: Write and refactor small, single-purpose functions and methods following Clean Code (Functions). Use whenever you write, split, review or refactor a function, method, handler or script block; when a function is long, has many parameters, boolean flags, output arguments, deep nesting, switch/if chains, or mixed levels of abstraction. Triggers on "function too long", "refactor this method", "simplify", "extract", "funciones", "parámetros".
---

# Functions

Functions are the first line of organisation. Write them so the file reads like a top-down narrative.

## Rules

1. **Small.** Smaller than you think; a handful of lines is typical, and blocks inside `if/else/while` should be one line (usually a call). Indentation depth of one or two levels at most.
2. **Do one thing.** A function does one thing if you cannot extract another function from it with a name that is not just a restatement of its implementation. Sections within a function (declarations, validation, work, cleanup) mean it does several things.
3. **One level of abstraction per function.** Don't mix high-level policy (`renderPage`) with low-level detail (string appending, byte handling). Statements should sit one level below the function's name. Read top-down: each function leads to the next level down (the Stepdown Rule).
4. **Switch/if-else chains:** tolerate at most one per type-selection, buried in a factory that builds polymorphic objects; elsewhere use polymorphism instead of repeating the same switch.
5. **Descriptive names.** A long, clear name beats a short enigmatic one or a comment. Use the same phrasing across related functions. Name for what it does, including side effects.
6. **Few arguments.** Zero is best, then one, two; three needs justification; avoid more. Use an argument object when several belong together.
   - **Monadic forms:** asking a question (`fileExists(f)`), transforming (`parse(s)` returns result), or an event. Avoid using them in other roles.
   - **No flag arguments.** A boolean parameter means the function does two things; split into two functions.
   - **No output arguments.** Return values, or change the state of the owning object.
   - Argument order should be natural (`assertEquals(expected, actual)`); if not, the function name should record the order.
7. **No hidden side effects.** A function named `checkPassword` must not also initialise a session. If a side effect is needed, put it in the name or separate it.
8. **Command-query separation.** Either change state or answer a question, not both (`set` returning a boolean that means "was the attribute previously set" is a trap).
9. **Prefer exceptions to error codes.** Returning codes forces callers into nested checks. Extract the `try` body and the handler into their own functions; error handling is itself one thing. See `clean-code-errors-boundaries`.
10. **Don't repeat yourself.** Duplicated blocks become a function; duplicated algorithms with different steps become template/strategy.
11. **Make conditionals readable.** Encapsulate boolean logic: `if (shouldBeDeleted(timer))`. Avoid negative conditions (`if (isActive)` not `if (!isNotActive)`). Name boundary arithmetic (`nextLevel = level + 1`). Replace magic numbers with named constants.
12. **Make temporal coupling explicit** by passing results from one step into the next so the call order cannot be wrong.
13. **Write it badly first, then refine.** Polish with tests passing: split, rename, shuffle, remove duplication.

## Quick check

- Can you describe the function in one sentence without "and"/"then"/"or"?
- Does every statement sit at the same abstraction level?
- Any boolean parameter, output parameter, or more than 3 parameters?
- Does the name tell you everything it changes?
- Is any code in the function repeated elsewhere?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 3, "Functions"; Ch. 17 heuristics F1-F4, G5, G23, G25, G28-G31, G34). Prentice Hall.
