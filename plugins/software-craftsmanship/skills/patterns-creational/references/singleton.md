# Singleton (Object Creational)

## Intent
Guarantee a class has exactly one instance and give a well-known point of access to it.

## Use when (code signals)
- A real-world invariant demands one instance: one spooler, one window manager, one hardware driver handle, one process-wide registry.
- Multiple instances would corrupt state or double-use a scarce resource (connection pool, file lock).
- Today the code uses a global variable or scattered `static` state to share that object, and creation order matters.
- The sole instance may need to be a subclass chosen at startup (configuration-driven).

## Don't use when / cheaper alternative
- You only want convenient access: that is a global in disguise. It hides dependencies, couples callers, and makes tests share state.
- Tests need fresh or fake instances.
- Multi-threaded or multi-process code, where "one" is ambiguous (per thread? per process? per node?).
- Cheaper: create the object once at startup (composition root) and pass it in (dependency injection); a module-level instance; a DI container singleton scope.

## Participants & structure
- Singleton: holds its sole instance, hides/guards the constructor, exposes an `instance()` accessor that creates it on first use (lazy) or returns it.
- Clients: reach it only through that accessor.

```
Singleton
  - _instance (class-level)
  + instance() -> creates on first call, returns the same object after
  - constructor not publicly callable
```

## Consequences
Benefits:
- Controlled access to the sole instance.
- Fewer global names than raw global variables.
- Subclassing and run-time configuration of which instance is used are possible.
- Easy to relax later to N instances: only the accessor changes.
- More flexible than a class full of static methods, which cannot be overridden polymorphically or turned into several instances.
Liabilities (from experience beyond the book's list):
- Global mutable state, hidden coupling, order-of-initialization surprises, hard to isolate in tests, thread-safety obligations.

## Implementation tips
- Make the constructor non-public (or detect re-entry) so only the accessor creates the object.
- Lazy creation avoids building unused singletons and lets you use values only known at runtime; plain static initialization lacks ordering guarantees across modules and forces creation of every singleton.
- Make lazy creation thread-safe (lock, language-provided static initialization, or `sync.Once`-style helpers).
- To support subclasses, decide the subclass inside the accessor (e.g. from an environment/config value), or use a name -> instance registry so the accessor need not know every subclass.
- Provide a reset/replace hook for tests, or better, avoid the global and inject.
- Keep the singleton stateless or immutable where possible.

## Language mapping
- Python: module-level object (modules are loaded once); `functools.cache` on a getter; avoid `__new__` tricks unless required.
- TypeScript/JavaScript: export a constant instance from an ES module; class with static `getInstance()` is rarely needed.
- Java: enum singleton, or holder-class idiom; with Spring/Guice use singleton scope and inject.
- C#: `Lazy<T>` or static readonly field; DI `AddSingleton<T>()`.
- Go: package-level variable guarded by `sync.Once`; or construct in `main` and pass explicitly.
See [language-mapping.md](language-mapping.md).

## Short example (Python)
```python
# settings.py -- the module IS the singleton
class _Settings:
    def __init__(self): self.debug = False

settings = _Settings()          # created once on first import

# elsewhere:  from settings import settings
# tests:      pass a fake _Settings() into functions instead of importing the global
```

## Related patterns
- Abstract Factory, Builder, and Prototype can each be implemented as singletons (a concrete factory is typically a single instance).
- Facade objects and State objects are also commonly single instances (see their chapters).

## Source
Gamma et al., 1995, Design Patterns, p. 127-134 (Related Patterns p. 134).
