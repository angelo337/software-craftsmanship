# Packaging Styles and Enforcement

## Core statement
Good designs fail at implementation: how code is grouped and what is visible. Four styles exist, and none helps if every type is public, because packages then become folders and all styles collapse into the same layered graph. Choose a style, map it to code structure, and let the compiler or build tool enforce it.

## Symptoms
- Top-level folders read `controllers/ services/ repositories/` for every product.
- Controllers call repositories, skipping business logic (relaxed layering), and authorization is bypassed.
- Public everywhere; anyone can instantiate implementation classes.
- Architecture rules live only in code review or a wiki.
- Folders reorganized after each pain, with no change in actual dependencies.

## The styles

| Style | Structure | Visibility effect | Trade-off |
|---|---|---|---|
| By layer | web / service / repository packages | Interfaces public across layers; implementations can be package-private | Quick start; hides the domain; skip-layer calls easy |
| By feature | one package per concept (orders) | Entry point public, rest package-private | Domain-centric; other features cannot reach internals unless via entry point |
| Ports and adapters | domain (inside) vs infrastructure (outside); outside depends on inside | Domain ports public; adapters package-private, injected | Mapping overhead; one infra tree allows adapter-to-adapter shortcuts |
| By component | component bundles logic and persistence behind one interface; UI separate | Only the component interface public | Needs care on granularity; stepping stone to microservices |

Naming note: inside the domain, use ubiquitous language (`Orders`, not `OrdersRepository`).

## How to apply
1. Pick the style from size, domain richness, expected tech churn and team skill (see SKILL.md decision shortcut).
2. Write the one-sentence rule you want enforced ("web code never touches persistence directly").
3. Make implementations non-public by default; promote only what has legitimate outside callers.
4. If the language lacks package-level privacy, use module boundaries, separate assemblies/packages or lint rules.
5. Add an automated architecture check to CI.
6. Escalate separation as needed: packages -> modules in one build -> separate source trees per component. Two trees (domain, infra) is a good compromise; add per-component trees where shortcuts keep appearing.
7. Watch coupling that visibility cannot catch: shared data models, shared tables.

## Example (TypeScript, package by component)
```ts
// orders/index.ts  - the only file other code may import
export interface OrdersComponent { status(orderId: string): Promise<string> }
export const createOrders = (db: Db): OrdersComponent => new OrdersImpl(new SqlOrdersRepo(db));

// orders/internal/*.ts - not exported from index.ts
class SqlOrdersRepo { /* persistence */ }
class OrdersImpl implements OrdersComponent { /* logic using the repo */ }
```
Add a lint rule (dependency-cruiser or ESLint `no-restricted-imports`) forbidding `orders/internal/**` imports from outside `orders/`.

```python
# import-linter contract in pyproject.toml (illustrative)
# [[tool.importlinter.contracts]]
# name = "web must not touch persistence"
# type = "forbidden"
# source_modules = ["app.web"]
# forbidden_modules = ["app.orders.persistence"]
```

## Language and framework notes
- Java: package-private classes; Java 9 modules/OSGi separate public from published; packages are not hierarchical for access, only by name. Avoid reflection tricks. ArchUnit, Checkstyle, Structure101 help.
- .NET: `internal` with one assembly per component; NDepend for rules.
- Python: underscore names, `__all__`, import-linter; TypeScript: barrel export plus lint rule, or workspaces with `exports` in package.json.
- Go: unexported identifiers and `internal/` directories are compiler-enforced.
- Build tools (Maven, Gradle, MSBuild, npm workspaces): separate modules give compile-time dependency control.

## Common over-application
- A source tree per component from day one: real costs in performance, complexity and maintenance.
- Enforcing layering strictly when CQRS-style reads legitimately bypass the service layer; state this as the rule.
- Reorganizing folders without changing visibility; nothing is actually enforced.
- Switching styles because of fashion. Fit them to team size, skill, budget and schedule.

## Source
Brown, in Martin (2017), Ch. 34 The Missing Chapter.
