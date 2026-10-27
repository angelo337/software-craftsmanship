---
name: clean-architecture-details-and-packaging
description: Decide what is a replaceable detail (database, ORM, web framework, UI, OS, hardware) and how to organize code so details stay at arm's length. Use when choosing, deferring or swapping a database, ORM, web framework or UI; when worried about framework lock-in; when embedded/firmware code must be separated from hardware (HAL, OSAL, off-target testing); or when deciding how to organize packages and folders - package by layer, package by feature, ports and adapters, package by component - and how to enforce boundaries with visibility, modules or build tools. Trigger on "database is a detail", "framework lock-in", "ORM", "package by feature", "package by layer", "ports and adapters", "hexagonal", "estructura de carpetas", "organizar paquetes", "defer decisions", "firmware", "HAL", "public everywhere". Based on Martin (2017) Clean Architecture Ch. 29-34 (Ch. 34 by Simon Brown).
---

# Details and Packaging (Clean Architecture Ch. 29-34)

Core idea: business rules and the data model are the architecture; databases, the web, frameworks, operating systems and hardware are mechanisms. Keep mechanisms in outer layers behind boundaries so you can defer, test without, and replace them. Then make the code structure and the language's visibility rules enforce that intent.

## How to use this skill
1. Identify the detail in question (table below).
2. Apply the one-line rule, then open the matching reference for steps and examples.
3. Check the over-engineering warnings before adding a boundary.

| Question | Read |
|---|---|
| Which DB / ORM / storage, or SQL leaking into logic | references/databases.md |
| Web, REST, SPA, GUI, "move the UI to X" | references/web-and-gui.md |
| Adopting or being stuck in a framework | references/frameworks.md |
| Firmware, drivers, RTOS, testing off-target | references/embedded.md |
| Splitting a system by actors/components, deployment grouping | references/case-study-video-sales.md |
| Folder/package layout and enforcing it | references/packaging-styles.md |

## Details at a glance

| Detail | One-line rule | Why |
|---|---|---|
| Database / ORM | Data model is architecture; the DBMS is a mechanism behind a gateway | Disks forced DBMSs on us; in RAM you use lists and trees anyway. Rows and ORM entities leaking inward couple use cases to table shape |
| Web / GUI | The web is an IO device; use cases take plain input data and return plain output data | UI paradigms swing like a pendulum (thin/thick client); marketing can demand a new look any release |
| Framework | Use it, do not marry it; keep it in outer plugins | Author takes on no commitment to you; you take all the risk |
| OS / RTOS | Hide behind an OS abstraction layer (OSAL) | Vendor, price, or capability changes force semantic rewrites, not just renames |
| Hardware / processor | Hide behind a hardware abstraction layer (HAL) shaped by what the app needs | Code that touches registers becomes firmware: tied to silicon and untestable off target |

## Databases are details
- Distinguish the data model (significant) from the database (a utility moving bits between disk and RAM).
- Never pass table rows, ORM entities or query objects into use cases or UI. Define your own entities/DTOs and map at the gateway.
- Performance is real but is a low-level concern: solve it inside the gateway with indexes, caches, tuned queries; it does not change the architecture.
- Pragmatic lesson from the book's anecdote: the author was right technically that the core did not need an RDBMS, but customers expected one as a checkbox. Correct move: keep the simple store in the core and bolt the RDBMS on the side through a narrow channel. Market expectations are real constraints; boundaries let you satisfy them cheaply.
- Defer: start with in-memory or file adapters behind the same interface; pick the DBMS when the data access pattern is known.

## The web is a detail
- GUI is a detail; the web is a GUI; so the web is a detail. Computing power has oscillated between center and edge since mainframes (applets, Ajax, Node...). Push those swings out of the core.
- The browser/app dance (validation, drag and drop, chatty requests) cannot be abstracted, but the use-case boundary can: complete input data in, resulting output data out.
- Controllers translate HTTP into request models; presenters turn response models into view models. Use cases never import request/response types of the web framework.

## Frameworks: the asymmetric marriage
- Risks: frameworks violate the Dependency Rule by asking you to inherit their base classes in entities; you outgrow them; they evolve in directions you do not need; a better one appears.
- Solution: do not derive business objects from framework classes. Write your own core classes and derive proxies/adapters in plugin components. Annotations like `@Autowired` or ORM decorators do not belong on entities; wire with the framework only in Main or a composition root (the dirtiest, lowest-level component).
- Some marriages are unavoidable (standard library, STL, language runtime). Make that a conscious decision, not an accident. Date first: delay coupling for as long as feasible.

