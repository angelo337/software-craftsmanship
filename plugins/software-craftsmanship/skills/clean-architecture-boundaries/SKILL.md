---
name: clean-architecture-boundaries
description: Decide where to draw architectural boundaries and how to implement, defer, or skip them, following Martin's Clean Architecture. Use whenever the user asks about a "boundary", "architectural boundary", where to separate business rules from UI, database, or framework, plugin architecture, the humble object pattern, presenters and view models, partial boundaries, layers, the main component, microservices or "services architecture", testing at boundaries, fragile tests, or says "límites arquitectónicos" or "dónde separar". Also use when reviewing a design that couples policy to details, debating whether a service split is real architecture, or deciding if a boundary is worth its cost. Trigger even if the user never says "clean architecture".
---

# Clean Architecture: Boundaries

A boundary is a line between things that matter (business policy) and things that
do not (details: UI, database, web, frameworks, DI container, delivery mechanism).
The line exists so that details can be decided late, swapped, and kept from
polluting the core. Everything below is a way to place, build, or consciously skip
such lines.

## Core rules

1. **Draw lines along axes of change.** Parts that change at different rates or for
   different reasons get a boundary (the Single Responsibility Principle applied to
   components). GUI, database, and DI framework each change for reasons the
   business rules do not share.
2. **Details depend on policy, never the reverse.** Every source dependency that
   crosses a line points toward the higher-level (business) side. The business side
   owns the interface; the detail implements it. That is what makes the detail a
   plugin and gives you a one-way firewall: the detail can break, the core cannot.
3. **IO is irrelevant to the rules.** The screen, the store, and the transport
   are replaceable; the model behind them runs without them. Defer those decisions
   instead of letting them shape the core.
4. **Defer decisions by putting an interface in front of them.** Stub it, then use
   an in-memory version, then a simple file version, and pick the real technology
   only when evidence demands. You may defer it out of existence.
5. **Premature topology is a cost, not an architecture.** Three tiers, a service
   mesh, or a domain-object service per entity, adopted before they are needed,
   multiply effort on every feature.

Details: `references/drawing-boundaries.md`.
## How boundaries are crossed

At runtime a crossing is just a call plus some data. The art is controlling
*source* dependencies, because source changes force recompile and redeploy.

| Form | Cost of crossing | Notes |
|---|---|---|
| Source-level (monolith) | Function call, cheap, can be chatty | Needs dynamic polymorphism to point dependencies the right way |
| Deployment-level (jar, DLL, gem, package) | Function call, cheap | Delivered as binaries; same dependency rules |
| Threads | Not a boundary | Only scheduling; can live inside or across components |
| Local process | OS call, marshaling, context switch; limit chattiness | Higher-level code must not name or locate lower-level processes |
| Service | Network latency (ms to seconds); avoid chatter | Higher-level code must not embed URIs of lower-level services |

- Calling toward the higher level: a plain call. Calling toward the lower level:
  invert with an interface defined on the caller's side.
- Pass simple data structures (plain DTOs, dicts, dataclasses). Never pass
  entities, ORM rows, or framework request objects across; the data shape is owned
  by the inner side and must not drag a detail's types along.
- Real systems mix forms; a service is often a facade over local processes.

Details: `references/boundary-crossing.md`.
## Humble Object

Split a hard-to-test behavior into a **humble** part (thin, nearly logic-free, hard
to test: view, SQL gateway implementation, ORM mapper, service listener) and a
**testable** part (presenter, interactor) that does all the formatting and
decisions. The presenter turns data into a view model of strings, booleans, and
enums; the view only copies it to the screen. Gateways: use cases call a
persistence interface with intent-revealing methods (no SQL in use cases); the
humble implementation lives in the database layer. An ORM is a data mapper
living in that layer, not part of the business rules. Boundaries often appear
exactly where you split testable from untestable, and a simple data structure
usually crosses them.

Details: `references/humble-object.md`.
## Partial boundaries

A full boundary (reciprocal interfaces, input and output structures, separate
components) is expensive. When you suspect you will need one but cannot justify
the price, hold its place:

1. **Skip the last step.** Build the interfaces and data structures, but compile and
   ship as one component. Same design effort, no versioning or release overhead.
