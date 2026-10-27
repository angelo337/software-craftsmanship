# Selection by problem

Start from the problem, not from the pattern name.

## Contents
- Creation
- Structure
- Behavior
- Commonly confused pairs

## Creation (skill: patterns-creational)
| Problem | Candidates |
|---|---|
| Code instantiates concrete classes directly and must not | Factory Method, Abstract Factory |
| Several products must be used together and kept consistent (a "family") | Abstract Factory |
| Object has many optional parts / constructor with a long parameter list | Builder |
| Creating is costly or the exact class is only known at runtime; clone a configured instance | Prototype |
| Exactly one shared instance is truly required | Singleton (prefer DI of a single instance) |

## Structure (skill: patterns-structural)
| Problem | Candidates |
|---|---|
| Reuse a class whose interface does not match | Adapter |
| Abstraction and implementation both need to vary (avoid class explosion) | Bridge |
| Tree of parts and wholes handled uniformly | Composite |
| Add responsibilities to single objects at runtime, combinable | Decorator |
| Complex subsystem needs a simple entry point | Facade |
| Huge numbers of similar fine-grained objects waste memory | Flyweight |
| Control access, lazy-load, cache, log or protect another object | Proxy |

## Behavior (skill: patterns-behavioral)
| Problem | Candidates |
|---|---|
| More than one handler may process a request; sender should not know which | Chain of Responsibility |
| Treat requests as objects: queue, log, undo | Command |
| Evaluate sentences of a small grammar | Interpreter |
| Traverse a collection without exposing its internals | Iterator |
| Many objects talk to many others in tangled ways | Mediator |
| Save and restore an object's state without breaking encapsulation | Memento |
| When one object changes, dependents must update automatically | Observer |
| Behavior depends on state, with large conditionals on state | State |
| Interchangeable algorithms chosen at runtime | Strategy |
| Fixed algorithm skeleton, some steps vary | Template Method |
| New operations over a stable object structure, without touching its classes | Visitor |

## Commonly confused pairs
- **Strategy vs State:** Strategy is chosen by the client and is usually stable; State changes itself as the object evolves and transitions are part of the design.
- **Decorator vs Proxy vs Adapter vs Facade:** Decorator adds behavior with the same interface; Proxy controls access with the same interface; Adapter changes the interface; Facade offers a simpler interface to many objects.
- **Abstract Factory vs Factory Method vs Builder:** families of products vs one product via inheritance vs step-by-step assembly of one complex product.
- **Observer vs Mediator:** one-to-many broadcast vs centralized coordination of peers.
- **Command vs Strategy:** a Command encapsulates a request (receiver + action, often undoable); a Strategy encapsulates how to do one thing.
- **Template Method vs Strategy:** inheritance (vary steps in subclasses) vs composition (swap the whole algorithm).
