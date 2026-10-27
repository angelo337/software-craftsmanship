---
name: clean-architecture-design-principles
description: Apply the programming-paradigm lessons and SOLID design principles (SRP, OCP, LSP, ISP, DIP) from Martin's Clean Architecture when writing or reviewing classes and modules. Use whenever the user is designing, refactoring or reviewing code and mentions SOLID, SRP, open-closed, Liskov, interface segregation, dependency inversion, god classes, a class that changes for many reasons, a subclass that breaks callers, fat interfaces, high-level code importing low-level details (database, framework, UI), dependency injection or inversion, abstract factories, or plugin architecture. Also trigger on Spanish terms such as "principio de responsabilidad única", "inversión de dependencias", "abierto/cerrado", "segregación de interfaces". Use it even if the user does not name a principle but describes the symptom (merge conflicts in one file, if/else chains on type, tests that need a real database).
---

# Clean Architecture: paradigms and SOLID

Source: Martin (2017), Clean Architecture, Part II (Ch. 3-6) and Part III (Ch. 7-11). Paraphrased; see `references/` for depth.

## Core idea

Good architecture needs well-made "bricks" first. The three paradigms tell you what to avoid; SOLID tells you how to arrange functions and data into modules so they tolerate change, stay readable, and can be reused. "Class" here means any cohesive group of functions and data, not only OO classes.

## The three paradigms (each removes a capability)

| Paradigm | Discipline imposed on | Takes away | Architectural payoff |
|---|---|---|---|
| Structured | Direct transfer of control | Unrestricted `goto` | Code decomposes into small falsifiable (testable) units |
| Object-oriented | Indirect transfer of control | Unsafe raw function pointers | Safe polymorphism, so any source dependency can be inverted and boundaries become plugins |
| Functional | Assignment | Free mutation | Fewer races/deadlocks; push logic into immutable parts, isolate mutable state |

Why it matters: polymorphism crosses architectural boundaries, immutability disciplines data access, structured decomposition shapes algorithms. Details: `references/paradigms.md`.

## The five principles in brief

**SRP.** A module should be responsible to one, and only one, actor (a group of people who want change for the same reason). It is NOT "do one thing" (that is a function-level rule). Symptoms: accidental duplication (code shared by two actors gets "fixed" for one and breaks the other) and merge collisions in one file. Fix: separate code by actor; share only a plain data structure; optionally add a thin facade. See `references/srp.md`.

**OCP.** Behavior changes by adding code, not editing existing code. At architecture level: split by why/when things change (SRP), then point dependencies so that high-level policy is protected from low-level detail (DIP). The result is a hierarchy of protection: the more central the business rule, the fewer things it depends on. Interfaces also hide internals to avoid transitive dependencies. See `references/ocp.md`.

**LSP.** Subtypes (or any implementations of a contract) must be substitutable without callers changing behavior or checking the concrete type. Classic breach: Square as a Rectangle with coupled width/height. It also applies to architecture: services behind one REST contract must honor it identically, else special cases and config tables leak into the system. See `references/lsp.md`.

**ISP.** Do not depend on things you do not use. Split a wide interface by client. In static languages this prevents needless recompilation and redeployment; in dynamic languages the code coupling is milder, but the deeper concern (depending on baggage, e.g. a framework bound to a database) remains. See `references/isp.md`.

**DIP.** Source dependencies should point to abstractions, not volatile concretions. Rules of thumb: do not reference volatile concrete classes, do not inherit from them, do not override concrete functions (make them abstract instead), never name anything concrete and volatile. Stable platform pieces (e.g. the string type) are fine. Create volatile objects through abstract factories; gather unavoidable concrete wiring in a few concrete components, typically `main`. Control flow runs one way, source dependencies the other. See `references/dip.md`.

## Detect-and-fix workflow

1. **Map dependencies first.** List what each module imports and who imports it. Mark which are high-level policy (business rules) and which are details (DB, HTTP, UI, vendor SDK).
2. **Check direction.** Any arrow from policy to detail is a DIP violation: introduce an interface owned by the policy side, implement it in the detail side, wire in `main`.
3. **Ask "who asks for changes?"** For each class, name the actors behind its methods. More than one actor means SRP; split by actor.
4. **Look for type switches.** `if isinstance`/`switch(kind)` in callers signals missing polymorphism (OCP) or a broken substitution (LSP). Decide which: new case needs editing old code = OCP; subtype surprises callers = LSP.
5. **Count what each client uses.** Client uses a small slice of a big interface = ISP; define a narrow role interface per client.
6. **Apply the smallest fix**, re-run tests, and confirm dependencies still point inward.
7. **Report** the principle violated, the evidence (file, symptom), the fix, and the cost you accepted.

## When each principle is overkill

- SRP: do not split a class used by one actor just to get tiny classes; split when a second actor appears or when merges/collisions show up. Do not confuse it with "one method per class".
- OCP: you cannot be closed against everything. Wait for the first real change, then close against that axis of change. Do not pre-build extension points.
- LSP: not every "is-a" needs inheritance; prefer composition when substitutability is doubtful.
- ISP: do not create one interface per method; segregate by real client groups.
- DIP: do not wrap stable things (standard library, language types) or add an interface with a single implementation and no volatile detail behind it. Invert at boundaries that actually change or hurt testing.
- Small scripts and throwaway prototypes: skip the ceremony; keep the dependency direction in mind but do not build layers.

## Output style when advising

Be concrete: name the file/class, state the principle, show a short before/after sketch, and say what the user gives up (more files, indirection). Prefer one targeted fix over a full redesign.

## References

- `references/paradigms.md` structured, OO, functional and what they mean for architecture
- `references/srp.md`, `ocp.md`, `lsp.md`, `isp.md`, `dip.md` one per principle
