---
name: clean-architecture-layers
description: Structure an application into layers (entities, use cases, interface adapters, frameworks and drivers) so business logic stays independent of frameworks, database and UI. Use when designing or refactoring with clean architecture, hexagonal / ports-and-adapters or onion style, defining use cases, entities or interactors, auditing a codebase for dependency-rule violations, or choosing a folder structure that reveals intent (screaming architecture). Trigger on "clean architecture", "dependency rule", "use case", "entities", "interactor", "hexagonal", "ports and adapters", "onion", "screaming architecture", "arquitectura limpia", "capas", "casos de uso".
---

# Clean Architecture: layers and the Dependency Rule

Based on Martin (2017), Ch. 19-22. Paraphrased; apply with judgment, not as dogma.

## Core idea

Separate what the software decides (policy) from how it talks to the world (mechanism). Source-code dependencies point only toward policy. Why: policy changes rarely and for important reasons; mechanisms (UI, DB, frameworks) change often and for trivial ones. Pointing dependencies inward keeps urgent-but-trivial changes from rippling into the business rules.

## Policy and level (Ch. 19)

- Level = distance from inputs and outputs. The farther a policy is from I/O, the higher its level.
- Group policies that change for the same reason at the same time; split those that do not.
- Data flow and source dependencies need not agree. Make dependencies follow level, not data flow.
- Low-level code is a plugin to high-level code: the high-level side owns the interface, the low-level side implements it.
- Smell: a high-level function that directly calls read/write/DB/HTTP helpers. Fix: introduce an interface owned by the high-level side.

See references/policy-and-level.md.

## Entities vs use cases (Ch. 20)

| | Entity | Use case |
|---|---|---|
| Holds | Critical business rules + the data they act on | Application-specific rules |
| Exists without software? | Yes (a bank charges interest either way) | No (only makes sense inside the automated flow) |
| Knows about | Nothing outward | Entities, and its own boundary interfaces |
| Level | Highest | Lower, closer to I/O |

- Entity: bind rules and data together in one module. No DB, UI or framework types. It need not be a class.
- Use case: orchestrates entities ("controls the dance"): takes input, runs steps, produces output. It never describes screens, HTML or SQL, so the same use case works on web, console or service.
- Entities never know use cases exist. Use cases know entities.
- Boundary: the use case exposes an input interface (to be called) and an output interface (to report results), both defined in its own layer.
- Request and response models: simple data structures with no framework base classes (no HttpRequest/HttpResponse). Do NOT embed entity objects in them: they change for different reasons, and coupling them yields tramp data and conditionals.

See references/entities-and-use-cases.md.

## Screaming architecture (Ch. 21)

- The top-level folders and root package should announce the domain (health care, billing, inventory), not the framework.
- Architecture supports use cases; frameworks are tools you hold at arm's length, not a way of life.
- The web is an I/O device. Defer the decision about delivery, DB and framework as long as is sensible.
- Test: every use case runs in a unit test with no web server, no DB, no framework booted.

See references/screaming-architecture.md.

## The four circles and the Dependency Rule (Ch. 22)

Outer to inner:

1. Frameworks and drivers: DB, web framework, devices. Mostly glue code. Details live here.
2. Interface adapters: controllers, presenters, views, gateways/repositories, converters. All SQL lives here. Converts between the form convenient for use cases and the form convenient for the outside.
3. Use cases: application-specific rules.
4. Entities: enterprise-wide critical rules (or the core business objects of a single app).

The Dependency Rule: source dependencies point only inward. An inner circle must not mention any name (class, function, variable, type) declared in an outer circle, nor use data formats an outer framework generates. The circles are schematic: add more if needed, but the rule always holds.

Why: anything inward can then be tested, reused and kept alive while outer parts are replaced.

See references/dependency-rule.md.

## Crossing boundaries and what crosses

- When control flows outward (use case must call presenter), use dependency inversion: the use case calls an output interface it owns; the outer class implements it. Dependencies then oppose control flow exactly at the boundary.
- What crosses: simple, isolated data structures (plain structs/DTOs, function arguments, maps), shaped for the inner circle's convenience.
- Never pass entities, ORM rows, or framework request objects across a boundary.

## Typical flow

controller builds plain request data -> calls use case input port -> interactor loads entities via a data-access interface, runs the rules -> builds plain output data -> calls output port -> presenter turns it into a view model (formatted strings, flags) -> view just renders.

Worked example: references/flow-of-control-example.md.

## Layer checklist

- Entities: no imports from use cases, adapters, frameworks, ORM, serialization annotations tied to a framework.
- Use cases: import only entities and their own interfaces; no HTTP, SQL, ORM session, UI types; request/response are plain data.
- Interface adapters: depend inward only; contain controllers, presenters, repository implementations, mappers; no business decisions.
- Frameworks/drivers: wiring and configuration only; the one place that sees everything (composition root).
- Data crossing a boundary is plain and in the inner circle's shape.

## Audit procedure for dependency-rule violations

1. Map folders to circles; ask the team if unclear. Write the allowed-imports table: entities -> nothing outward; use cases -> entities; adapters -> use cases, entities; frameworks -> anything.
2. For each inner folder, grep its imports (`import`, `from`, `using`, `require`, `use`) and list every external package and every sibling outer module.
3. Flag: framework or ORM imports in entities/use cases; web types in use-case signatures; entities returned straight to the HTTP layer or accepting ORM rows; SQL strings outside adapters; use cases that instantiate concrete repositories.
4. Check annotations: ORM/JSON/validation decorators on entities are a coupling even without an import line in some stacks.
5. Report each hit with file, offending name, layer pair, and the fix (introduce interface, move code outward, map to plain data).
6. Prefer fixing the worst, highest-traffic leaks first, and add an automated import check (ArchUnit, import-linter, dependency-cruiser, NetArchTest) so it stays fixed.

See references/audit-checklist.md.

## Over-engineering warnings

- A CRUD app with no real rules gains little from four circles; forced layers become pass-through boilerplate. Start thin and extract when a rule appears.
- Small scripts and prototypes: one module with a clear core/IO split is enough.
- Do not create an interface per class; create one only at a boundary where a dependency would otherwise point outward.
- Do not duplicate every model four times if layers would hold identical fields and no divergence is in sight; map where the shapes truly differ.
- The aim is isolation of policy, not folder ceremony. If you cannot name a change the boundary protects against, skip it.
