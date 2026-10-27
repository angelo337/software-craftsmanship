---
name: design-patterns
description: Entry point for the 23 GoF design patterns (Gamma, Helm, Johnson & Vlissides). Use whenever the user asks to detect, apply, refactor toward, choose between or explain a design pattern, or describes a recurring design problem (rigid class hierarchies, big switch/if chains on type or state, scattered object creation, tight coupling, incompatible interfaces, notification/undo/plugin needs). Also use when reviewing architecture or designing new modules, even if no pattern is named. Spanish triggers - patrones de diseño, patrón GoF, refactorizar hacia un patrón, qué patrón uso. Routes to patterns-creational, patterns-structural and patterns-behavioral.
---

# Design patterns (GoF): router and method

A design pattern is a named, proven solution to a recurring design problem in a given context. Value comes from the shared vocabulary and from knowing the trade-offs, not from using as many patterns as possible. Reach for a pattern only when the problem it solves is actually present; otherwise the simplest code wins.

## Choose the mode

| Mode | When | Output |
|---|---|---|
| **A. Detect** | "what patterns does this code use / need?" | Report using `references/report-template.md` |
| **B. Refactor** | Existing code shows a smell a pattern fixes | Small behaviour-preserving steps, tests green after each |
| **C. Design** | New feature/module | Pick the lightest option, sketch participants, then code |

## Workflow

1. **Name the force.** State the problem in one sentence: what varies, what must stay stable, what hurts today. If you cannot, no pattern is justified yet.
2. **Find candidates** with `references/selection-by-problem.md` (problem to pattern) and `references/detection-signals.md` (code smell to pattern).
3. **Open the category skill** for the shortlisted patterns and read only the relevant `references/<pattern>.md`:
   - object creation: `patterns-creational`
   - composing classes/objects, wrapping, interfaces: `patterns-structural`
   - algorithms, responsibility, communication between objects: `patterns-behavioral`
4. **Check the language.** In Python, JS/TS, Kotlin, Go and similar, many patterns collapse into a function, closure, module, generator, decorator or dependency injection. See `references/language-mapping.md`. Prefer the idiomatic form and mention the classic one only as the name.
5. **Weigh the cost.** Each pattern adds indirection. Reject it if there is one variant, no foreseeable second one, and no test or coupling pain. Say so explicitly; "no pattern needed" is a valid answer.
6. **Apply minimally, preserving the project's conventions,** then verify with tests. For refactors, do one transformation at a time (introduce interface, extract, move creation, replace conditional).
7. **Name things after the pattern** only when it helps readers (`PaymentStrategy`, `OrderBuilder`), not as decoration.

## Guardrails

- Do not force a pattern to match a name. If two apply, say which and why.
- Singleton is usually better replaced by injection of a single shared instance.
- Inheritance-based patterns (Template Method, Factory Method) are costlier than composition-based ones when the language has first-class functions.
- Never copy book code; write idiomatic examples for the user's stack and language (reply in the user's language).

## References

- `references/selection-by-problem.md`: problem statement to candidate patterns, with the key distinctions
- `references/detection-signals.md`: code smells and signals per pattern
- `references/language-mapping.md`: how patterns change per language
- `references/report-template.md`: output format for mode A
- `references/source.md`: bibliography and catalog (23 patterns, page numbers)
