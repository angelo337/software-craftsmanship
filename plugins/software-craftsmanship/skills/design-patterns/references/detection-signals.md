# Detection signals

Use for mode A (detect) and as refactoring triggers for mode B. A signal suggests a candidate, not a mandate. Confirm the force before recommending.

## Contents
- Smell to pattern
- Patterns already present (recognition cues)

## Smell to pattern
| Signal in code | Candidate |
|---|---|
| `new ConcreteClass()` spread through business logic; tests can't swap it | Factory Method / Abstract Factory / DI |
| `if platform == X ... else ...` creating parallel object sets | Abstract Factory |
| Constructor with 6+ params, many optional, or setters called in a fixed order | Builder |
| Copy-pasting a configured object then tweaking it | Prototype |
| Global mutable instance accessed everywhere | Singleton smell: replace with injection |
| Wrapper class that only translates calls/data formats of a third-party API | Adapter |
| Parallel hierarchies `XxxOnLinux`, `XxxOnWindows` x several abstractions | Bridge |
| Recursive structures (menus, file trees, org charts, expression trees) with `isinstance` checks | Composite |
| Subclass per feature combination (`CompressedEncryptedStream`) | Decorator |
| Client code calls 5 subsystem classes in a fixed sequence | Facade |
| Thousands of objects duplicating identical immutable data | Flyweight |
| Wrapper that checks permissions/caches/lazy-loads before delegating | Proxy |
| Chain of `if handler_a can handle ... elif ...` | Chain of Responsibility |
| Buttons/menu actions calling logic inline; need undo, queue or macro | Command |
| Mini query/rule language parsed ad hoc | Interpreter |
| Callers poke at a collection's internals to loop | Iterator |
| Dialog/components with references to each other everywhere | Mediator |
| Manual copy of fields before a risky change "to restore later" | Memento |
| Object calls `a.update()`, `b.refresh()`, `c.log()` after every change | Observer |
| Large `switch(state)` repeated in many methods | State |
| `if algo == "x" ... elif algo == "y"` choosing a computation | Strategy |
| Subclasses duplicate the same sequence of steps, differing in one or two | Template Method |
| `isinstance` ladder performing an operation per node type; new operations added often | Visitor |

## Patterns already present (recognition cues)
- Class names or suffixes: `*Factory`, `*Builder`, `*Adapter`, `*Decorator`, `*Proxy`, `*Facade`, `*Strategy`, `*Observer/Listener/Subscriber`, `*Command`, `*Visitor`, `*Handler` (chains), `*State`.
- Framework hints: middleware pipelines (Chain), event emitters/signals (Observer), `functools.wraps`/Python decorators (Decorator, not always GoF), ORM lazy-loading (Proxy), iterators/generators (Iterator), `getInstance()`/module-level instance (Singleton).
- Report both explicit (named) and implicit (unnamed) uses, and note when the language construct already provides the pattern.
