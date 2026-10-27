# ISP: Interface Segregation Principle

## Core statement
Do not force a client to depend on operations it does not use. Split broad interfaces into narrow ones tailored to client groups. The root concern is wider than syntax: depending on something carrying baggage you do not need invites unexpected breakage, at class level and at framework/system level.

## Symptoms in code
- A client imports a big class but calls two methods.
- Changes to unrelated methods force rebuilds, retests or redeploys of unrelated clients.
- Test doubles must stub many irrelevant methods.
- Implementations with empty or "not supported" methods.
- A framework drags in a database or subsystem you never use; its failures reach you.

## How to fix
1. For each client, list the operations it truly calls.
2. Cluster clients with identical needs.
3. Define one small interface per cluster (role interfaces), named by the client's need.
4. Let the large class implement all of them; clients receive only their narrow type.
5. At system level, prefer dependencies without unneeded baggage, or wrap the heavy dependency behind your own narrow port.

```typescript
interface Reader { get(id: string): Promise<Doc> }
interface Writer { put(d: Doc): Promise<void> }

class DocStore implements Reader, Writer { /* ... */ }

function showDoc(r: Reader, id: string) { return r.get(id); }  // can't write
```

## Language notes
- Statically typed: the declarations create real compile-time and deploy-time coupling, so the principle bites hardest.
- Python/JS: no declaration coupling, so use `Protocol`/small types for documentation and tests, and still avoid depending on heavy modules.
- Go-style small, client-defined interfaces are a natural fit.

## Common over-application
- One interface per method, exploding the type count.
- Segregating before there are distinct clients.
- Ignoring cohesion: methods always used together belong together.

## Related principles
SRP (a class serving one actor is easier to segregate), LSP (narrow contracts are easier to satisfy), DIP (clients own the narrow abstraction), Common Reuse Principle at component level.

## Source
Martin (2017), Ch. 10 (ISP).
