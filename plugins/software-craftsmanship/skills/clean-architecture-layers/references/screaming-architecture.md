# Screaming architecture

## Core statement
The top-level structure of a codebase should reveal what the system does (its use cases and domain), not which framework it uses. Frameworks are tools to keep at a distance; the web is an I/O device; the system should be testable without them.

## Symptoms
- Root folders named controllers, models, views, or only the framework's defaults.
- A newcomer cannot tell the business domain from the tree.
- Use cases can only be tested through HTTP or a booted container.
- Choosing a framework or database was the first decision, and is now hard to undo.

## How to apply
1. Organize top-level folders by domain capability (e.g. billing, enrollment, claims); inside each, separate use cases, entities and adapters.
2. Keep framework glue in a clearly outer folder (web, persistence, config).
3. Defer delivery and storage choices; start with in-memory fakes behind interfaces.
4. Write unit tests that run each use case with fakes and no framework.
5. Review: could a stranger list the use cases from the tree alone?

## Language and framework notes
- Spring: package by feature, not by layer type; keep Boot app class at the edge.
- Django: apps named for domain concepts; keep rules in plain modules inside, not in views or models.py alone.
- FastAPI: one package per capability; routers are thin and live in a web subfolder.
- NestJS: feature modules named for the domain; framework modules stay shallow.
- ASP.NET: separate Application and Domain projects named for the business; Web project is a shell.
- Rails: consider domain namespaces under app/ (or engines) instead of only the default folders.

## Common over-application
- Fighting a framework's conventions so hard that onboarding suffers; compromise at the edges.
- Reorganizing a small app purely for aesthetics.
- Treating this as a rule against any framework; it is about who is in charge.

## Source
Martin (2017), Ch. 21.
