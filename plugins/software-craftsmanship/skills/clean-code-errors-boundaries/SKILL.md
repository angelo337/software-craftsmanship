---
name: clean-code-errors-boundaries
description: Handle errors cleanly and isolate third-party/external code following Clean Code (Error Handling, Boundaries). Use whenever you write try/catch, raise or return errors, deal with null/None/undefined, wrap a library, SDK, REST client or legacy module, or see error codes, swallowed exceptions, defensive null checks everywhere. Triggers on "exception", "error handling", "manejo de errores", "null", "wrapper", "adapter", "third-party API".
---

# Error handling and boundaries

## Error handling

Error handling must not obscure the main logic.

1. **Use exceptions (or the language's idiomatic result/error type), not return codes.** Codes force callers to check immediately and clutter logic. Pick one mechanism per layer and stay consistent.
2. **Write the try/catch/finally structure first** when code can fail, so the failure contract is defined before the happy path grows. Tests that force the failure keep you honest.
3. **Keep exception handling at one level:** a function that handles errors should do essentially nothing else; extract the body of `try` into its own function.
4. **Provide context.** Message states the operation that failed and why (what, with which input class). Include the cause chain.
5. **Define exceptions by the caller's needs.** Wrap a library's many exception types in one or a few of your own at the boundary, so callers handle one thing.
6. **Don't return null; don't pass null.** Return empty collections, Optional/Maybe, a special-case object (Null Object), or throw. Passing null as an argument is worse than returning it; reject it explicitly or design it out. Null-check sprinkling signals a design gap.
7. **Never swallow exceptions** (empty `catch`, log-and-continue without recovery). Handle, translate, or let propagate.
8. **Fail fast at trust boundaries:** validate external input once, at the edge; inside, rely on invariants.
9. **Special-case pattern:** when exceptional flow is routine business logic (e.g. "no meals billed"), return an object that models the case so the caller needs no branch.

## Boundaries

Third-party and cross-team code is a boundary where you do not control the API.

- **Wrap it.** Don't scatter library types (e.g. a generic `Map`, an SDK client) through your code. Hide them behind a class or interface in your own vocabulary, exposing only what you need; then a library change touches one place.
- **Learning tests:** when adopting a library, write small tests of how you expect it to behave. They are free (you needed to learn it anyway), document behaviour, and flag breaking changes on upgrade.
- **Code that does not exist yet:** define the interface you wish you had, program against it, and add an adapter once the real API arrives. Test with a fake behind that interface.
- Keep clean separations and few places that know about third-party details; tests at the boundary prove the contract.

## Quick check

- Is any function returning or accepting `null` without a stated reason?
- Is the happy path readable without scanning error branches?
- Are all third-party types confined to a thin wrapper?
- Do error messages let someone diagnose without a debugger?
- Is there any catch block that swallows an error?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 7, "Error Handling"; Ch. 8, "Boundaries"; Ch. 17 heuristics G3, G4, G26). Prentice Hall.
