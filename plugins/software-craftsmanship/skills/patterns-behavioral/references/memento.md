# Memento

**Intent.** Capture an object's internal state in an opaque snapshot, without breaking encapsulation, so it can be restored later.

## Use when (code signals)
- Undo/rollback, checkpoints, "cancel" in dialogs, save-game, try-and-revert experiments.
- Code reaches into private fields to copy them elsewhere, or a command stores half an object's internals to undo.
- Iteration state or transaction state must be resumable.

## Don't use when
- Objects are large and snapshots are frequent: store diffs/deltas, use persistent (immutable) data structures, or event sourcing.
- State is already immutable: keeping the old reference IS the snapshot.
- A reversible operation (inverse command) is cheap and exact.

## Participants & structure
Originator (creates a memento of itself, restores from one) ; Memento (opaque state holder; only the originator can read it) ; Caretaker (stores mementos, never inspects them).
```
caretaker: m = originator.save(); ... ; originator.restore(m)
```

## Consequences
+ Encapsulation is preserved; originator is simplified (no history management inside).
- Can be expensive in memory/copy time; caretakers may not know the cost.
- Narrow vs wide interface: the caretaker sees none, the originator sees all; hard to enforce in some languages.
- Caretaker may hold dangling mementos forever; set limits.

## Implementation tips
- Store incremental changes if the same state is saved repeatedly (pair with Command).
- Cap history size; drop the oldest.
- Make mementos immutable and deep-copy mutable members.
- Version the format if mementos are persisted.

## Language mapping
- Python: `copy.deepcopy`, frozen dataclass, `pickle`; JS/TS: `structuredClone`, immutable objects (Immer produces snapshots), Redux state history.
- Java: `record`/serialization; C#: records with `with`, struct copies. Go: value copies of structs (copy semantics make it trivial).
- Immutable data makes Memento disappear: keep the old value.

## Example (Python)
```python
from dataclasses import dataclass, replace
@dataclass(frozen=True)
class Doc:
    text: str = ""

class Editor:
    def __init__(self): self.doc, self._undo = Doc(), []
    def type(self, s): self._undo.append(self.doc); self.doc = replace(self.doc, text=self.doc.text + s)
    def undo(self): self.doc = self._undo.pop() if self._undo else self.doc
```

## Related
Command (undo history), Iterator (saves position), Prototype (alternative cloning).

## Source
Gamma et al., 1995, p. 283.