## Embedded
- Firmware is defined by what it depends on and how hard it is to change as hardware evolves, not by where it is stored. Software dies from within through unmanaged dependencies on hardware.
- "Make it work" is not enough (the app-titude test): then make it right, then make it fast. Do not stop at step one.
- Target-hardware bottleneck: if you can only test on the target, you are slow. Introduce seams: HAL (shaped by app needs, e.g. `indicate_low_battery()` not `led_on(5)`), PAL for processor registers/compiler extensions, OSAL for the RTOS.
- Use standard types (`stdint.h`) in software; confine vendor headers and extensions to few firmware files. Headers are interfaces: put only declarations needed by callers in them.
- Replace scattered `#ifdef BOARD_X` with interfaces bound at link or run time.

## Video-sales case study (how the pieces combine)
- Identify actors (viewer, purchaser, author, admin) and use cases; each actor is a source of change (SRP). Shared behavior becomes an abstract use case (catalog view) with actor-specific specializations.
- Components: views, presenters, interactors, controllers, each split per actor. Dependencies cross boundaries toward higher-level policy; "uses" arrows follow control flow, inheritance arrows oppose it.
- Keep the right to regroup components into few deployables (e.g. one jar per layer, or two) as the system changes. Two separations: by actor (reasons to change) and by policy level (rates of change).

## Packaging: four styles

| Style | Slices by | Strength | Weakness | Fits when |
|---|---|---|---|---|
| By layer | technical role (web/service/repo) | Fast start, familiar | Says nothing about the domain; 3 big buckets; everything must be public; easy to bypass layers | Small CRUD apps, prototypes, short-lived tools |
| By feature | domain concept in one package | Screams the domain; one place to change a use case | Still weak encapsulation of internals if types public; cross-feature access awkward | Teams already hurt by layers, modest complexity |
| Ports and adapters | inside (domain) vs outside (infra) | Domain independent of web/DB; testable | Extra interfaces/mapping; single infra tree allows adapter-to-adapter shortcuts ("Peripherique") | Rich domain, expected tech churn |
| By component | coarse component = logic + persistence behind one interface, UI separate | Compiler-enforced encapsulation; step toward microservices | Needs discipline on what is public; needs separate assembly in .NET | Monoliths that want to stay modular |

Decision shortcut: small and short-lived -> layer or feature; domain-heavy with churn in tech -> ports and adapters; growing monolith -> component, with ports and adapters inside the component if the domain warrants.

## Organization versus encapsulation
- If every type is public, packages are just folders and all four styles collapse into the same layered graph. Intent is lost.
- Make the narrowest visibility work: implementations package-private (Java), `internal` plus one assembly per component (.NET), unexported (Go), `_private` plus `__all__` and an explicit `index.ts` barrel (Python/TS). Expose only the component interface.
- Enforcement ladder (weakest to strongest): code review/discipline -> post-compile static analysis (ArchUnit, NDepend, dependency-cruiser, import-linter) -> compiler visibility -> separate modules/source trees in the build tool (Maven, Gradle, MSBuild, npm workspaces). Prefer the strongest affordable; also watch coupling through shared data models.
- Module systems (OSGi, Java 9) separate "public" from "published".
- Do not bypass with reflection. Remember Java packages are not hierarchical for access.

## Over-engineering warnings
- A boundary costs mapping code and files. Add it where a detail is likely to change, hurts tests, or the cost of later change is high; otherwise leave a partial boundary or an interface you can cut in later.
- Do not wrap a framework you will certainly keep for the app's lifetime (standard library) purely out of principle.
- One implementation, no test need, no churn: skip the interface. Do not create a source tree per component until pain justifies it; two trees (domain, infra) is a legitimate midpoint.
- Size boundaries to team size, skill, and budget. Leave options open but be pragmatic.
- Note: "database is a detail" does not mean "ignore the database": model data deliberately and tune queries.

## Sources
Martin (2017), Ch. 29 (Grenning), 30, 31, 32, 33; Ch. 34 by Simon Brown.
