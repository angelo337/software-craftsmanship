# Smells to refactorings (detail)

Paraphrased from Fowler et al. (1999), Ch. 3. Each entry: what to look for, why it hurts, cures.

## Contents
Duplicated Code, Long Method, Large Class, Long Parameter List, Divergent Change, Shotgun Surgery, Feature Envy, Data Clumps, Primitive Obsession, Switch Statements, Parallel Inheritance Hierarchies, Lazy Class, Speculative Generality, Temporary Field, Message Chains, Middle Man, Inappropriate Intimacy, Alternative Classes with Different Interfaces, Incomplete Library Class, Data Class, Refused Bequest, Comments

## Duplicated Code
- **Look for:** the same structure in more than one place.
- **Why it hurts:** every change must be repeated and one copy gets missed.
- **Cures:** same class -> Extract Method. Sibling subclasses -> Extract Method then Pull Up Field/Method; similar but not identical -> Extract Method to isolate differences, then Form Template Method; same job, different algorithm -> Substitute Algorithm (keep the clearer one). Unrelated classes -> Extract Class and reuse it, or keep the method in the one class that owns it.

## Long Method
- **Look for:** methods you must scroll; blocks with explanatory comments; loops and conditionals that deserve names.
- **Why it hurts:** hard to understand, no reuse. Short methods with good names let readers skip bodies.
- **Cures:** nearly always Extract Method. Many temps/parameters in the way -> Replace Temp with Query, Introduce Parameter Object, Preserve Whole Object; last resort Replace Method with Method Object. Conditionals -> Decompose Conditional; loops -> extract the loop and its body.

## Large Class
- **Look for:** many fields, many methods, fields used in only some paths, shared prefixes/suffixes among fields.
- **Cures:** Extract Class (bundle related fields/methods); Extract Subclass when variant behavior exists; Extract Interface for each client usage to see seams; for GUI classes, move domain data out (Duplicate Observed Data).

## Long Parameter List
- **Look for:** more than three or four parameters, repeated across methods, frequently changing.
- **Cures:** Replace Parameter with Method (receiver can ask), Preserve Whole Object, Introduce Parameter Object. Exception: when you deliberately avoid a dependency on the larger object, passing values is fine; if it hurts, rethink dependencies.

## Divergent Change
- **Look for:** one class changed for different reasons ("new database: change these three methods; new instrument: change those four").
- **Cure:** Extract Class so each class has one reason to change.

## Shotgun Surgery
- **Look for:** one kind of change forces many small edits across many classes.
- **Cures:** Move Method / Move Field to gather the behavior; Inline Class to merge; accept a small dose of divergent change after.

## Feature Envy
- **Look for:** a method calling many getters of another object.
- **Cures:** Move Method; if only part envies, Extract Method then move that part. If several classes are involved, put it with the class holding most of the data. Exceptions: Strategy/Visitor-style designs that separate behavior that changes independently.

## Data Clumps
- **Look for:** the same 3-4 values together in fields and parameter lists. Test: delete one; do the others still make sense?
- **Cures:** Extract Class for fields, then Introduce Parameter Object or Preserve Whole Object for signatures; then look for behavior to move into the new class.

## Primitive Obsession
- **Look for:** money as double, ranges as two ints, phone/ZIP as raw strings, type codes, arrays used as records.
- **Cures:** Replace Data Value with Object; Replace Type Code with Class (no behavior), with Subclasses or State/Strategy (behavior); Extract Class for field groups; Introduce Parameter Object; Replace Array with Object.

## Switch Statements
- **Look for:** the same switch/if-chain on type in several places.
- **Cures:** Extract Method, Move Method to the class that owns the type code, Replace Type Code with Subclasses or State/Strategy, then Replace Conditional with Polymorphism. Few stable cases in one method: Replace Parameter with Explicit Methods. Null case: Introduce Null Object.

## Parallel Inheritance Hierarchies
- **Look for:** every new subclass in one hierarchy forces one in another; matching name prefixes.
- **Cure:** make one hierarchy refer to the other, then Move Method/Field so the referring hierarchy disappears.

## Lazy Class
- **Look for:** a class that no longer pays for its upkeep.
- **Cures:** Collapse Hierarchy for subclasses; Inline Class for near-empty components.

## Speculative Generality
- **Look for:** hooks, abstract classes, parameters "we might need someday"; only tests use it.
- **Cures:** Collapse Hierarchy, Inline Class, Remove Parameter, Rename Method (odd abstract names); delete unused code and its tests.

## Temporary Field
- **Look for:** instance variables set only in some circumstances (often to avoid passing parameters through a complex algorithm).
- **Cures:** Extract Class to give orphan fields a home (a method object); Introduce Null Object for the "not valid" case.

## Message Chains
- **Look for:** `a.getB().getC().getD()` or a sequence of temps.
- **Cures:** Hide Delegate at a sensible point; better, see what the end object is used for, Extract Method, then Move Method down the chain. Do not turn every link into a middle man.

## Middle Man
- **Look for:** half the methods only delegate.
- **Cures:** Remove Middle Man; Inline Method for few; Replace Delegation with Inheritance if extra behavior is added.

## Inappropriate Intimacy
- **Look for:** classes reaching into each other's internals; subclass knowing too much about parent.
- **Cures:** Move Method/Field; Change Bidirectional Association to Unidirectional; Extract Class for shared interests; Hide Delegate; Replace Inheritance with Delegation for subclass intimacy.

## Alternative Classes with Different Interfaces
- **Look for:** two classes doing the same thing with different method names/signatures.
- **Cures:** Rename Method, Move Method until protocols match, then Extract Superclass.

## Incomplete Library Class
- **Look for:** you need behavior the library lacks and cannot edit it.
- **Cures:** Introduce Foreign Method (a few methods); Introduce Local Extension (many).

## Data Class
- **Look for:** only fields and getters/setters, manipulated by other classes.
- **Cures:** Encapsulate Field (public fields), Encapsulate Collection, Remove Setting Method, Move Method (or Extract Method then move) to give it behavior, Hide Method on accessors no longer needed.

## Refused Bequest
- **Look for:** subclass ignores most inherited members.
- **Cures:** Push Down Method/Field into a new sibling when it confuses; Replace Inheritance with Delegation when the subclass rejects the superclass's interface. Often too faint to bother.

## Comments
- **Look for:** comments compensating for unclear code.
- **Cures:** Extract Method (name from the comment), Rename Method, Introduce Assertion for stated rules. Keep comments that say why, or admit uncertainty.