2. **One-dimensional boundary.** A single Strategy-style interface the client uses
   and implementations satisfy. Dependency inversion is there; the reverse
   direction is protected only by discipline.
3. **Facade.** One class lists the services and hides the rest. No inversion, and the
   client still depends transitively on everything behind it.

All three decay into backchannels if the real boundary never arrives. Revisit
them; do not leave placeholders unattended.

Details: `references/partial-boundaries.md`.
## Layers and hidden boundaries

"UI / rules / database" is rarely the whole picture. A tiny text game already has
more axes: language of the text, the delivery channel (shell, SMS, chat),
storage, and even multiple levels of policy (map mechanics below, player health
and win/lose above). Each axis is a candidate boundary; the interface is owned by
the upstream (user) side, the variations implement it. Data usually flows in several
streams (user side, persistence side, network) that all meet at the top policy, and
the policy itself can split into higher and lower levels. Boundaries are everywhere;
implement only the ones whose cost of absence now exceeds their cost of presence.

Watch for the first friction from a missing boundary and re-decide often; build it at
the point where building becomes cheaper than ignoring. Late boundaries are costly
even with good tests, yet over-engineering is often worse than under-engineering.

## Main component

Main is the lowest-level policy and the dirtiest component: the entry point,
nothing depends on it, and it knows all the concrete details. It creates
factories, strategies, config, and DI wiring (let the DI framework live only here,
then pass dependencies on plainly), then hands control to the high-level system.
Treat Main as a plugin behind a boundary: one per configuration (dev, test,
production, per country or customer). Keep business logic out of it.

Details: `references/main-component.md`.
## Services are not architecture by themselves

A service is a function call across a process or network boundary. It is
architecturally significant only if it separates policy from detail along the
Dependency Rule. Two fallacies sell services short of reality:

- **Decoupling fallacy.** Services still share data formats and meaning; a new field
  ripples through every consumer. Well-defined interfaces are no better than
  function signatures.
- **Independent development and deployment fallacy.** Coupled by data or behavior
  means coordinated change. Monoliths and component systems scale to large
  enterprises too.
- **Kitty problem.** A new cross-cutting feature (kitten delivery through a taxi
  system) touches every functional-decomposition service. Fix it with
  polymorphism: base abstractions in each service, features as extra components
  loaded without changing existing ones (open-closed).

Conclusion: boundaries run **through** services, dividing them into components. Give
services an internal component structure that follows the Dependency Rule.

Details: `references/services.md`.
## Test boundary

Tests are the outermost component: they depend inward, nothing depends on them, and
they deploy independently. They are part of the design.

- **Fragile tests problem.** Tests coupled to volatile things (GUI paths, internal
  class structure) break in bulk and make the system rigid.
- **Do not depend on volatile things.** Test business rules without the GUI.
- **Structural coupling.** One test class per production class mirrors the
  structure; refactoring then breaks tests. Hide structure.
- **Testing API.** A superset of the interactors/adapters the UI uses, with
  superpowers (skip auth, bypass the database, force states). Keep dangerous parts
  in a separately deployable component so they never reach production.

Details: `references/test-boundary.md`.

## Decision workflow

1. List the details involved (UI, DB, transport, framework, vendor, config).
2. For each, ask: does the core need to know it? If not, it is a plugin candidate.
3. Name the axes of change and who owns each interface (the inner side).
4. Compare the cost of the boundary now with the cost of its absence if you are wrong.
5. Choose full, partial (one of three forms), or none; record why.
6. Pick the crossing form from deployment and latency needs, not fashion.
7. Cross with plain structures; add humble objects at untestable edges.
8. Wire it in Main; have tests use the testing API, not the GUI.
9. Watch for friction and revisit; promote partial boundaries when pain shows.

## Over-engineering warnings

- No full boundary for every class pair; a script-sized program needs none.
- Do not split into services for decoupling alone; first fix the component design.
- No single-implementation interfaces without a change axis, unless deliberately holding a place.
- Do not leave placeholders to rot; decayed partial boundaries are worse than none.

Source: Martin (2017), Clean Architecture, Ch. 17, 18, 23-28.
