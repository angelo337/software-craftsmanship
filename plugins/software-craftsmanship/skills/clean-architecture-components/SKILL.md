---
name: clean-architecture-components
description: Use when splitting a codebase into packages, modules, libraries, assemblies or services; deciding what classes/files to group together; fixing circular or cyclic dependencies between modules; reviewing package structure, release/versioning boundaries, or dependencies between modules; judging stable vs unstable modules; or computing coupling metrics (fan-in, fan-out, instability, abstractness, distance from main sequence). Covers Martin's component principles REP, CCP, CRP, ADP, SDP, SAP. Trigger on "package design", "cyclic dependency", "dependencies between modules", "REP", "CCP", "CRP", "ADP", "SDP", "SAP", "instability", "módulos", "dependencias circulares", "diseño de paquetes", "acoplamiento". Use it even if the user never names the principles.
---

# Component Principles (Martin, Clean Architecture, Part IV)

Six principles decide what goes into a component (cohesion) and how components
may depend on each other (coupling). Apply them when drawing or reviewing
module boundaries.

## What a component is

A component is the smallest independently deployable unit: a jar, gem, wheel,
npm package, DLL/assembly, Go module, or a set of source files shipped as one.
Whether it ends up linked into one binary, bundled in an archive, or loaded as a
plugin, design it so it COULD be deployed and developed on its own. That
property is what makes teams and releases independent, so protect it.

## Cohesion: what to group (details: references/component-cohesion.md)

- **REP (Reuse/Release Equivalence)**: the unit you reuse is the unit you
  release. Everything in a component shares one theme, one version number, one
  changelog. Why: consumers only adopt code that has release numbers and notes.
- **CCP (Common Closure)**: put together what changes for the same reasons at
  the same time; separate what changes apart. It is SRP for components. Why: one
  change should touch and redeploy one component.
- **CRP (Common Reuse)**: classes reused together live together; don't force
  consumers to depend on things they don't use. It is ISP for components. Why:
  an unneeded class still triggers rebuilds/revalidation when it changes.

Tension: REP and CCP are inclusive (components grow); CRP is exclusive (they
shrink). Ignore CCP and a simple change ripples through many components. Ignore
CRP and consumers suffer needless churn. Ignore REP and nothing is reusable.

```
                 REP
                /   \
 (drop CCP:    /     \  (drop CRP: too many
 many comps   /       \  unneeded releases)
 hit per edit)         
            CRP ------- CCP
           (drop REP: hard to reuse)
```

Project age shifts the balance. Early on, develop-ability wins, so lean on CCP
(few, larger components; reuse is sacrificed). As other projects start consuming
yours, slide toward REP/CRP (smaller, tightly focused, versioned). Expect the
layout to be revisited; it is not permanent.

## Coupling: how components may depend

### ADP: no cycles (references/acyclic-dependencies.md)
The component graph must be a DAG. A cycle fuses its members into one big
component: they must be built, tested and released together, and you cannot unit
test one without dragging in the rest. Break a cycle by (1) applying DIP: put an
interface in the lower component and implement it in the other, flipping that
edge; or (2) extracting the shared classes into a new component both depend on.
Cycles reappear as the system grows, so check for them continually.

**Top-down design does not work for components.** The dependency graph is a map
of buildability and maintainability, not of functions. It cannot exist before
there is code. It evolves: first isolate volatility (CCP), later reuse (CRP),
and ADP reshapes it whenever cycles show up. Do not draw a final component
diagram on day one.

### SDP: depend in the direction of stability (references/stable-dependencies.md)
Stability = effort needed to change = how many others depend on you. Measure:
`I = Fan-out / (Fan-in + Fan-out)`, range [0,1]. Fan-in = outside classes
depending on classes inside; fan-out = inside classes depending on outside.
I=0 is maximally stable (responsible, independent); I=1 is maximally unstable
(irresponsible, dependent). Rule: a component's I must be larger than the I of
everything it depends on, so I decreases along dependency arrows. Not all
components should be stable: a system of only stable parts cannot change. Fix a
violation with DIP (a stable interface component that the volatile one
implements).

### SAP: as abstract as stable (references/stable-abstractions.md)
A stable component must be abstract enough to be extended without edits (OCP);
an unstable one should be concrete. SDP + SAP = DIP for components:
dependencies point toward abstraction. Abstractness `A = Na / Nc` (abstract
classes/interfaces over total classes). Plot A (vertical) vs I (horizontal).
- Ideal ends: (I=0, A=1) and (I=1, A=0). The line joining them is the **main sequence**.
- **Zone of pain** near (0,0): stable and concrete, rigid. Harmless only if
  it never changes (e.g. a string library); painful if volatile (e.g. DB schema).
- **Zone of uselessness** near (1,1): abstract with no users, leftover interfaces.
- **Distance** `D = |A + I - 1|`, 0 = on the sequence. Investigate outliers
  and track D per release against a threshold.
Dynamic languages without interfaces: A is low everywhere, so use D loosely.

Metrics file: references/metrics.md. Treat metrics as a smoke alarm against an
arbitrary standard, not as a goal.

## Detect-and-fix workflow

1. List components (the real deployable units) and their import edges.
2. Find cycles (SCCs). Fix each with DIP or an extracted component (ADP).
3. Compute I per component. List every edge where the source's I is not
   greater than the target's I (SDP violations); invert with an interface.
4. Compute A and D. Look at components far from the main sequence and at the
   zones of pain (volatile, concrete, many dependents) and uselessness.
5. Re-check cohesion: does each component change for one reason (CCP), release
   as one theme (REP), and get used whole (CRP)? Split or merge accordingly.
6. Re-run the numbers after each change; prefer failing a CI check on new cycles.

## Recipe: fan-in, fan-out, instability from Python imports

Treat each top-level directory under `src/` as a component.

```python
import ast, pathlib, collections
root = pathlib.Path("src"); comps = {p.name for p in root.iterdir() if p.is_dir()}
edges = collections.defaultdict(set)            # comp -> comps it uses
for f in root.rglob("*.py"):
    a = f.relative_to(root).parts[0]
    for n in ast.walk(ast.parse(f.read_text())):
        names = [x.name for x in n.names] if isinstance(n, ast.Import) else \
                [n.module or ""] if isinstance(n, ast.ImportFrom) else []
        for m in names:
            b = m.split(".")[0]
            if b in comps and b != a: edges[a].add(b)
for c in sorted(comps):
    out = len(edges[c]); fin = sum(c in v for v in edges.values())
    print(c, "fan-in", fin, "fan-out", out, "I", round(out / (fin + out), 2) if fin + out else "n/a")
```
This counts component-to-component edges (coarser than class counts, fine for a
first look). Shell alternative for a quick view of who imports `billing`:
`grep -rlE "^(from|import) billing" src | cut -d/ -f2 | sort | uniq -c`.

## When not to over-engineer

- Small team, one deployable, early stage: keep few components, favor CCP, skip
  reuse concerns and release ceremony. Do not publish internal packages nobody consumes.
- Do not create interface-only components until a real SDP/ADP violation hurts.
- Do not chase D = 0 or split files to tune numbers; fix only pain you can name
  (slow builds, ripple changes, untestable units).
- In Python/JS, DIP often needs no declared interface (duck typing); just move
  the import or pass the dependency in.
- Metrics are weak where volatility is low: a stable concrete utility is fine.

Source: Martin (2017), Ch. 12-14.
