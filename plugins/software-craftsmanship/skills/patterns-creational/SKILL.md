---
name: patterns-creational
description: Apply, detect, or refactor toward the 5 GoF creational design patterns (Abstract Factory, Builder, Factory Method, Prototype, Singleton) from Gamma et al. 1995. Use whenever the user has an object-creation problem - `new`/constructors scattered across the code, hard-coded concrete classes, if/else or switch chains choosing which class to instantiate, telescoping constructors with many optional parameters, families of objects that must be swapped together (themes, DB drivers, cloud providers), expensive objects that should be cloned or copied, global state or "only one instance" requirements, or any mention of factories, builders, cloning, singletons, dependency injection of creators. Also trigger on Spanish requests - "patrón de creación", "patrón de diseño creacional", "fábrica", "fábrica abstracta", "método fábrica", "constructor con muchos parámetros", "singleton", "clonar objetos", "prototipo". Use even if the user does not name a pattern, when the real issue is how objects get created.
---

# Creational patterns (GoF)

Creational patterns hide *which* concrete class is built, *how* it is assembled, and *who* decides. Use them to keep client code dependent on interfaces instead of constructors, so creation can change in one place. They cost indirection, so apply one only when a real variation point exists.

Two ways to parameterize "what gets created" (Gamma et al., 1995, p. 135):
- **Inheritance**: subclass the creator -> Factory Method.
- **Composition**: pass in an object that knows what to create -> Abstract Factory, Builder, Prototype.
Singleton is different: it controls *how many* instances exist, not which class.

## Decision table

| Symptom in the code or requirement | Pattern | Read |
|---|---|---|
| A base class/framework must create objects but only subclasses/plugins know the concrete type | Factory Method | [references/factory-method.md](references/factory-method.md) |
| Several related objects must always come from the same variant (e.g. all-Postgres, all-Mongo; dark theme widgets) and be swappable as a set | Abstract Factory | [references/abstract-factory.md](references/abstract-factory.md) |
| One object needs many steps/optional parts, or the same assembly steps must yield different representations | Builder | [references/builder.md](references/builder.md) |
| New objects are best made by copying a configured instance; classes are chosen at runtime; construction is costly | Prototype | [references/prototype.md](references/prototype.md) |
| Exactly one instance must exist and be reachable everywhere (config, registry, connection pool) | Singleton | [references/singleton.md](references/singleton.md) |
| Need the idiom in a specific language (Python, TS/JS, Java, C#, Go) | any | [references/language-mapping.md](references/language-mapping.md) |

Pattern selection tips (p. 135-136): start with Factory Method or a plain factory function; move to Abstract Factory, Prototype, or Builder only when you discover the extra flexibility is needed. Prototype beats a parallel hierarchy of factories/creators when products differ only by state.

## Workflow

Pick the mode that matches the request, then read only the needed reference files.

### Mode A - Detect in existing code
1. Grep for creation smells: `new ConcreteX(` outside a composition root, `switch`/`if` on a type string followed by instantiation, constructors with 5+ params or many `null`s, `static instance`/module globals, copy-paste "create similar object" code.
2. For each hit, name the variation point: what varies (class, family, assembly steps, state, count)? Use the decision table.
3. Report location, smell, candidate pattern, and the cheaper alternative from the reference's "Don't use when" section. Report "no pattern needed" when nothing varies.

### Mode B - Refactor toward a pattern
1. Confirm the variation is real (two or more concrete variants exist or are imminent). If not, stop and say so.
2. Pin behavior with tests before touching creation code.
3. Introduce the smallest form first: factory function -> parameterized factory -> full class hierarchy. Check the language's collapse in `language-mapping.md`.
4. Move all `new` calls for that variation behind the creator; leave one place (composition root) that picks the concrete variant.
5. Re-run tests; delete the old branching code.

### Mode C - Design new
1. List what must vary and what must stay fixed; write the client's call site first.
2. Choose via the decision table; prefer the language-native idiom (function, dict of callables, keyword args, module, DI container).
3. Sketch participants from the reference file, implement the minimal version, and add a test using a fake product to prove the client is decoupled.

## Warnings against over-use
- Do not add a factory for a class that never varies; a constructor call is the simplest factory.
- Do not build an Abstract Factory with one family; do not build a Builder for an object with 3 fields (use keyword/named args or a literal).
- Singleton is global state in disguise: it hurts tests and hides dependencies. Prefer passing the one instance in (dependency injection) or a module-level object; keep a true Singleton only when the uniqueness is a hard invariant.
- Prototype is only worth it if copying is simpler than constructing; deep-vs-shallow copy bugs are common.
- Patterns multiply classes. If the language has first-class functions or classes, a function or dict usually replaces the hierarchy.
- Name the pattern in code only when it helps readers; do not rename working code to fit pattern vocabulary.

## Source
Gamma, Helm, Johnson, Vlissides, *Design Patterns* (1995), ch. 3 "Creational Patterns", p. 81-136. Reference files paraphrase the book and give original examples.
