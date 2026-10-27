---
name: refactoring-method-calls
description: Simplify method signatures and call sites with the 15 refactorings of Fowler et al. (1999) Ch. 10 "Making Method Calls Simpler". Use whenever a method name is unclear, a parameter list is long, a flag argument switches behavior, a method both queries and modifies state, a function returns error codes, a method or setter is too public, a constructor must return a subclass, callers must downcast, or exceptions drive normal flow. Trigger on "rename method", "add parameter", "parameter object", "long parameter list", "separate query from modifier", "factory method", "remove setter", "lista de parámetros larga", "cambiar firma", "reemplazar código de error por excepción". Use even if the user does not name the refactoring, e.g. "this function takes 8 args" or "this getter also mutates state".
---

# Making Method Calls Simpler

Purpose: make interfaces (method names, parameters, return types, error signals, visibility) easier to understand and use, without changing observable behavior. The 15 refactorings come from Chapter 10 of Fowler et al., *Refactoring: Improving the Design of Existing Code* (1999). Every change here is behavior-preserving: run the tests before and after each step.

## Decision table: symptom -> refactoring

| Symptom you see | Apply | Reference |
|---|---|---|
| Name does not say what the method does | Rename Method | references/rename-method.md |
| Method needs data its caller has but it does not receive | Add Parameter (first ask if an existing arg can supply it) | references/add-parameter.md |
| Parameter is never read (and no override uses it) | Remove Parameter | references/remove-parameter.md |
| Function returns a value AND changes observable state | Separate Query from Modifier | references/separate-query-from-modifier.md |
| Several methods differ only by a literal or constant | Parameterize Method | references/parameterize-method.md |
| Flag/enum/string argument selects one of a few code paths | Replace Parameter with Explicit Methods | references/replace-parameter-with-explicit-methods.md |
| Caller unpacks several fields of one object just to pass them | Preserve Whole Object | references/preserve-whole-object.md |
| Caller computes an arg the callee could compute itself | Replace Parameter with Method | references/replace-parameter-with-method.md |
| Same group of 2+ params travels together (start/end, lat/lon) | Introduce Parameter Object | references/introduce-parameter-object.md |
| Field must be set once at creation, but a setter exists | Remove Setting Method | references/remove-setting-method.md |
| Method is only used inside its own class/module | Hide Method | references/hide-method.md |
| Construction must pick a subclass, reuse an instance, or have a descriptive name | Replace Constructor with Factory Method | references/replace-constructor-with-factory-method.md |
| Every caller casts the returned value to a narrower type | Encapsulate Downcast | references/encapsulate-downcast.md |
| Function signals failure with -1, None, "", or a status int | Replace Error Code with Exception | references/replace-error-code-with-exception.md |
| try/except catches a condition the caller could check first | Replace Exception with Test | references/replace-exception-with-test.md |

Pairs that reverse each other: Parameterize Method <-> Replace Parameter with Explicit Methods; Replace Error Code with Exception <-> Replace Exception with Test. Pick by which way reads better for the callers you actually have.

## Generic safe procedure

1. Establish a green test run. If callers lack tests, write a characterization test for the current behavior first, because signature changes break callers silently in dynamic languages.
2. Find every caller, including overrides, subclasses, interface implementations, reflection or string-based dispatch, mocks, docs, and other repos. Use the type checker, IDE rename, or a project-wide search; do not trust a search for the bare name alone.
3. Add the new form beside the old one (new name, new parameter with a safe default, new factory, new query method). Copy the body, keep behavior identical.
4. Make the old form delegate to the new one. This keeps all existing callers working, so each later step stays small and reversible.
5. Migrate callers one at a time (or one module at a time), running tests after each. In a large codebase, use a deprecation marker (`@deprecated`, `warnings.warn(DeprecationWarning)`, `[Obsolete]`, `// Deprecated:`) on the old form so stragglers surface in CI.
6. When no callers remain, delete the old form and any temporary default values or shims. Then run the full suite and the type checker.
7. Commit the signature change separately from any behavior change, so a revert is clean.

Shortcut: with only a few callers inside one repo, skip the delegating step and change callers directly. If tests fail unexpectedly, back out and use the slow path.

## When NOT to apply (or apply with extra care)

- Published or public APIs (library exports, REST/RPC contracts, plugin hooks, serialized formats): you cannot find or fix all callers. Keep the old signature, mark it deprecated, document the replacement, and remove it only on a major version or after a published sunset period.
- Polymorphic methods: before removing a parameter or renaming, check every override. A parameter unused in one implementation may be needed in another. Change the whole hierarchy together or not at all.
- Concurrent code: long parameter lists often exist to pass immutable snapshots. Do not replace them with references to shared mutable objects. When splitting a check-then-act method, keep an atomic (locked) combined operation as a third method.
- Hot paths where object allocation (parameter objects) is measured to matter.
- Dependency direction: Preserve Whole Object and Replace Parameter with Method make the callee depend on more of the caller's world. Skip them if that would create a cycle or couple distant modules.
- Do not use this chapter as a license for speculative redesign. Apply a refactoring when a symptom in the table is present.

## When to open each reference

Open `references/<slug>.md` only for the refactoring you have decided to apply; each holds intent, preconditions, mechanics, a Python before/after, language notes (Python, TypeScript, Java, C#, Go), and related smells. Typical combinations:

- Long parameter list: Replace Parameter with Method, then Preserve Whole Object, then Introduce Parameter Object (each reference explains the order).
- Changing a signature of any kind: read rename-method.md first; Add Parameter, Remove Parameter and the parameter-object steps reuse its delegate-then-migrate procedure.
- Constructor/type-code redesign: replace-constructor-with-factory-method.md, then replace-parameter-with-explicit-methods.md for the creation API.
- Error-handling cleanup: replace-error-code-with-exception.md, and if exceptions end up driving normal flow, replace-exception-with-test.md.
- Command/query hygiene: separate-query-from-modifier.md, then hide-method.md and remove-setting-method.md to shrink what stays public.

## Output expectations when using this skill

- Name the refactoring you are applying and the symptom that justified it.
- Show the migration in small, test-gated steps, not one big rewrite.
- State the compatibility decision explicitly: internal-only (change callers directly) or published (deprecate and delegate).
- Mention any caller you could not verify (dynamic dispatch, other repos, serialized data).

Source: Fowler, Beck, Brant, Opdyke, Roberts, *Refactoring* (Addison-Wesley, 1999), Chapter 10, pp. 221-259. Content here is paraphrased with original examples.
