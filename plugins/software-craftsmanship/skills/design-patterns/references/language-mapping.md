# Language mapping

Classic GoF examples assume class-based languages of the 1990s. In modern languages, many patterns shrink to a language feature. Prefer the idiomatic form.

| Pattern | Python | TypeScript / JavaScript | Java / C# | Go |
|---|---|---|---|---|
| Abstract Factory | module/class returning a set of factories, or a dict of callables | object of factory functions | interface + implementations, or DI container | interface with constructors |
| Builder | keyword args, dataclass, `replace()` | options object, fluent class for validation-heavy cases | fluent builder / records with wither | functional options |
| Factory Method | factory function, `classmethod` | factory function | static factory, overridable method | constructor function `NewX` |
| Prototype | `copy.deepcopy`, `dataclasses.replace` | `structuredClone`, spread | copy constructor, `clone` avoided | struct copy |
| Singleton | module-level instance; DI | module-level export; DI | DI container singleton scope | package-level var with `sync.Once` |
| Adapter | wrapper class or function | wrapper | wrapper class | small interface + wrapper struct |
| Bridge | composition + protocol | composition + interface | abstraction holds implementor interface | interface field |
| Composite | recursive class with shared interface | same | same | interface with slices of children |
| Decorator | `@decorator`, wrapper class | higher-order function, wrapper | wrapper, annotations/aspects | middleware wrapper |
| Facade | module or class exposing a few functions | module | service class | package-level API |
| Flyweight | `lru_cache`, interning, `__slots__` | cache map | cache/pool | map + immutable struct |
| Proxy | wrapper, `__getattr__` | `Proxy` object | dynamic proxy, wrapper | wrapper struct |
| Chain of Responsibility | list of callables | middleware array | handler list | middleware slice |
| Command | closure / callable object | closure | functional interface / class | func value |
| Interpreter | small parser or `ast`; usually use a library | same | same | same |
| Iterator | generators, `__iter__` | `Symbol.iterator`, generators | `Iterable`/`IEnumerable` | channels/iterators (1.23+) |
| Mediator | event bus or coordinator class | same | same | coordinator struct |
| Memento | dataclass snapshot | plain object snapshot | immutable record snapshot | struct copy |
| Observer | callbacks, signals | EventEmitter, RxJS, DOM events | events/listeners, reactive streams | channels, callbacks |
| State | state classes or enum + dispatch dict | same, or discriminated union | state classes, enum with behavior | func-per-state |
| Strategy | pass a function | pass a function | functional interface / strategy class | func or interface |
| Template Method | higher-order function or hook methods | same | abstract class with hooks | embedded struct / func params |
| Visitor | `functools.singledispatch`, `match` | discriminated unions + `switch` | pattern matching on sealed types | type switch |

Rule: if the pattern collapses to a function or built-in, say so and write that; keep the pattern's name as vocabulary.
