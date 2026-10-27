---
name: clean-code-objects-classes
description: Design classes, objects, data structures, modules and system structure following Clean Code (Objects and Data Structures, Classes, Systems, Emergence). Use whenever you design or refactor a class/module, decide between object vs data structure, handle dependencies and construction, see god classes, feature envy, train-wreck calls (a.getB().getC()), anemic models, switch on type, or too many responsibilities. Triggers on "SRP", "cohesion", "coupling", "dependency injection", "design", "arquitectura", "diseño de clases".
---

# Objects, classes, systems

## Objects vs data structures

- **Objects** hide data behind behaviour; **data structures** expose data and have little behaviour. Adding a new type is easy with objects, adding a new function is easy with data structures. Choose per situation; don't mix into hybrids that are half-and-half (public fields plus business methods).
- Hide implementation: expose abstract operations, not getters/setters that mirror private fields.
- **Law of Demeter:** a method talks only to its own object, its parameters, objects it creates, and its direct components. Avoid train wrecks (`ctx.getOptions().getScratchDir().getAbsolutePath()`); tell the collaborator what you want it to do instead.
- DTOs/records are fine for transport; keep business rules out of them.

## Classes

1. **Small, by responsibility** (not line count): the class name should describe it without "and", "Manager", "Processor". Describe it in ~25 words without "if/and/or/but".
2. **Single Responsibility Principle:** one reason to change. Many small classes beat a few large ones; the number of concepts is the same, but they are named and findable.
3. **High cohesion:** methods use most of the instance variables. When groups of methods use only some variables, split the class.
4. **Organise for change (Open-Closed):** extend with new subclasses/strategies rather than editing stable code. Isolate volatile detail (e.g. an external API) behind an interface so tests can substitute it.
5. **Standard layout:** constants, then static, then instance variables, then public methods, with each private helper right after its first caller. Keep variables private; loosen only when a test needs it.
6. **Few instance variables, few methods, tight interface** (hide data, helpers, constants). Don't create artificial coupling by placing general things inside specific classes.
7. **Place code where readers expect it** (least surprise); watch for feature envy (a method more interested in another class's data than its own).
8. **Prefer instance methods to statics** unless there is no chance of polymorphism.
9. **Inheritance:** base classes should not know their derivatives; use composition when "is-a" is not truly valid.

## Systems

- **Separate construction from use.** Build objects in `main`/composition root or a factory; application code receives collaborators (dependency injection) instead of instantiating them or looking them up. Avoid lazy initialisation scattered through business logic.
- Keep cross-cutting concerns (transactions, security, logging) out of domain classes, via decorators, proxies, middleware or aspects.
- Grow architecture incrementally; defer decisions until the last responsible moment. Use a domain vocabulary consistently (a DSL where it pays).
- Don't overengineer for imaginary futures; do the simplest thing that can work with tests.

## Simple design (four rules, in priority order)

1. Runs all the tests.
2. No duplication.
3. Expresses the intent of the programmer (clear names, small units, standard names, good tests).
4. Minimises the number of classes and methods (do not split dogmatically).

Items 2-4 are applied through continuous refactoring with the tests as a safety net.

## Quick check

- What is this class's one reason to change?
- Does any method mostly use another object's data?
- Are dependencies passed in rather than created inside?
- Is any switch/if-chain on a type repeated in several places?
- Are public surfaces as small as they can be?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 6, 10, 11, 12; Ch. 17 heuristics G6-G8, G13, G14, G17, G18, G23, G27, G36, J2, J3). Prentice Hall.
