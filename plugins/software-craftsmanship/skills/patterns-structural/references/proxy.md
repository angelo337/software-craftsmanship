# Proxy (Surrogate)

## Intent
Provide a stand-in with the same interface as another object in order to control access to it: create it lazily, guard it, represent it remotely, or add bookkeeping on access.

## Use when
- Lazy loading: expensive object (large file, DB entity, ML model) should be built only when first used (virtual proxy).
- Access control: check permissions or rate limits before delegating (protection proxy).
- Remote object: local stub that hides serialization and transport (remote proxy: RPC/gRPC/REST clients).
- Smart reference: caching, reference counting, locking, auditing, lazy ORM relations, copy-on-write.
- Callers must not change; the substitute has to look exactly like the real thing.

## Don't use when / cheaper alternative
- You are adding features to the object's behavior: Decorator.
- You need a different interface: Adapter.
- A lazy value or cache suffices: `functools.cached_property`, `lru_cache`, `Lazy<T>`, `sync.Once`, memoization.
- Permission checks belong at one boundary (controller/middleware), not on every object.
- Hiding a network call so it looks local invites latency and failure surprises; prefer an explicit async client when failures matter.

## Participants & structure
Subject (interface shared by real object and proxy), RealSubject (does the work), Proxy (same interface; holds or can obtain the RealSubject; decides when and whether to forward).

```
Client --> Subject <|-- RealSubject
                   <|-- Proxy --refers to--> RealSubject
```
Kinds: remote (reference is an address, not an object), virtual (starts with a cheap reference such as a filename, later a direct one), protection (checks rights), smart reference (extra housekeeping per access).

## Consequences
- Adds a level of indirection that can hide distribution, creation cost, or access policy from clients.
- Can serve cheap queries from cached metadata (size, id) without creating the real object.
- Copy-on-write: share until first write, then copy.
- Extra latency, more classes, and subtle behavior differences (identity, exceptions, thread safety).
- Proxy and subject are not the same object; identity comparisons break.

## Implementation tips
- Keep the proxy's interface identical to the subject; a protection proxy may expose a subset by refusing calls.
- If the proxy talks to the subject only via the interface, one proxy class can serve many subjects.
- Trigger creation on the specific operations that need it, not on every reference.
- Be explicit about errors and timeouts for remote proxies; make thread-safety a conscious choice for lazy init.
- Automatic forwarding hooks (dynamic proxies, `__getattr__`, JS `Proxy`) save boilerplate but lose type safety and make identity and special methods tricky.

## Language mapping
- Python: wrapper class with `__getattr__` forwarding; `functools.cached_property`/`lru_cache` cover many virtual/caching cases; `unittest.mock`, `weakref.proxy`, ORMs (lazy relations) use the idea.
- TypeScript/JavaScript: built-in `Proxy` with `get`/`set` traps for lazy, validating, or observable objects (Vue reactivity); wrapper classes for typed APIs.
- Java: `java.lang.reflect.Proxy` and CGLIB; Hibernate lazy entities, Spring AOP `@Transactional`/`@Cacheable` proxies; RMI stubs.
- C#: `DispatchProxy`, Castle DynamicProxy, `Lazy<T>`; WCF/gRPC generated clients; EF Core lazy-loading proxies.
- Go: struct implementing the same interface and holding the real one; `sync.Once` for lazy init; generated gRPC client stubs are remote proxies; no runtime dynamic proxy, so code generation is common.

## Example (Python)
```python
class LazyReport:
    def __init__(self, path): self._path, self._real = path, None
    def _load(self):
        if self._real is None: self._real = Report.from_file(self._path)
        return self._real
    def title(self): return self._path.stem          # cheap, no load
    def render(self): return self._load().render()   # loads on demand
```

## Related patterns
Adapter (different interface). Decorator (same shape, adds responsibilities; a protection proxy can look identical). Facade (new interface over many objects). Flyweight (shared pool vs per-subject stand-in).

## Source
Gamma et al., 1995, Design Patterns, p. 207.
