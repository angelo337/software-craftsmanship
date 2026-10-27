# Stable Abstractions Principle (SAP)

## Core statement
A component should be as abstract as it is stable. Stable components hold
high-level policy and must still be extensible, so they should be mostly
interfaces and abstract classes (OCP). Unstable components should be concrete,
since their instability makes concrete code cheap to change.
SDP + SAP = DIP for components: dependencies run toward abstraction. Unlike
DIP on classes, a component can be partly abstract and partly stable.

## Metrics
- `A = Na / Nc` (abstract classes + interfaces over all classes), [0,1].
- Plot A (y) vs I (x). Ideal points: (0,1) and (1,0); the line between is the main sequence.
- `D = |A + I - 1|`; 0 on the sequence, 1 farthest.
- Zone of pain near (0,0): stable, concrete, rigid. Fine if never volatile
  (a standard string/date library); bad if volatile (a shared DB schema module).
- Zone of uselessness near (1,1): abstract, no users, abandoned interfaces.

## Symptoms
- Widely used package full of concrete classes that keep changing (pain).
- Package of interfaces nobody implements or imports (useless).
- High D plus high volatility (check commit history, not only structure).
- Changes to the stable core need sweeping edits across dependents.

## Fix steps
1. Compute I, A, D for each component (metrics.md); take outliers (D above ~0.3, or your own control limit).
2. In pain: extract the stable policy behind interfaces, leaving the volatile details in a concrete, unstable component that implements them.
3. In uselessness: delete unused abstractions, or move them next to their only real consumer.
4. Prefer the endpoints; accept being near the line for the few components that are mixed.
5. Track D per release; investigate when it crosses a threshold.

## Example (original)
`tax-lib` is used by 8 services, A=0, I=0.1, D=0.9, and tax rules change each quarter.
```
tax-api   {TaxPolicy (interface), Money}   I~0,   A=1
tax-rules {EuTax, UsTax: TaxPolicy}        I~0.8, A=0
services -> tax-api; main wires tax-rules
```
New quarterly rules only touch `tax-rules`; services keep compiling.

## Language notes
- Python: abstractness from `abc.ABC`/`Protocol` classes; duck typing makes A look low even when design is fine, so judge by volatility and use D loosely.
- npm workspaces: count TypeScript interfaces/abstract classes; plain JS rarely shows A.
- Java: interfaces and abstract classes count; JPMS `exports` of an API package supports this.
- Go: interfaces are small and consumer-side; count interface types vs total types.
- .NET: interfaces/abstract classes per assembly; `.Abstractions` packages sit at A near 1.

Source: Martin (2017), Ch. 14.
