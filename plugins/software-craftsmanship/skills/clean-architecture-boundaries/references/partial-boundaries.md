# Partial Boundaries

## Core statement
A full boundary costs reciprocal interfaces, input and output structures, and separately
managed components. When you foresee a boundary but cannot yet pay, hold a place with a
cheaper partial form, knowing each form can erode if the real boundary never comes.

## Symptoms
- You believe a part may need to be swapped, split, or reused, but there is no concrete need yet.
- Multiple deliverables would burden users or release management today.
- A placeholder exists and callers have begun reaching around it.
- Debate between "YAGNI" and "we might need it" stalls the team.

## How to apply
Choose one of three forms, from most to least protective:
1. **Skip the last step.** Build interfaces and data structures on both sides, but build
   and ship as one component. Costs design work, saves version and release management.
2. **One-dimensional boundary.** A Strategy-like interface the client depends on and
   implementations satisfy. Reverse direction is guarded only by discipline.
3. **Facade.** A single class exposing the services and hiding the rest. No inversion;
   the client depends transitively on everything behind it.

Then: write down which form you chose and why, add a check (import lint, review rule)
against backchannels, and re-evaluate when friction appears. Promote to a full boundary
at the point where the cost of absence exceeds the cost of building.

## Example (TypeScript)
```ts
// One-dimensional boundary: client depends on the interface only.
export interface Notifier { send(userId: string, msg: string): void }

export function welcome(n: Notifier, userId: string) {
  n.send(userId, "Welcome aboard");
}

class EmailNotifier implements Notifier {
  send(userId: string, msg: string) { console.log(`mail ${userId}: ${msg}`); }
}
welcome(new EmailNotifier(), "u1");
// Gap: nothing stops other code from importing EmailNotifier directly.
```

## Language notes
- Python: a Protocol plus a lint rule (import-linter) gives the discipline mechanically.
- TypeScript: path restrictions via eslint or dependency-cruiser; package `exports` hide internals.
- Compiled languages: a Facade still forces client recompiles when hidden classes change.

## Common over-application
- Using partial boundaries everywhere "just in case"; prefer none when no axis of change is visible.
- Leaving placeholders unreviewed until dependencies leak across them.
- Building the full boundary up front when a partial one would have sufficed.

Source: Martin (2017), Ch. 24.
