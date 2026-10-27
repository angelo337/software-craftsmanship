# LSP: Liskov Substitution Principle

## Core statement
Barbara Liskov (1988): if code written against type T behaves the same when given any subtype S, then S is a valid subtype. Plainly: implementations of a contract must be interchangeable, so callers never need to know which one they hold. In modern practice it covers class hierarchies, interfaces, duck-typed shapes and network services behind one API.

## Symptoms in code
- Callers test the concrete type (`isinstance`, `instanceof`, string prefix on a URL) before calling.
- Overrides that throw "not supported", return nothing, or silently ignore input.
- Subclass tightens preconditions or weakens guarantees.
- Special-case tables for one vendor/partner that deviates from the shared contract.
- Square-vs-rectangle: a subtype that couples properties the parent keeps independent, so a caller's assumptions fail.

## How to fix
1. Write down the contract: inputs accepted, outputs promised, invariants, errors.
2. Check each implementation: it may accept more and promise more, never less.
3. If a subtype cannot honor it, stop inheriting. Use composition, a separate sibling type, or a narrower interface.
4. For external services that deviate, put an adapter in front that normalizes them to the contract, instead of branching in callers.
5. Add a contract test suite that runs against every implementation.

```python
class Rect:
    def __init__(self, w, h): self.w, self.h = w, h
    def area(self): return self.w * self.h

class Square(Rect):           # breaks: callers set w and h separately
    def __init__(self, s): super().__init__(s, s)
    # Fix: make Shape.area() the contract and give Square its own side
class Shape(Protocol):
    def area(self) -> float: ...
```

## Language notes
- Python/JS cannot enforce contracts statically; use Protocols, abstract base classes and shared contract tests.
- TypeScript is structurally typed: matching shape does not prove matching behavior.
- Beware read-only versus mutable variants: immutability avoids the square/rectangle trap.

## Common over-application
- Banning all inheritance. LSP only asks that where you inherit, substitution holds.
- Treating the principle as only about classes and ignoring service and data-format contracts.
- Demanding identical performance or incidental behavior rather than the stated contract.

## Related principles
OCP (extensions rely on substitutability), ISP (narrow contracts are easier to honor), DIP (callers depend on the contract).

## Source
Martin (2017), Ch. 9 (LSP).
