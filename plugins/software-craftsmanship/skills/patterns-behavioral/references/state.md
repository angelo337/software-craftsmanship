# State

**Intent.** Let an object change its behavior when its internal state changes, as if it switched class.

## Use when (code signals)
- The same `switch(state)` / `if status == ...` repeats across many methods.
- Illegal transitions are guarded by scattered flags (`is_open`, `is_paid`, `is_shipped`).
- Protocols, workflows, order lifecycles, connections (TCP-style), game characters, UI modes.

## Don't use when
- Two or three states with trivial behavior: an enum and one switch is clearer.
- States differ only in data, not behavior: store a field.
- Transitions are many and data-driven (configurable workflows): use a transition table or a state-machine library.
- You are choosing an algorithm supplied by the caller: that is Strategy.

## Participants & structure
Context (holds current State, delegates requests) ; State (interface of state-specific methods) ; ConcreteStates (implement behavior for one state and usually choose the next state).
```
ctx.request() -> state.handle(ctx) -> ctx.set_state(Next)
```

## Consequences
+ Behavior per state is localized; state-specific code replaces big conditionals.
+ Transitions are explicit; illegal ones are hard to write.
+ State objects can be shared (flyweight/singleton) if they hold no per-context data.
- More classes, and logic spread across them.

## Implementation tips
- Decide who owns transitions: the states (flexible, couples them to each other) or the context/table (centralized, rigid).
- Create states lazily when they are rarely used or eagerly when transitions are frequent.
- Stateless states can be shared across contexts.
- Add a transition table to document and test the allowed moves.

## Language mapping
- Python: dict of state -> handler functions, `Enum` plus `match`, or classes. JS/TS: discriminated unions with `switch`; XState for complex machines.
- Java: `enum` with abstract methods (per-constant behavior), sealed interfaces. C#: `switch` expressions on records.
- Go: state as a func returning the next state (`type stateFn func() stateFn`).
- Rust-like typestate (separate types per state) is the compile-time form.

## Example (Python)
```python
class Door:
    def __init__(self): self.s = "closed"
    def push(self):
        self.s = {"closed": "open", "open": "open", "locked": "locked"}[self.s]
    def lock(self):
        if self.s == "closed": self.s = "locked"
        else: raise ValueError(f"cannot lock when {self.s}")
```
(Promote to State classes only when each state grows many methods.)

## Related
Strategy (same shape; State switches itself by lifecycle, Strategy is chosen by the client), Flyweight / Singleton (sharing states).

## Source
Gamma et al., 1995, p. 305.
