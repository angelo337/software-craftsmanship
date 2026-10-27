# Template Method

**Intent.** Fix the skeleton of an algorithm in a base operation and defer some steps to subclasses (or callbacks), so steps vary without changing the structure.

## Use when (code signals)
- Two or more classes/functions repeat the same sequence (open, parse, process, close) and differ in a few steps.
- Framework-style code: you own the flow and let users fill hooks (`setUp/tearDown`, lifecycle callbacks, `doGet`).
- You must enforce invariants such as always calling cleanup, ordering of steps, or calling a hook at a defined moment.

## Don't use when
- Variation is whole-algorithm replacement: Strategy.
- Inheritance depth is already a problem, or steps need runtime swapping: pass functions instead.
- Only one implementation exists: no template.

## Participants & structure
AbstractClass (template method calling primitive operations, hooks and concrete steps) ; ConcreteClass (overrides the primitives).
```
run():  before() ; step1() ; step2()  <- subclass fills ; after()
```
Principle: the parent calls the child ("Hollywood principle").

## Consequences
+ Code reuse; inverted control; consistent flow in one place.
- Subclasses must know which methods to override and which are mandatory; fragile base class risk.
- Inheritance is static: hard to vary at runtime.

## Implementation tips
- Mark the template method non-overridable (`final`, `sealed`) when the order must hold.
- Minimize abstract primitives; use no-op hooks for optional steps.
- Name hooks consistently (`do_`, `on_`, `before_`/`after_`) and document which are required.
- Call a hook only at documented points; avoid calling overridable methods from constructors.

## Language mapping
- Python/JS/TS: a higher-order function taking step callbacks; or base class with overridable methods. Context managers / `try/finally` express setup-cleanup skeletons.
- Java: abstract class (`HttpServlet`, `AbstractList`); C#: `virtual`/`abstract`. Go: no inheritance, so accept funcs or an interface of steps and run the skeleton in a function.

## Example (Python)
```python
def etl(extract, transform, load, log=print):
    log("start")
    try:
        load(transform(extract()))
    finally:
        log("done")

etl(read_csv, clean, write_db)
```

## Related
Strategy (delegation versus inheritance), Factory Method (often a step in a template), Iterator (traversal can itself be a template).

## Source
Gamma et al., 1995, p. 325.
