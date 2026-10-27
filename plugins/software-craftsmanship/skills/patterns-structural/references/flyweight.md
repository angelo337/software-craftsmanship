# Flyweight

## Intent
Share fine-grained objects so that very large numbers of them are affordable, by separating shared (intrinsic) state from per-use (extrinsic) state.

## Use when
- A profile shows millions of small objects dominating memory (glyphs, map tiles, particles, game units, sprites, cells, tokens, repeated strings or config records).
- Many instances differ in only a few fields and the rest are identical (same texture, font, type descriptor).
- The state that varies per use (position, owner, count) can be passed in or stored in compact arrays outside the object.
- Code does not rely on object identity (`is`/`==` meaning "this particular instance").

## Don't use when / cheaper alternative
- No measured memory problem: premature optimization with a complexity cost.
- Objects are mostly unique, or extrinsic state is as large as the objects were: no savings.
- Instances are mutable and need independent state: sharing causes bugs.
- Cheaper options first: interning (`sys.intern`, `String.intern`), enums/constants, struct-of-arrays or numpy columns, value types (C# `struct`, Go values), object pooling (different goal: reuse allocation, not share identity).

## Participants & structure
Flyweight (interface that accepts extrinsic state as parameters), ConcreteFlyweight (immutable, stores only intrinsic state), UnsharedConcreteFlyweight (optional non-shared nodes, e.g. rows holding shared glyphs), FlyweightFactory (pool; returns the existing instance or creates one), Client (computes or stores extrinsic state and passes it in).

```
Client --> FlyweightFactory --pool--> ConcreteFlyweight (shared)
Client passes extrinsic state (x, y, style) on every call
```

## Consequences
- Memory savings grow with sharing and with how much state is intrinsic; best when extrinsic state is computed, not stored.
- Run-time cost to find, pass, or compute extrinsic state.
- Shared nodes cannot hold a parent pointer; parent becomes extrinsic.
- Identity checks lie; shared objects must be immutable.
- Pool needs a lifetime policy (weak references, GC, or fixed small set).

## Implementation tips
- Decide intrinsic vs extrinsic by asking "does this value depend on where/when the object is used?" If yes, extrinsic.
- Store extrinsic data compactly in an external structure (runs of attributes, columnar arrays) rather than per object.
- Make flyweights immutable (frozen dataclass, `readonly`, final fields) and hashable so the factory key is simple.
- Force creation through the factory (private constructor, factory function).
- Use weak-valued maps if the pool could grow without bound.
- State and Strategy objects without per-context data are natural flyweights.

## Language mapping
- Python: `functools.lru_cache` or a dict on a factory function; `sys.intern` for strings; `__slots__` shrinks per-object cost; frozen dataclasses; small ints and interned strings are built-in flyweights.
- TypeScript/JavaScript: `Map` keyed by intrinsic value; `WeakRef`/`FinalizationRegistry` for pruning; typed arrays for extrinsic data; strings are already interned by engines.
- Java: `Integer.valueOf` cache, `String.intern`, enums; `WeakHashMap` for pools; records for immutable intrinsic data.
- C#: `string.Intern`, `struct` value types, `ConditionalWeakTable`; `ArrayPool` is pooling, not Flyweight.
- Go: share pointers to immutable structs from a `map[Key]*T` guarded by `sync.Map`/mutex; `unique.Handle` (Go 1.23) interns comparable values.

## Example (Python)
```python
from dataclasses import dataclass
from functools import lru_cache

@dataclass(frozen=True)
class TileType:                 # intrinsic: shared
    name: str
    sprite: bytes

@lru_cache(maxsize=None)
def tile_type(name): return TileType(name, open(f"{name}.png", "rb").read())

grid = [[tile_type("grass") for _ in range(1000)] for _ in range(1000)]  # 1 object
```

## Related patterns
Composite (shared leaf nodes form a DAG; parent must be extrinsic). State and Strategy (often best implemented as flyweights). Factory/Singleton (the pool). Proxy (also manages object access, but for one subject rather than shared pools).

## Source
Gamma et al., 1995, Design Patterns, p. 195.
