# Catalog index (72 refactorings)

Open the named skill for mechanics and examples.

## Contents
- Composing Methods (9)
- Moving Features Between Objects (8)
- Organizing Data (16)
- Simplifying Conditional Expressions (8)
- Making Method Calls Simpler (15)
- Dealing with Generalization (12)
- Big Refactorings (4)

## Composing Methods: `refactoring-composing-methods`
- Extract Method: a fragment that can be grouped and named by intent
- Inline Method: body is as clear as the name, or indirection is excessive
- Inline Temp: a temp holds a trivial expression and blocks other refactorings
- Replace Temp with Query: temp holds an expression you can compute in a method
- Introduce Explaining Variable: a complicated expression needs named pieces
- Split Temporary Variable: one temp assigned for two purposes
- Remove Assignments to Parameters: code assigns to a parameter
- Replace Method with Method Object: long method whose locals block extraction
- Substitute Algorithm: replace an algorithm with a clearer one

## Moving Features Between Objects: `refactoring-moving-features`
- Move Method: method uses another class more than its own
- Move Field: field is used more by another class
- Extract Class: one class doing the work of two
- Inline Class: a class does too little
- Hide Delegate: client calls through an object to its delegate
- Remove Middle Man: class does too much trivial delegating
- Introduce Foreign Method: need one method on a class you cannot modify
- Introduce Local Extension: need several methods on a class you cannot modify

## Organizing Data: `refactoring-organizing-data`
- Self Encapsulate Field: direct field access is becoming awkward
- Replace Data Value with Object: a data item needs behavior or related data
- Change Value to Reference: many equal instances should be one shared object
- Change Reference to Value: a small immutable reference object is awkward
- Replace Array with Object: array elements mean different things
- Duplicate Observed Data: domain data stuck in GUI controls
- Change Unidirectional Association to Bidirectional: both sides need to navigate
- Change Bidirectional Association to Unidirectional: one direction is unused
- Replace Magic Number with Symbolic Constant: literal with a special meaning
- Encapsulate Field: a public field
- Encapsulate Collection: a getter returns the collection itself
- Replace Record with Data Class: an interface to a record structure
- Replace Type Code with Class: a type code that does not affect behavior
- Replace Type Code with Subclasses: type code affects behavior and does not change
- Replace Type Code with State/Strategy: type code affects behavior and can change
- Replace Subclass with Fields: subclasses differ only in constant-returning methods

## Simplifying Conditional Expressions: `refactoring-conditionals`
- Decompose Conditional: complicated condition and branches
- Consolidate Conditional Expression: several checks with the same result
- Consolidate Duplicate Conditional Fragments: same code in every branch
- Remove Control Flag: a flag variable controls loop or sequence
- Replace Nested Conditional with Guard Clauses: special cases hide the normal path
- Replace Conditional with Polymorphism: a conditional on object type
- Introduce Null Object: repeated null checks
- Introduce Assertion: code assumes a condition holds

## Making Method Calls Simpler: `refactoring-method-calls`
- Rename Method: the name does not reveal purpose
- Add Parameter: method needs more information
- Remove Parameter: parameter is unused
- Separate Query from Modifier: method returns a value and changes state
- Parameterize Method: several methods differ only by values
- Replace Parameter with Explicit Methods: method behavior depends on a flag value
- Preserve Whole Object: several values taken from one object
- Replace Parameter with Method: receiver can compute the parameter itself
- Introduce Parameter Object: parameters that naturally go together
- Remove Setting Method: a field should be set only at creation
- Hide Method: method is never used outside its class
- Replace Constructor with Factory Method: creation needs more than construction
- Encapsulate Downcast: callers must downcast a returned value
- Replace Error Code with Exception: a method returns a special code for errors
- Replace Exception with Test: exception thrown for a condition the caller can check

## Dealing with Generalization: `refactoring-generalization`
- Pull Up Field, Pull Up Method, Pull Up Constructor Body: duplication in sibling subclasses
- Push Down Method, Push Down Field: behavior relevant to only some subclasses
- Extract Subclass: features used only in some instances
- Extract Superclass: similar classes with no common parent
- Extract Interface: several clients use the same subset of a class
- Collapse Hierarchy: subclass and superclass barely differ
- Form Template Method: similar algorithms in subclasses with different steps
- Replace Inheritance with Delegation: subclass uses little of its superclass
- Replace Delegation with Inheritance: delegating many methods to one class

## Big Refactorings: `refactoring-big-refactorings`
- Tease Apart Inheritance: one hierarchy doing two jobs
- Convert Procedural Design to Objects: procedural code with dumb data records
- Separate Domain from Presentation: GUI classes hold domain logic
- Extract Hierarchy: one class with many flags and conditionals implementing several variants
