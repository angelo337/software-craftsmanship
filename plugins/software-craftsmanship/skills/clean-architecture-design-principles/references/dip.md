# DIP: Dependency Inversion Principle

## Core statement
The most flexible systems have source dependencies that refer to abstractions, not concretions. High-level policy must not depend on low-level detail; details depend on policy. Control flow runs from policy to detail while the source dependency runs back, so the dependency is inverted. Stable concrete facilities (language standard types, platform services) may be depended upon; avoid volatile ones that you are actively changing.

## Symptoms in code
- Business logic constructs `PostgresClient()`, `requests.post`, or UI widgets directly.
- Unit tests need a real database, network or clock.
- Swapping a vendor means editing core logic.
- Imports in domain modules point at infrastructure packages.
- Subclasses overriding concrete methods, inheriting hidden dependencies.

## How to fix
1. Identify the volatile detail the policy touches.
2. Define an abstraction in the policy's own module, phrased in the policy's language (not the vendor's).
3. Make the policy depend on that abstraction and receive an implementation (constructor/function argument).
4. Implement the abstraction in the detail module.
5. Rules of thumb: do not reference volatile concrete classes; do not inherit from them; do not override concrete functions (make them abstract and add implementations); never name concrete volatile things in policy code.
6. Creation needs care, since instantiating needs the concrete name: use an abstract factory, or construct in the composition root.
7. Gather the unavoidable concrete wiring in a few concrete components, usually `main`.

```python
class OrderStore(Protocol):
    def save(self, order) -> None: ...

class PlaceOrder:                      # policy
    def __init__(self, store: OrderStore): self.store = store
    def run(self, order): self.store.save(order)

class SqlOrderStore:                   # detail
    def save(self, order): ...

def main():                            # only place that knows both
    PlaceOrder(SqlOrderStore()).run(order)
```

## Language notes
- Java/C#/TS: interfaces and abstract classes; DI containers are optional tooling, not the principle.
- Python/JS: duck typing; a Protocol, callable argument or module-level injection point serves as the abstraction. "Concrete" means the module that implements the called functions.
- Constructor injection is the simplest mechanism; avoid global service locators that hide dependencies.

## Common over-application
- Interfaces for stable things (strings, collections, math) or classes with one implementation and no volatility.
- Abstractions shaped like the vendor API, so nothing is truly decoupled.
- Frameworks and containers adopted before need, making wiring harder to follow.
- Believing dependency injection equals inversion: injecting a concrete class still depends on it.

## Related principles
OCP (DIP supplies its mechanism), LSP (implementations must be substitutable), ISP (keep the abstraction narrow), SRP; at architecture level it grows into the Dependency Rule and plugin architecture.

## Source
Martin (2017), Ch. 11 (DIP); Ch. 5 (OO and dependency inversion).
