---
name: clean-architecture
description: Entry point for software architecture work based on Martin's Clean Architecture (2017). Use whenever the user asks to review, design, critique or evolve a system's architecture, mentions layers, boundaries, dependency rule, SOLID at scale, components, use cases, monolith vs microservices, framework/database independence, or "is this architecture clean?". Routes to the specialised clean-architecture-* skills and applies the core ideas (policy vs details, keeping options open).
---

# Clean Architecture (orchestrator)

Based on Martin (2017), chapters 1, 2, 15 and 16 plus routing to the rest of the book. Paraphrased, not quoted.

## Core ideas

1. **Goal of architecture**: minimize the human effort needed to build and maintain the system. Good design keeps the cost per change flat over releases; bad design makes it grow.
2. **Design and architecture are one continuum**: high-level structure and low-level detail are the same fabric. Do not treat "architecture" as a separate, detached activity; architects keep programming.
3. **Two values of software**: behavior (urgent, not always important) and structure/changeability (important, rarely urgent). A working-but-unchangeable system dies; a broken-but-changeable one can be fixed. Defend structure against feature urgency.
4. **Going fast means going well**: messy code is slower even in the short term; "we'll clean it up later" does not happen; a full rewrite repeats the same overconfidence.
5. **Architecture's job** is to support the life cycle: development, deployment, operation, maintenance. Behavior itself is only weakly shaped by architecture; the architecture should make use cases visible.
6. **Keep options open**: split the system into *policy* (business rules, where the value is) and *details* (IO, database, web, frameworks, protocols). Make policy ignorant of details so decisions about them can be deferred or changed. A good architect maximizes decisions not made.
7. **Decouple by reason to change**: horizontal layers (UI, application rules, domain rules, persistence) and vertical use-case slices, so teams and use cases do not collide (Conway's law).
8. **Duplication judgement**: remove true duplication; do not merge accidental duplication (similar screens, DB record vs view model) that evolves for different reasons.
9. **Decoupling mode is an option**: source level (monolith), deployment level (jars/DLLs/packages), service level. Start low, make it possible to go up (and back down); do not default to services.

## Workflow

### Mode A: Review an existing system
1. Map what exists: modules, dependency direction, where business rules, UI, DB and framework code live.
2. State what the structure "screams" (route to `clean-architecture-layers`, screaming architecture).
3. Check the dependency rule, cycles, stable-dependency direction (route below).
4. Check which details are leaked into policy (ORM types in entities, HTTP in use cases, framework annotations in domain).
5. Report: findings ranked by cost-of-change impact, each with evidence (file/import), the principle, and the smallest corrective step. Prefer incremental fixes over rewrites.

### Mode B: Design a new system / feature
1. List use cases and identify policy vs details; list decisions that can be deferred.
2. Choose initial decoupling mode (default: source level, with boundaries drawn where a service could later be cut).
3. Sketch layers and dependency direction; place boundaries (`clean-architecture-boundaries`).
4. Pick component structure and check metrics (`clean-architecture-components`).
5. Name the deferred decisions and the trigger for revisiting each.

## Routing table

| Question | Skill |
|---|---|
| Paradigms, SRP/OCP/LSP/ISP/DIP applied to design | `clean-architecture-design-principles` |
| Component cohesion/coupling, cycles, stability, abstractness metrics | `clean-architecture-components` |
| Where to draw boundaries, humble object, partial boundaries, main, services, test boundary | `clean-architecture-boundaries` |
| Dependency rule, entities, use cases, screaming architecture, audit checklist | `clean-architecture-layers` |
| Database, web, frameworks as details; embedded; package-by-layer/feature/component | `clean-architecture-details-and-packaging` |

Load the relevant sibling when the question is specific; stay here for broad or mixed questions.

## Warnings

- Do not over-architect small systems: a small team may rightly start without heavy structure; draw boundaries where change pressure is real.
- Microservices do not equal good architecture; services are a deployment mode, not a design.
- Advice here is a heuristic from one author's experience; verify against the actual code and team constraints.

## Reference
Martin, R. C. (2017). *Clean architecture: A craftsman's guide to software structure and design*. Prentice Hall.
