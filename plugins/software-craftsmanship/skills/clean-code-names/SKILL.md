---
name: clean-code-names
description: Choose and review names for variables, functions, classes, modules and files following Clean Code (Meaningful Names). Use whenever you create or rename any identifier, review naming, or see names like data, temp, x, Manager, Helper, flag, or encoded prefixes. Triggers on "name this", "rename", "nombres", "naming", "what should I call", and on any code-writing task where new identifiers are introduced.
---

# Meaningful names

A name should answer why it exists, what it does and how it is used. If it needs a comment, the name has failed. Spend the time: names are most of what makes code readable.

## Rules

1. **Reveal intent.** `elapsedDays` not `d`. `flaggedCells` not `list1`. A reader should not have to decode the surrounding code to learn what a value means.
2. **Avoid disinformation.** Do not call something `accountList` unless it is a list; do not use names that differ by a character or that mean something else in the domain (`hp`, `l`, `O`).
3. **Make meaningful distinctions.** No `a1/a2`, no noise words (`Info`, `Data`, `Object`, `theX`, `ProductInfo` vs `ProductData`). If two names cannot be told apart by meaning, merge or rename them.
4. **Pronounceable and searchable.** Names you can say aloud and grep for. Single letters only for tiny local scopes (loop index in a few lines); name length grows with scope.
5. **No encodings.** No Hungarian notation, no `m_`/`_` member prefixes, no type or subsystem prefixes. Interfaces should not need an `I` prefix; if one side must be marked, mark the implementation (`ShapeFactoryImpl`).
6. **No mental mapping.** Do not make readers translate `r` into "the URL without host". Clarity beats cleverness.
7. **Classes are nouns, methods are verbs.** `Customer`, `AddressParser`; `save`, `deletePage`, `isPosted`. Avoid vague class names like `Manager`, `Processor`, `Data`, `Info`. Use accessor/mutator/predicate conventions of the language (`get`, `set`, `is`, or properties).
8. **Don't be cute.** `whack()`/`eatMyShorts()` instead of `kill()`/`abort()` fails. Say what you mean in plain words.
9. **One word per concept.** Pick `fetch`, `retrieve` or `get` and use it everywhere; don't mix `controller`, `manager`, `driver` for the same idea. Don't use one word for two concepts (`add` for both appending and summing).
10. **No puns.** Same word, different semantics confuses; use a different word.
11. **Use solution-domain names** (algorithm, pattern, math terms: `JobQueue`, `AccountVisitor`) for technical concepts, and **problem-domain names** when no programmer term exists, so a domain expert can follow the code.
12. **Add meaningful context.** Prefer to place variables in a well-named class/function (`Address.state`) over prefixing (`addrState`). Don't add gratuitous context (`GSDAccountAddress`): shorter names are better when they are clear.
13. **Names describe side effects.** A function that creates when missing is `getOrCreate`, not `get`. A function that mutates says so (`addDaysTo` vs `daysLater`).
14. **Choose the abstraction level of the surrounding code.** `connect(locator)` rather than `dial(phoneNumber)` when the abstraction is "a connection".
15. **Re-evaluate names as code evolves.** Renaming is cheap with modern tooling; do it when meaning drifts, and don't fear long, descriptive names for rarely-called functions.

## Quick check before finishing

- Any identifier you had to explain in a comment? Rename it.
- Any pair of names whose difference isn't obvious? Fix.
- Any names that contain the type, a prefix, or `Manager/Data/Info`? Fix.
- Did you follow the language's casing conventions and the project's vocabulary?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 2, "Meaningful Names"; Ch. 17 heuristics N1-N7). Prentice Hall.
