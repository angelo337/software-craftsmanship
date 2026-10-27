---
name: patterns-structural
description: Apply, detect, refactor toward, or design with the 7 GoF structural patterns (Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy). Use whenever code has incompatible interfaces, wraps a legacy or third-party API or SDK, models trees or part-whole structures, needs behavior added without subclassing (logging, caching, retry, auth middleware), needs a simpler front for a messy subsystem, holds many near-identical objects that eat memory, or needs lazy loading, access control, remote stubs, or caching proxies. Also trigger on class explosions from two independent axes of variation. Triggers in Spanish - "patrón estructural", "patrones estructurales", "adaptador", "fachada", "decorador", "compuesto", "puente", "peso ligero", "envolver API", "interfaz incompatible". Use even if the user never names a pattern but describes one of these problems.
---

# Structural Design Patterns (GoF)

Structural patterns describe how classes and objects are assembled into larger structures. Most use composition (an object holds another object and forwards calls) rather than inheritance, so they look alike on a diagram. They differ in INTENT. Always decide by intent, never by shape.

Source: Gamma, Helm, Johnson, Vlissides, *Design Patterns* (1995), ch. 4, pp. 139-219. References here are paraphrased summaries.

## Decision table: pick by problem

| Problem you have | Pattern | Read |
|---|---|---|
| Existing class works but its interface is not the one my code expects | Adapter | references/adapter.md |
| Two independent dimensions of variation cause subclass explosion (shape x renderer, report x format) | Bridge | references/bridge.md |
| Part-whole tree; clients should treat one item and a group identically | Composite | references/composite.md |
| Add responsibilities to single objects at runtime, stackable, no subclass per combination | Decorator | references/decorator.md |
| Clients juggle many subsystem classes for one common task | Facade | references/facade.md |
| Huge number of similar objects; memory is the measured problem | Flyweight | references/flyweight.md |
| Control access to one object: lazy create, permission check, remote stub, cache, count | Proxy | references/proxy.md |

Cross-language cheat sheet (Python, TS/JS, Java, C#, Go): references/language-mapping.md.

## Telling the look-alikes apart

All of Adapter, Decorator, Proxy and Facade wrap something. Ask what happens to the interface and what the wrapper is for:

| Pattern | Interface vs wrapped object | Purpose |
|---|---|---|
| Adapter | DIFFERENT (converted to what the client expects) | Make existing pieces fit |
| Decorator | SAME | Add behavior; stackable; client cannot tell |
| Proxy | SAME (or a subset) | Control access; the real subject owns the core function |
| Facade | NEW, simpler, covers many objects | Simplify; subsystem stays reachable and does not know the facade |

More tie-breakers:
- Adapter vs Bridge: Adapter is applied after the fact to fix a mismatch; Bridge is chosen up front so abstraction and implementation evolve separately.
- Decorator vs Composite: Decorator wraps ONE child to embellish; Composite holds MANY children to represent a structure. They combine well.
- Decorator vs Strategy: Decorator changes the skin from outside; Strategy swaps the guts the object already exposes. Prefer Strategy when the component is heavy.
- Facade vs Mediator: Facade is one-way and adds no behavior; Mediator coordinates colleagues that know it.
- Flyweight often shares Composite leaves; leaves then cannot hold a parent pointer.

## Workflow

### Mode A: Detect in existing code
1. Grep for signals: classes named *Wrapper/*Adapter/*Proxy/*Facade/*Decorator; delegating methods that forward to a field; `isinstance`/type switches over "group vs single"; parallel subclass families (`PdfInvoice`, `HtmlInvoice`, `PdfReceipt`...); caches or lazy `if x is None` guards in front of another object.
2. For each candidate, state the intent in one sentence using the table above. If the shape matches but the intent differs, name it by intent.
3. Report: pattern, location, participants mapped to real classes, and whether it is applied cleanly or leaks (e.g. proxy that changes the interface, facade that hides the subsystem entirely).

### Mode B: Refactor toward a pattern
1. Name the concrete pain (duplicated adaptation code, subclass explosion, client knows 6 classes). No pain, no refactor.
2. Read the matching reference; check "Don't use when" first.
3. Add tests that pin current behavior, introduce the wrapper/interface, move one call site at a time, delete the old path.
4. Keep the diff minimal: extract the interface the client already uses, do not invent a wider one.

### Mode C: Design new
1. List the forces: what varies, what must stay stable, who owns the code on each side.
2. Start with the plain solution (function, parameter, language feature). Add a pattern only when a force demands it.
3. Read the reference, map participants to your domain names (not "Adapter1"), and write a short example or test first.

## Warnings against over-use
- One implementation, one caller: do not add Bridge, Adapter or an interface "for later".
- A Facade that merely renames one call is noise. A Facade that becomes a god class is a new problem; split by use case.
- Decorator chains of 5+ layers are hard to debug; consider an explicit pipeline.
- Flyweight without a profile showing memory pressure is premature optimization and breaks identity semantics.
- Proxy that silently hides network cost (remote call that looks local) causes latency and failure surprises; make failure modes visible.
- Composite with forced uniform `add/remove` on leaves trades type safety for transparency; decide deliberately.
- In Python/JS/Go the language often already gives the feature (functions, decorators, closures, duck typing, embedding). Prefer that; see language-mapping.md.

## When to read which reference
- Open the single reference for the pattern you shortlisted; read its "Use when" and "Don't use when" before coding.
- If two patterns are shortlisted, read both and compare with the table above.
- Open references/language-mapping.md when the target language is not Java/C#-style OOP, or when asked "how do I do this in Python/TS/Go?".
