# Prototype (Object Creational)

## Intent
Create new objects by copying a configured example instance (the prototype) instead of instantiating a class by name.

## Use when (code signals)
- Many subclasses differ only in initial state (WholeNote vs HalfNote, "admin" vs "guest" templates); a configured instance would replace the subclasses.
- The class to instantiate is decided at runtime (plugins, user-defined templates, dynamic loading).
- A parallel hierarchy of factories/creators mirrors the product hierarchy.
- Building an object is expensive (parsing, I/O, heavy setup) and variants are small tweaks of one baseline.
- A "duplicate" or "save as template" feature is needed anyway.

## Don't use when / cheaper alternative
- Objects have circular references, external handles (sockets, files, locks), or identity that cannot be copied safely.
- Construction is cheap and clear: just construct.
- Existing classes lack copy support and adding it is hard.
- Cheaper: a factory function with parameters; `dataclasses.replace`, spread/`structuredClone`, `with`-expressions on immutable records; defaults dict merged with overrides.

## Participants & structure
- Prototype: interface declaring `clone()`.
- ConcretePrototype: implements `clone()` by copying itself.
- Client: asks a prototype to clone itself instead of using `new`.
- Optional prototype manager (registry): key -> prototype, with register/unregister/lookup; clients can browse and extend it at runtime.

```
Client --> registry["quarter_note"].clone() --> new object (then tweak state)
```

## Consequences
Benefits:
- Hides concrete classes from the client, like the other creational patterns.
- Products can be added or removed at runtime by registering instances.
- New "kinds" come from varying values or structure (composites) with no new classes.
- Fewer classes; no creator hierarchy needed.
Liabilities:
- Every prototype class must implement clone correctly, hard for classes with unclonable internals or cycles.
- Clones often need re-initialization, which a uniform clone signature cannot take as arguments.

## Implementation tips
- Decide shallow vs deep copy explicitly. Shared mutable fields (lists, dicts, child objects) cause aliasing bugs; deep copy when the clone must be independent.
- Cycles: use a copy that tracks visited objects (Python `deepcopy` memo does).
- A serialize-then-deserialize round trip is a quick default clone if the object supports it.
- Keep `clone()` argument-free so the interface is uniform; add a separate `initialize(...)`/setters (or `replace(**changes)`) for per-clone state.
- Clone must return the same concrete type as the original so callers never downcast.
- Keep a registry only when the set of prototypes changes at runtime.
- Languages whose classes are first-class objects get less benefit: the class itself acts as a prototype/factory.

## Language mapping
- Python: `copy.copy`/`copy.deepcopy`, `dataclasses.replace`; registry is a dict.
- TypeScript/JavaScript: `structuredClone`, object spread (shallow), `Object.create(proto)` (true prototype delegation); class instances need a `clone()`.
- Java: `Cloneable` is awkward; prefer copy constructors/copy factories or records with `with`-style methods.
- C#: copy constructor, `MemberwiseClone` (shallow) + manual deep, records with `with` expressions.
- Go: struct assignment copies by value (shallow for pointers/slices/maps); write a `Clone()` for deep.
See [language-mapping.md](language-mapping.md).

## Short example (Python)
```python
import copy

class Shape:
    def __init__(self, kind, style): self.kind, self.style = kind, dict(style)

registry = {                              # prototype manager
    "red_box": Shape("box", {"fill": "red", "w": 10}),
}

def make(key, **overrides):
    s = copy.deepcopy(registry[key])      # independent clone
    s.style.update(overrides)             # per-clone tweaks
    return s
```

## Related patterns
- Abstract Factory: competing option; a factory can hold prototypes and clone them.
- Factory Method: needs a creator subclass per product; Prototype needs clone support instead.
- Composite and Decorator: designs using them often benefit from Prototype.

## Source
Gamma et al., 1995, Design Patterns, p. 117-126 (Related Patterns p. 126; discussion p. 135-136).
