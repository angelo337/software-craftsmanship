# Facade

## Intent
Offer one simple, higher-level interface to a set of classes in a subsystem, so the subsystem is easier to use and clients depend on less.

## Use when
- Every caller repeats the same 5-10 line recipe across several classes (create parser, scanner, builder, emitter...) to do one common task.
- Clients import many internal modules of a package; changes inside ripple outward.
- You want a defined entry point per layer or module (modular monolith boundary, SDK "client" class).
- You are wrapping a messy legacy subsystem or a multi-step third-party workflow behind a task-oriented API (`deploy(app)`, `convert(file, fmt)`).
- You want to swap the whole subsystem implementation later.

## Don't use when / cheaper alternative
- A single class already has a clear API: nothing to simplify.
- Callers need fine control on every call: the facade becomes a leaky pass-through.
- A convenience function in the module would do; not every helper needs a class.
- You must change an existing interface to match another: Adapter.
- Behavior must be coordinated among peers that know each other: Mediator.
- Beware the god-facade that grows every method of the subsystem; split by use case.

## Participants & structure
Facade (knows which subsystem objects handle each request and delegates), Subsystem classes (do the work; do not know the facade; not hidden from advanced clients).

```
Client --> Facade --> A, B, C, D (subsystem)
Advanced client --------> B (still possible)
```

## Consequences
- Fewer objects for clients to learn; weaker coupling between client and subsystem; supports layering and easier porting.
- Does not forbid direct use of subsystem classes, so you can trade simplicity for flexibility.
- Risk of becoming a coupling hotspot or a god class.
- Does not add new behavior; if it does, it is more than a facade.

## Implementation tips
- Make the facade express tasks in client vocabulary, not a 1:1 copy of subsystem methods.
- To reduce coupling more, give the facade an interface (abstract class/protocol) with swappable implementations, or inject the subsystem objects.
- Use language visibility to separate public from internal subsystem classes (package-private, `internal`, `_private` modules, Go `internal/`).
- One instance is typically enough; usually no Singleton needed, just construct once and inject.
- Keep subsystem classes ignorant of the facade, or you get cycles.

## Language mapping
- Python: a module with a few public functions or a small class; `__all__` and underscore-prefixed modules mark internals. Many "clients" (`requests.get`) are facades.
- TypeScript/JavaScript: an `index.ts` re-exporting a narrow API plus a service class; barrel files are only a re-export, not a facade by themselves.
- Java: service class in a package exposing public methods while the rest is package-private; Spring `@Service` application services; JPA `EntityManager`.
- C#: `internal` classes plus one public service; NuGet SDK client classes.
- Go: package exposes few exported identifiers; `internal/` directories restrict imports; package-level constructor `New()` returns the facade struct.

## Example (Python)
```python
class Converter:                        # facade
    def __init__(self, decoder, encoder, store):
        self._d, self._e, self._s = decoder, encoder, store
    def convert(self, src, fmt):
        raw = self._d.decode(self._s.read(src))
        return self._s.write(src, self._e.encode(raw, fmt))
```

## Related patterns
Abstract Factory (create subsystem objects behind the facade, or hide platform classes instead). Mediator (two-way coordination, colleagues know it; facade is one-way and adds nothing). Adapter (fit an existing interface vs define a new one). Singleton (single facade instance).

## Source
Gamma et al., 1995, Design Patterns, p. 185.
