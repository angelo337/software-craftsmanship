# Structural patterns: language cheat sheet

Rule of thumb: the more a language has first-class functions, duck typing and embedding, the more these patterns shrink to a function, a module, or a one-liner. Use the heavy class form only when you need state, multiple operations, or a typed contract.

| Pattern | Python | TypeScript / JavaScript | Java | C# | Go |
|---|---|---|---|---|---|
| Adapter | Small class or function; `Protocol` for the target; `functools.partial` for argument reshaping | Function `adapt(x): Target` or class implementing an interface | Class implements Target, holds Adaptee (`Arrays.asList`, `InputStreamReader`) | Class implementing interface; extension methods for convenience only | Consumer-side interface plus wrapper struct; function types with methods (`http.HandlerFunc`) |
| Bridge | Inject implementor in `__init__`; no formal interface needed | Constructor injection of an `interface` | Interface field, wired by constructor or DI | `IImpl` injected via DI container | Struct with interface field; variants are other structs |
| Composite | ABC/Protocol + container class; generators with `yield from` | Discriminated union + recursive function, or class tree (DOM) | Interface/abstract class; sealed interfaces + records | Interface with `IEnumerable` children (WPF controls) | Interface with `Children()`; recursive function |
| Decorator | `@decorator`, `functools.wraps`, `lru_cache`, context managers; wrapper class + `__getattr__` | Higher-order functions, middleware `compose`, TS `@decorator` (annotation use) | Wrapper classes (`java.io` streams), Spring AOP | Wrapper classes, ASP.NET middleware, Scrutor `Decorate` | `func(next Handler) Handler` middleware; embed interface to inherit unchanged methods |
| Facade | Module with few public functions or one class; `__all__`, `_private` | `index.ts` public API + service class | Package-private classes behind one public service | `internal` classes behind one public service | Package with few exported names; `internal/` dir |
| Flyweight | `lru_cache` factory, `sys.intern`, `__slots__`, frozen dataclass, numpy columns | `Map` pool, `WeakRef`, typed arrays | `Integer.valueOf`, `String.intern`, enums, `WeakHashMap` | `string.Intern`, `struct`, `ConditionalWeakTable` | `map[Key]*T` with mutex, `unique.Handle`, value structs |
| Proxy | Wrapper with `__getattr__`; `cached_property`; `weakref.proxy`; lazy ORM relations | Built-in `Proxy` (get/set traps), wrapper classes | `java.lang.reflect.Proxy`, CGLIB, Hibernate lazy, Spring AOP | `DispatchProxy`, Castle, `Lazy<T>`, EF lazy proxies | Same-interface struct, `sync.Once`; gRPC stubs by codegen |

## Where the language already does the work
- Python: decorators (Decorator), `lru_cache` (caching Proxy / Flyweight factory), `cached_property` (virtual Proxy), `__getattr__` (forwarding), modules (Facade), duck typing (Adapter often not needed).
- TypeScript/JavaScript: built-in `Proxy`, closures, middleware pipelines, spread/destructuring for shape conversion, ES modules as facades.
- Java: `java.io` decorators, dynamic proxies, `Collections.unmodifiable*` (protection proxy), `Executors` (facade), annotation-driven AOP.
- C#: `Lazy<T>`, `IEnumerable` composition, middleware, DI decoration, `struct` for cheap values.
- Go: implicit interfaces (declare at the consumer, so Adapter is usually just a thin struct), struct embedding (automatic forwarding for Decorator/Proxy), functional options, `sync.Once`, `internal/` packages.

## Pitfalls by language
- Python `__getattr__` proxies do not forward dunder methods (`len(proxy)`, `proxy[i]`); define them explicitly.
- JavaScript `Proxy` breaks `===` identity with the target and private fields (`#x`) on class instances.
- Java dynamic proxies need an interface; CGLIB needs a non-final class.
- Go embedding forwards methods but not overridden behavior of the embedded value's own callers (no virtual dispatch back to the wrapper).
- Any language: a decorator/proxy that changes exceptions or threading semantics is no longer transparent.

Pattern-by-pattern detail: see the other files in this folder. Source: Gamma et al., 1995, Design Patterns, ch. 4 (pp. 139-219).
