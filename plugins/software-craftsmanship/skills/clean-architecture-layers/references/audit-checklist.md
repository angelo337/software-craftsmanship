# Audit checklist: dependency-rule violations

## Core statement
Every import in an inner layer must point inward or to itself. An audit maps folders to circles, lists allowed imports, and finds the exceptions.

## Symptoms (what hits look like)
- Entities/use cases importing ORM, web, serialization, or cloud SDK packages.
- Use-case signatures with framework types.
- SQL, query builders or HTTP clients outside adapters.
- Entities returned to clients or built from ORM rows across a boundary.
- Concrete repositories created with `new`/constructors inside use cases.

## How to apply
1. Allowed-imports table: entities -> none outward; use cases -> entities; adapters -> use cases, entities; frameworks -> all.
2. Grep imports per inner folder, e.g. `rg -n "^(import|from|using|require)" domain/ usecases/`; exclude stdlib and pure utilities.
3. Grep for outer markers: `rg -n "HttpRequest|Session|Repository\(|SELECT |@Entity|models\.Model|ActiveRecord|DbContext" domain/ usecases/`.
4. Check decorators/annotations and base classes on entities and DTOs.
5. For each hit record file, name, layer pair, fix (introduce port, move outward, map to plain data), severity.
6. Fix highest-traffic leaks first; then add enforcement: ArchUnit (Java), import-linter (Python), dependency-cruiser (TypeScript), NetArchTest (.NET), packwerk (Rails).

## Language and framework notes
- Spring: check @Entity, @Autowired concrete classes, ResponseEntity in services.
- Django: check `django.*` imports in rules modules; models imported by use cases.
- FastAPI: check pydantic/fastapi imports in domain.
- NestJS: check @nestjs/* and typeorm in domain/use cases.
- ASP.NET: check project references and Microsoft.AspNetCore / EntityFramework usings.
- Rails: check ActiveRecord calls inside service/domain code.

## Common over-application
- Treating every library import as a violation; judge by volatility and framework shape.
- Auditing tiny apps to full purity; report proportionately.
- Big-bang refactors instead of incremental fixes with a CI guard.

## Source
Martin (2017), Ch. 19-22.
