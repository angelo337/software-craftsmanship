# The three programming paradigms

## Core statement
Each paradigm removes a freedom rather than adding power:
- Structured programming restricts direct transfer of control (no unrestricted jumps; only sequence, selection, iteration).
- Object-oriented programming restricts indirect transfer of control (polymorphism replaces hand-rolled function pointers).
- Functional programming restricts assignment (values do not change after they are bound).
Together they map to architecture's concerns: algorithms/function, separation of components, and data management.

## Structured programming
- Why it matters: modules built from the three basic structures can be broken down recursively into small units. Formal proof of each unit never became practical, but small units can be falsified by tests. Tests show bugs, never their absence, so software behaves like a science: you gain confidence by failing to disprove.
- Symptoms of violation: functions with tangled early exits and flags, giant methods nobody can test, control flow you cannot decompose.
- Fix: split into small units with clear inputs/outputs; write tests that try to break each. At architecture level, keep functional decomposition and make components testable.

## Object-oriented programming
- Not "data plus functions", not "modeling the real world", and not defined by encapsulation or inheritance (older languages had both, and several OO languages enforce little encapsulation). The distinctive contribution is safe, convenient polymorphism.
- Consequence: dependency inversion. Normally source dependencies follow runtime calls. With an interface in between, the source dependency can point opposite to the call. Any dependency anywhere can be flipped.
- Payoff: business rules can sit at the center, with UI and database as plugins; components deploy and develop independently.
- Symptoms of violation: business logic importing the DB driver or web framework; changing the UI forces rebuilding the rules.
- Fix: place an interface, owned by the high-level side, between caller and detail.

```python
from typing import Protocol

class Notifier(Protocol):          # owned by policy side
    def send(self, to: str, text: str) -> None: ...

def close_invoice(inv, notifier: Notifier):  # policy: no SMTP import
    inv.closed = True
    notifier.send(inv.owner, "Invoice closed")

class SmtpNotifier:                # detail: plugin
    def send(self, to, text): ...  # talks to the mail server
```

## Functional programming
- Races, deadlocks and concurrent-update bugs all need mutable state. No mutation, no such bugs.
- Pragmatic stance: split the system into an immutable core and a small mutable part guarded by transactional-style mechanisms (compare-and-swap, transactions). Push as much logic as possible into the immutable side.
- Event sourcing extends this: store the events, derive state, snapshot occasionally. Append-only means no update conflicts, at the price of storage and recomputation.
- Symptoms: shared mutable globals, locks everywhere, state-dependent bugs.

```typescript
type Account = { readonly id: string; readonly events: readonly number[] };
const deposit = (a: Account, amt: number): Account =>
  ({ ...a, events: [...a.events, amt] });      // new value, no mutation
const balance = (a: Account) => a.events.reduce((s, x) => s + x, 0);
```

## Language notes
- Python/JS: everything is mutable by default; use `frozen=True` dataclasses, `Object.freeze`, `readonly`, tuples.
- Static languages enforce interface relationships at compile time; dynamic languages use duck typing, so a "Protocol" or doc convention plays the interface role.

## Common over-application
- Pursuing formal proofs or total purity instead of tests and pragmatic isolation of state.
- Copying every value on hot paths without measuring.
- Interfaces everywhere "because OO"; invert only where it buys independence.

## Related principles
DIP (uses OO polymorphism), OCP (needs it), SRP (small testable units), plugin architecture.

## Source
Martin (2017), Ch. 3 (Paradigm Overview), Ch. 4 (Structured Programming), Ch. 5 (Object-Oriented Programming), Ch. 6 (Functional Programming).
