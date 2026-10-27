# The Dependency Rule

## Core statement
Source-code dependencies point only inward, toward higher-level policy. Nothing in an inner circle may name anything declared in an outer circle, and inner code must not consume data formats produced by an outer framework. Why: so outer details can be swapped without touching the rules.

## Symptoms of violation
- Entities or use cases import ORM models, web request types, or serializer classes.
- A use case method signature takes or returns a framework object.
- Tests of business logic need a database, container or server.
- Swapping the DB or web framework forces edits in business code.
- SQL or HTTP status codes appear in use-case code.

## How to apply
1. Name your circles (entities, use cases, adapters, frameworks); add more if useful, the rule is unchanged.
2. When inner code must trigger outer behavior, define an interface in the inner circle and implement it outside (dependency inversion).
3. Pass plain data across boundaries, shaped for the inner side.
4. Wire concrete classes to interfaces in one outermost composition root.
5. Enforce with an automated import rule in CI.

## Language and framework notes
- Spring: keep @Entity/@Component annotations off domain classes if you want pure entities; map JPA entities to domain objects in the adapter; wire with @Configuration in the outer layer.
- Django: models are ORM-bound, so they belong to the adapter/framework side; keep rules in plain Python modules and map in repositories.
- FastAPI: Pydantic schemas are boundary models; do not let them leak into the domain; use Depends only at the edge.
- NestJS: keep providers and decorators in the outer modules; domain and use-case classes stay decorator-free where practical, bound through custom providers.
- ASP.NET: controllers and EF DbContext are outer; use cases depend on interfaces declared in the application project; reference direction enforced by project references.
- Rails: ActiveRecord couples rules to persistence; extract plain Ruby objects or service objects and keep models thin where rules matter.

## Common over-application
- Banning all library use inward: pure utility libraries (dates, math) are fine; the issue is volatile, framework-shaped dependencies.
- Interfaces for things that never cross a boundary.
- Mapping layers that copy identical fields with no divergence.

## Source
Martin (2017), Ch. 22.
