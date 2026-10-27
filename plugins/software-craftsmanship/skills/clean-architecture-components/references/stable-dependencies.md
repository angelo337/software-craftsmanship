# Stable Dependencies Principle (SDP)

## Core statement
Depend in the direction of stability. A component expected to change must not be depended on by a component that is hard to change.
Why: a module built to be easy to change becomes hard to change the moment
others hang dependencies on it, without a line of it being touched.

## Stability defined
Stability is how much work a change costs, not how often it changes. The main
driver here is incoming dependencies: many dependents means any change must be
reconciled with all of them. Responsible (many dependents) and independent
(no outgoing dependencies) means stable. Irresponsible (no dependents) and
dependent (many outgoing) means unstable.

## Metric
`I = Fan-out / (Fan-in + Fan-out)`, [0,1]. I=0 stable, I=1 unstable.
SDP: I of a component must be greater than I of each component it depends on.
I falls along the arrows. A system needs both kinds; draw unstable parts on top
so any arrow pointing up is a violation.

## Symptoms
- A stable core module imports a volatile one (config loader, UI, vendor SDK adapter).
- Editing a "flexible" module triggers changes or retests in many dependents.
- Arrow from low-I to high-I component in the graph.

## Fix steps
1. Compute I for every component (metrics.md).
2. List edges where I(source) <= I(target).
3. Find the concrete class the stable side uses.
4. Define an interface for just those needs, in a new (or the stable) component.
5. Make the volatile class implement it; the stable side depends on the interface.
6. Recompute: the interface component is at I near 0, the volatile one stays near 1.
In statically typed languages this interface-only component is normal and useful.
In dynamic languages it often is unnecessary: pass the dependency in.

## Example (original)
`core-pricing` (used by 6 services) imports `FeatureFlags` from `flags-client`, which changes with every vendor SDK update.
```
Before: core-pricing -> flags-client           I(core)=0.14 < I(flags)=1.0, violation
After:  core-pricing -> flag-port (interface FlagSource)
        flags-client -> flag-port (implements)
```
```go
// flag-port
type FlagSource interface{ Enabled(name string) bool }
```
Vendor upgrades now touch only `flags-client`; wiring happens in the main component.

## Language notes
- Python: protocols or plain callables; put the import in the composition root.
- npm workspaces: a `*-types` or `*-contracts` workspace holds the interfaces.
- Java: an `-api` module with interfaces, `-impl` module with classes.
- Go: define the interface in the consumer's package; no extra component needed.
- .NET: a `.Abstractions` assembly (a common convention).

Source: Martin (2017), Ch. 14.
