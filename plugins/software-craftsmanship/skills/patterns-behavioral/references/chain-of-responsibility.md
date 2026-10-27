# Chain of Responsibility

**Intent.** Let several objects get a chance to handle a request, linked in a chain, so the sender does not need to know which one will act. The request travels until someone takes it.

## Use when (code signals)
- A long `if/elif` ladder where each branch tests "can I handle this?" and the order matters (auth, validation, routing, discount rules, help lookup).
- The set or order of handlers must change at runtime or per configuration.
- Middleware / filter / interceptor stacks, event bubbling, escalation (support tier 1 -> 2 -> 3).

## Don't use when
- Exactly one handler is always right and known: call it directly or use a dict lookup.
- Every step must run (no early stop) and order is fixed: a plain list of functions is enough.
- A silent "nobody handled it" would be dangerous and you cannot add a default terminator.

## Participants & structure
Handler (interface + optional successor link) -> ConcreteHandlers. Client calls the first handler.
```
client -> [H1] -> [H2] -> [H3] -> (end: default or error)
```
Each handler either handles and stops, or forwards. Variant: handle AND forward (pipeline/middleware).

## Consequences
+ Sender and receiver are decoupled; each handler knows only its successor.
+ Responsibilities can be reordered or added at runtime.
- Delivery is not guaranteed: the request can fall off the end. Always add a terminal handler or explicit "unhandled" result.
- Hard to debug: log which handler took it.

## Implementation tips
- Decide stop-on-first-match versus pass-through up front; mixing them confuses readers.
- Represent requests as one object (or typed variants) so handlers can inspect them uniformly; a raw code number limits extensibility.
- Reuse existing parent links (e.g. a UI widget's parent) as the successor to avoid extra wiring.
- Guard against cycles in the chain.

## Language mapping
- Python/JS/TS: list of functions plus a loop, or `next()`-style middleware (Express, Koa, ASGI).
- Java: servlet `Filter`/`FilterChain`, Spring interceptors. C#: ASP.NET middleware `RequestDelegate`, `DelegatingHandler`.
- Go: `func(http.Handler) http.Handler` wrappers; slice of funcs.

## Example (Python)
```python
def run(chain, req):
    for h in chain:
        r = h(req)          # a handler returns None to pass
        if r is not None:
            return r
    raise LookupError("unhandled")

chain = [lambda r: "blocked" if r["ip"] in BAN else None,
         lambda r: "cached" if r["url"] in CACHE else None,
         lambda r: render(r)]
```

## Related
Composite (parent as successor), Command (requests as objects), Decorator (similar wrapping, but always forwards).

## Source
Gamma et al., 1995, p. 223.
