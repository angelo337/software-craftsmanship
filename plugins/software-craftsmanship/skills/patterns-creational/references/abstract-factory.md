# Abstract Factory (Object Creational)

## Intent
Offer one interface for creating a whole family of related objects, so the client never names the concrete classes. Swapping the factory swaps the entire family at once. Also known as Kit.

## Use when (code signals)
- The same `if backend == "x"` branch repeats across many places, each instantiating a different class of the same variant (`PgConnection`, `PgCursor`, `PgMigrator`).
- Products must be mutually compatible (all widgets from one theme, all clients from one cloud vendor) and mixing variants is a bug.
- You ship a library and want to expose only interfaces, hiding implementation classes.
- Tests need a whole fake family (in-memory repo + in-memory queue + fake clock).

## Don't use when / cheaper alternative
- Only one product type varies: use Factory Method or a plain factory function.
- Only one family exists and no second is planned: call constructors directly.
- Product kinds change often: every new kind forces edits to the factory interface and every concrete factory.
- Cheaper: a single dict/record of callables, or a config object holding the few collaborators.

## Participants & structure
- AbstractFactory: declares one create-operation per product kind.
- ConcreteFactory: implements them for one family (one subclass per family).
- AbstractProduct: interface per product kind.
- ConcreteProduct: family-specific implementation, made only by its factory.
- Client: depends on the abstract factory and abstract products only.

```
Client --> AbstractFactory --creates--> AbstractProductA, AbstractProductB
              ^                              ^                ^
        ConcreteFactory1 ----creates--> ProductA1        ProductB1
        ConcreteFactory2 ----creates--> ProductA2        ProductB2
```
Usually one concrete factory instance exists at runtime, chosen once at startup (composition root). Creation is deferred to the concrete factory.

## Consequences
Benefits:
- Concrete class names stay inside the factories, out of client code.
- Switching families is a one-line change where the factory is instantiated.
- Enforces consistency: a client can only get products from one family at a time.
Liabilities:
- Adding a new product kind means changing the abstract interface and all concrete factories.
- Many small classes/interfaces for modest benefit.
- Returned products have only the abstract type; subclass-specific features need casts or are unreachable.

## Implementation tips
- Implement each creation operation as a Factory Method; this is the most common form.
- If families are many and differ slightly, build the factory from prototypes (store one instance per product, clone on request) or store classes in a dict, so you avoid one subclass per family.
- Make the concrete factory a single shared instance (see Singleton, but prefer injecting it).
- A single parameterized `make(kind)` is more extensible but loses static type safety; use it only in dynamic languages or when kinds are open-ended.
- A concrete (non-abstract) base factory with default products lets subclasses override only what differs.
- Pass the factory into the code that builds objects; never let that code import concrete classes.

## Language mapping
- Python: a class with methods, a dataclass of callables, or a dict `{"button": DarkButton, ...}`; duck typing removes the abstract products.
- TypeScript/JavaScript: an object literal / interface of factory functions per family; `const themes = { dark: {...}, light: {...} }`.
- Java: interface + implementing classes (classic); Spring/Guice often supply the family via profiles/modules.
- C#: interface + DI container registering one family per environment.
- Go: an interface with `NewX()` methods, or a struct of function fields; return interfaces from the constructors.
See [language-mapping.md](language-mapping.md).

## Short example (Python)
```python
from dataclasses import dataclass
from typing import Callable

@dataclass(frozen=True)
class StorageKit:                      # the "abstract factory": one slot per product
    make_repo: Callable[[], object]
    make_queue: Callable[[], object]

prod = StorageKit(PgRepo, SqsQueue)    # one family
test = StorageKit(MemRepo, MemQueue)   # another family

def build_service(kit: StorageKit):    # client never names concrete classes
    return Service(kit.make_repo(), kit.make_queue())
```

## Related patterns
- Factory Method: usually how each creation operation is realized.
- Prototype: alternative way to implement the factory (clone stored instances).
- Singleton: a concrete factory is often a single instance.
- Builder: also makes complex objects, but step by step and returns the product at the end; Abstract Factory returns each product immediately and emphasizes families.

## Source
Gamma et al., 1995, Design Patterns, p. 87-96 (Related Patterns p. 96; comparison p. 135-136).
