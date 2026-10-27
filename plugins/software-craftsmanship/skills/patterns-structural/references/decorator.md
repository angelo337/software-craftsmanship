# Decorator (Wrapper)

## Intent
Attach extra responsibilities to an individual object dynamically by wrapping it in an object with the same interface; a flexible alternative to subclassing for extending behavior.

## Use when
- You need optional, combinable add-ons (logging, metrics, retry, caching, compression, encryption, validation, rate limiting) around an existing component.
- Subclassing would require one class per combination (`BufferedCompressedEncryptedStream`...).
- Behavior should be added or removed per instance at runtime or from configuration.
- The class is final/closed, or you do not want to bloat it with features most users never need.
- Middleware chains, I/O stream wrappers, or function wrappers already appear in the code.

## Don't use when / cheaper alternative
- A fixed single extension: ordinary subclassing or a method.
- The extension needs the component's internals or a different interface: Adapter or modify the class.
- The component is heavyweight with many methods; each decorator must forward all of them. Use Strategy or hooks the component already exposes.
- The behavior is a cross-cutting concern the language already handles better (Python `@decorator`, framework middleware, AOP).
- Order-sensitive stacks that nobody can reason about: use an explicit, named pipeline.

## Participants & structure
Component (interface), ConcreteComponent (the base object), Decorator (holds a Component, implements the same interface, forwards by default), ConcreteDecorator (adds work before and/or after forwarding).

```
client -> DecoratorA -> DecoratorB -> ConcreteComponent
```
Because every layer conforms to Component, layers nest in any number.

## Consequences
- More flexible than static inheritance; add the same decorator twice if needed.
- Pay-as-you-go features; the base stays small.
- A decorated object is not identical to the original; do not depend on identity or concrete type checks.
- Many small look-alike objects; harder to debug and learn. Stack traces get deeper.
- Extra, order-dependent behavior (e.g. compress then encrypt, not the reverse).

## Implementation tips
- Keep the Component interface small; decorators must forward everything. Large interfaces make this tedious.
- Skip the abstract Decorator base when you only have one decorator.
- Component should define the interface, not hold data.
- Document composition order; test the combination, not only each decorator.
- Decorator may expose extra methods, but clients holding the base type cannot call them.
- Strategy changes "guts" (component knows the extension point); Decorator changes the "skin" (component is unaware).

## Language mapping
- Python: `@decorator` syntax wraps functions (`functools.wraps`, `functools.lru_cache`, `contextlib.contextmanager`); for objects, write a wrapper class or use `__getattr__` to forward. The pattern collapses into higher-order functions.
- TypeScript/JavaScript: function wrappers and middleware (Express/Koa/Redux `compose`); TS decorators on classes/methods (stage-3 syntax) for annotations; wrapper classes for objects.
- Java: `java.io` streams (`new BufferedInputStream(new GZIPInputStream(...))`), `Collections.unmodifiableList`; Spring/AOP annotations.
- C#: wrapper classes; ASP.NET Core middleware pipeline; DI libraries with `Decorate` (Scrutor).
- Go: wrap a function type or interface (`func(http.Handler) http.Handler` middleware); embed an interface in a struct to forward unchanged methods automatically.

## Example (Python)
```python
import time

def timed(fn):
    def wrapper(*a, **kw):
        t = time.perf_counter()
        try:
            return fn(*a, **kw)
        finally:
            print(fn.__name__, time.perf_counter() - t)
    return wrapper

@timed
def load(path): ...
```

## Related patterns
Adapter (changes interface). Proxy (same interface, controls access instead of adding features). Composite (many children vs one; often combined). Strategy (swap internals instead of wrapping). Chain of Responsibility (decorator-like chain where links may stop the request).

## Source
Gamma et al., 1995, Design Patterns, p. 175.
