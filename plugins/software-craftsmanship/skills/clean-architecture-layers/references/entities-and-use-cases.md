# Entities and use cases

## Core statement
Entities hold critical business rules and the data they operate on, independent of any application. Use cases hold application-specific rules, orchestrate entities, and exchange simple request and response data across input and output boundaries. Entities do not know use cases; use cases know entities.

## Symptoms
- "Entities" that are anonymous data bags while rules sit in controllers or services.
- Entities that load themselves from a DB or format themselves for a screen.
- Use cases that mention HTML, JSON, sessions or SQL.
- Request/response classes extending framework types, or wrapping entity objects.
- Business flow (step ordering, preconditions) scattered across controllers.

## How to apply
1. Ask of each rule: would it exist if done manually? Yes -> entity. Only exists because of the automated flow -> use case.
2. Put rule and its data in one module; no persistence or UI types.
3. Write one use case per user goal: validate input, fetch entities via an interface, invoke entity rules, report via an output interface.
4. Define request and response as plain structures with only primitives or other plain structures.
5. Keep entity and request/response models separate even if fields overlap now; they change for different reasons.

## Language and framework notes
- Spring: use-case class as a plain @Service-free POJO registered in config; DTOs as records.
- Django: use-case functions or classes in a plain module; views call them; serializers stay in the web layer.
- FastAPI: route handler maps Pydantic body to a dataclass request, calls the interactor.
- NestJS: interactor as an injectable only if needed; request/response as plain interfaces or classes without decorators.
- ASP.NET: MediatR-style handlers are use cases when they avoid HttpContext and EF types.
- Rails: service objects or interactors returning plain result objects.

## Common over-application
- A use case class for each trivial read or CRUD pass-through.
- Anemic entities forced into existence when no critical rule exists.
- Treating the layer split as requiring object-orientation; modules and functions work.

## Source
Martin (2017), Ch. 20 and Ch. 22.
