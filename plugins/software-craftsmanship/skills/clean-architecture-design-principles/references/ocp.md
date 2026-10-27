# OCP: Open-Closed Principle

## Core statement
A software artifact should be open for extension and closed for modification: new behavior comes from adding code, not editing working code. Originated with Bertrand Meyer (1988). At architecture scale, it means arranging components so that higher-level ones are protected from changes in lower-level ones.

## Symptoms in code
- Every new variant (report format, payment type, device) requires editing the same switch/if-chain in several places.
- A small requirement change ripples through many files.
- Business rules import presentation or persistence code, so UI tweaks trigger rule changes.
- Component graph with arrows pointing toward volatile details.

## How to fix
1. Separate responsibilities that change for different reasons (SRP). Example: computing report data vs. presenting it.
2. Decide which side is higher-level (closer to business policy). It must be the most protected.
3. Make the lower-level side depend on the higher-level side: define an interface in the high-level component, implement it in the low-level one (DIP).
4. If component A should be protected from changes in B, make B depend on A. Arrows then run only one way across each boundary, forming a hierarchy of protection.
5. Add interfaces that hide internals from clients (information hiding), so clients do not gain transitive dependencies.
6. Add a new variant by writing a new implementation and registering it at the composition root.

```typescript
interface ReportView { render(rows: Row[]): string }   // owned by core

function buildReport(rows: Row[], view: ReportView) {  // closed
  return view.render(rows.filter(r => r.total !== 0));
}
class WebView implements ReportView { render(r: Row[]) { /* red negatives */ return ""; } }
class PrintView implements ReportView { render(r: Row[]) { /* (negatives) */ return ""; } }
// new PdfView = new class, buildReport untouched
```

## Language notes
- Python: a callable or Protocol is enough; dict-of-handlers registries work.
- TypeScript: discriminated unions give exhaustiveness checks; fine for closed sets, interfaces for open sets.
- Plugin systems (entry points, DI containers) are the large-scale form.

## Common over-application
- Predicting every extension and adding hooks for them. You can only be closed against changes you chose; wait for the first change, then protect against that axis.
- Interface for a variation that never appears.
- Inheritance trees where a function argument would do.

## Related principles
SRP (finds the axes), DIP (provides the mechanism), LSP (extensions must be substitutable), ISP (keeps interfaces narrow).

## Source
Martin (2017), Ch. 8 (OCP).
