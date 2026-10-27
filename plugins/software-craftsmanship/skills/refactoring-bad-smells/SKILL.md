---
name: refactoring-bad-smells
description: Identify code smells and choose the refactoring that cures each (Fowler and Beck's "Bad Smells in Code"). Use whenever the user asks to review, audit, assess or critique code quality, find what to refactor, asks "what is wrong with this code", or you notice duplicated code, long methods, large classes, long parameter lists, feature envy, switch statements, data clumps, primitive obsession, shotgun surgery, data classes, speculative generality, message chains, or comment-heavy code. Spanish triggers - olores de código, code smells, qué refactorizar, revisar calidad del código.
---

# Bad smells in code

A smell is a surface symptom that suggests a deeper design problem. It is a prompt to look, not a defect to fix mechanically. No metric replaces informed judgment about how many fields or lines are too many, so decide in context. Smells answer *when* to refactor; the chapter skills answer *how*.

## How to use

1. Read the code and note each symptom in `references/smells-to-refactorings.md` (22 smells, each with signals and cures).
2. Rank by pain: smells in code you are about to change come first; smells in stable, rarely touched code can wait.
3. Choose the cure, confirm tests exist (`refactoring-building-tests`), then apply the refactoring from its chapter skill via the router `refactoring`.
4. In reviews, report each finding as: location, smell name, why it hurts here, recommended refactoring, priority.

## Quick map (symptom to cure)

| Smell | First cures |
|---|---|
| Duplicated Code | Extract Method, Pull Up Field/Method, Form Template Method, Extract Class, Substitute Algorithm |
| Long Method | Extract Method, Replace Temp with Query, Replace Method with Method Object, Decompose Conditional |
| Large Class | Extract Class, Extract Subclass, Extract Interface |
| Long Parameter List | Replace Parameter with Method, Preserve Whole Object, Introduce Parameter Object |
| Divergent Change | Extract Class |
| Shotgun Surgery | Move Method, Move Field, Inline Class |
| Feature Envy | Move Method (after Extract Method if only part envies) |
| Data Clumps | Extract Class, Introduce Parameter Object, Preserve Whole Object |
| Primitive Obsession | Replace Data Value with Object, Replace Type Code with Class/Subclasses/State-Strategy |
| Switch Statements | Replace Conditional with Polymorphism, Replace Type Code..., Replace Parameter with Explicit Methods, Introduce Null Object |
| Parallel Inheritance Hierarchies | Move Method, Move Field |
| Lazy Class | Collapse Hierarchy, Inline Class |
| Speculative Generality | Collapse Hierarchy, Inline Class, Remove Parameter, Rename Method |
| Temporary Field | Extract Class, Introduce Null Object |
| Message Chains | Hide Delegate, Extract Method + Move Method |
| Middle Man | Remove Middle Man, Inline Method, Replace Delegation with Inheritance |
| Inappropriate Intimacy | Move Method/Field, Change Bidirectional to Unidirectional, Extract Class, Hide Delegate |
| Alternative Classes with Different Interfaces | Rename Method, Move Method, Extract Superclass |
| Incomplete Library Class | Introduce Foreign Method, Introduce Local Extension |
| Data Class | Encapsulate Field/Collection, Remove Setting Method, Move Method, Hide Method |
| Refused Bequest | Push Down Method/Field; Replace Inheritance with Delegation if the interface is refused |
| Comments (as deodorant) | Extract Method, Rename Method, Introduce Assertion |

## Judgment notes

- Duplication is the top smell: removing it simplifies almost everything else.
- Small methods pay off through good names. Extract when you feel the urge to comment, even for a single line, if the name explains intent. What matters is the semantic distance between what and how, not line count.
- Polymorphism is overkill when a few cases affect one method and are stable; prefer explicit methods or a lookup table.
- Refused Bequest is usually a faint smell; act only when it causes confusion, or when the subclass rejects the superclass interface.
- Comments are not bad. Comments that explain *why* or flag uncertainty are good; comments that explain confusing code are the smell.

Source: Fowler, M., Beck, K., Brant, J., Opdyke, W., & Roberts, D. (1999). *Refactoring: Improving the design of existing code* (Ch. 3). Addison-Wesley.
