# Language mapping cheat sheet

Rule of thumb: if the language has first-class functions, closures, generators, events and sum types, most of these patterns shrink to a language feature. Reach for the full class form only when you need state, undo, serialization or multiple operations on the same object.

| Pattern | Python | TS / JS | Java | C# | Go |
|---|---|---|---|---|---|
| Chain of Responsibility | list of funcs + loop; ASGI/WSGI middleware | Express/Koa `next()` middleware | `FilterChain`, Spring interceptors | ASP.NET middleware, `DelegatingHandler` | `func(http.Handler) http.Handler` |
| Command | closure / `partial`; class if undo | closure `() => ...`; object `{run, undo}` | `Runnable`, `Callable`; class for undo | `Action`, `ICommand` | `func()`; struct with `Do/Undo` |
| Interpreter | dataclasses + `match`; or use a parser lib | ADT + `switch`; compile to closures | sealed interface + records + switch | records + `switch`; `Expression<T>` | interface `Eval(env)`; type switch |
| Iterator | `__iter__`, generators | `Symbol.iterator`, `function*`, `for...of` | `Iterable`, `Stream` | `IEnumerable` + `yield return` | `iter.Seq`, range-over-func |
| Mediator | controller/event bus object | parent component, store (Redux, Pinia) | Spring events, mediator service | MediatR | goroutine owning state + channels |
| Memento | frozen dataclass, `deepcopy` | `structuredClone`, immutable state (Immer) | records, serialization | records `with`, struct copy | value copy of struct |
| Observer | callbacks, blinker, signals | `EventTarget`, RxJS, signals | `PropertyChangeListener`, Flow, Reactor | `event`, `IObservable<T>` | channels, `[]func(T)` |
| State | `Enum` + `match`, dict of handlers | union type + `switch`, XState | `enum` with abstract methods, sealed types | `switch` expressions | `stateFn` returning next state |
| Strategy | function arg / dict of funcs | function arg (`sort(cmp)`) | lambda / functional interface | `Func<>`, `IComparer` | `func` type or small interface |
| Template Method | higher-order fn; context manager | higher-order fn with callbacks | abstract class (`final` template) | `abstract`/`virtual` methods | funcs or step interface |
| Visitor | `singledispatch`, `match` | discriminated union + exhaustive `switch` | sealed + pattern `switch` (21+) | `switch` expr, `dynamic` | type switch |

## Quick calls
- Strategy, Command, Template Method, and Observer callbacks: all "pass a function" first.
- Iterator: never hand-roll when a generator or built-in `for` works.
- Visitor: prefer sum types + exhaustive matching when the language offers them; keep classic double dispatch for open hierarchies you cannot modify.
- State: an enum + one `match` beats five classes until behavior per state is large.
- Memento: immutable data turns it into "keep the old value".
