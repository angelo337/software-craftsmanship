# Coupling metrics: Fan-in, Fan-out, I, A, D

## Core statements
- Fan-in: classes outside the component that depend on classes inside it.
- Fan-out: classes inside the component that depend on classes outside it.
- `I = Fan-out / (Fan-in + Fan-out)`; undefined when both are 0 (isolated).
- `A = Na / Nc`; `D = |A + I - 1|`.
- Metrics measure conformance to one opinionated pattern; they are indicators, not goals.

## Symptoms they reveal
- Edge where I(source) <= I(target): SDP violation.
- D far from 0: SAP violation (pain or uselessness).
- Fan-out high for a "core" component: it is dependent on volatile things.
- Mean/variance of D across the system rising release over release.

## Fix steps
1. Define components explicitly (directory, package, assembly).
2. Extract edges from imports (class-level is finer; module-level is a fine start).
3. Compute Fan-in, Fan-out, I, A, D per component.
4. Sort by D and by SDP violations; take the top few.
5. Treat anything beyond one standard deviation from the mean D, or past a fixed threshold, as a candidate; fix via stable-dependencies.md / stable-abstractions.md.
6. Store results per release and chart D over time for components that matter.

## Example (original): worked numbers
Component `ledger`: 5 outside classes use it (fan-in 5); it uses 2 outside classes (fan-out 2).
I = 2/7 = 0.29. It has 10 classes, 4 are interfaces, so A = 0.4.
D = |0.4 + 0.29 - 1| = 0.31, a bit toward the pain side (too concrete for how stable it is).
Recipe, Python plus abstract count:
```python
import ast, pathlib
def abstractness(pkg):
    na = nc = 0
    for f in pathlib.Path(pkg).rglob("*.py"):
        for n in ast.walk(ast.parse(f.read_text())):
            if isinstance(n, ast.ClassDef):
                nc += 1
                na += any(getattr(b, "id", getattr(b, "attr", "")) in ("ABC", "Protocol") for b in n.bases)
    return na / nc if nc else 0
```
Combine with the fan-in/out script in SKILL.md; `D = abs(A + I - 1)`.

## Language notes
- Python: `import-linter`, `pydeps`, `ast` for edges.
- npm workspaces: `madge`, `dependency-cruiser` (reports instability directly).
- Java: JDepend, ArchUnit, or Structure101-style tools report Ca/Ce, I, A, D.
- Go: `go list -deps`/`go list -json ./...` Imports; `go-arch-lint` for rules.
- .NET: NDepend, or Visual Studio code metrics plus assembly references.
Counting by class (as the book does) vs by module changes numbers but not the story.

Source: Martin (2017), Ch. 14.
