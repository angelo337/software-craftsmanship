# Language mapping cheat sheet - creational patterns

Rule of thumb: first-class functions and classes collapse most of these patterns into a function, a dict, or a keyword argument. Reach for the full class structure only when you also need its extra guarantees (type checks, plugin boundary, lifecycle).

| Pattern | Python | TypeScript / JavaScript | Java | C# | Go |
|---|---|---|---|---|---|
| Factory Method | Function, `@classmethod`, or pass the class; `dict[str, type]` registry | Function returning object; `Map<string, () => T>` | Overridable method, static factory (`List.of`), `Supplier<T>` | Virtual method, static factory, `Func<T>` | `NewX()` returning an interface; function-typed field |
| Abstract Factory | Dataclass/dict of callables per family; duck typing drops abstract products | Object literal per family (`themes.dark`) implementing one interface | Interface + impls; Spring profiles / Guice modules pick the family | Interface + DI registrations per environment | Interface with `NewX()` methods or struct of funcs |
| Builder | Keyword args + frozen dataclass; builder class only for staged/multi-format output | Options object with defaults; fluent class if validation is staged | Nested `Builder` + `build()`; Lombok `@Builder`; records | Object initializers, `init`/`required` properties; `StringBuilder`-style when staged | Functional options `New(opts ...Option)` or config struct |
| Prototype | `copy.copy` / `copy.deepcopy`, `dataclasses.replace` | `structuredClone`, spread (shallow), `Object.create` | Copy constructor / copy factory (avoid `Cloneable`); record `with`-methods | Copy constructor, `MemberwiseClone` + deep, record `with` | Struct value copy (shallow); write `Clone()` for deep |
| Singleton | Module-level object (preferred); `functools.cache` getter | ES module exporting one instance | Enum singleton, holder idiom, DI singleton scope | `Lazy<T>`, static readonly, `AddSingleton` | Package variable + `sync.Once`, or pass from `main` |

## Cross-cutting notes
- Dependency injection replaces most Singleton and many Factory uses: build once at the composition root, pass in.
- Deep vs shallow copy semantics differ per language; test that mutating a clone never alters the original (watch lists, maps, nested objects).
- Dynamic languages: a `make(kind)` function with a registry is the idiomatic parameterized factory; add `typing.Protocol` / TS interfaces for safety.
- Static languages: keep return types as interfaces so callers do not depend on concrete classes.
- Concurrency: lazy singletons and shared registries need thread-safe initialization in Java, C#, Go, and threaded Python.
- Immutability makes Builder products and shared prototypes safer.

## Quick picks
- "Which class?" -> factory function / Factory Method.
- "Which family?" -> Abstract Factory (dict or struct of callables).
- "Which assembly?" -> keyword/options args first, Builder if staged or multi-output.
- "Copy of this?" -> built-in copy first, Prototype registry if named templates.
- "Only one?" -> module-level or DI singleton before a Singleton class.

Source: pattern definitions from Gamma et al., 1995, p. 81-136; language idioms are modern practice, not from the book.
