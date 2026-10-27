# The Test Boundary

## Core statement
Tests are the outermost component of the system: they depend inward, nothing depends on
them, and they deploy separately. They must be designed as part of the architecture.
Poorly integrated tests become fragile and make the production code rigid.

## Symptoms
- A small UI or navigation change breaks hundreds of tests.
- Developers resist changes because of how many tests would fail.
- A test class mirrors each production class and every method.
- Business rules are verified by driving the GUI from the login page.
- Refactoring internals forces broad test edits.

## How to apply
1. Treat all test kinds (unit, acceptance, BDD) as equivalent architecturally: they all
   depend inward on the system.
2. Do not depend on volatile things in tests; verify business rules without the GUI.
3. Create a testing API: a superset of what the UI-facing interactors offer, plus
   superpowers (skip authentication, use in-memory stores, force states).
4. Write tests against that API, not against internal classes, so structure can change freely.
5. Avoid one-to-one mapping between test and production classes; organize by behavior.
6. Let tests become concrete and the production code become general; do not tie them together.
7. Keep the dangerous superpowers in a separate, independently deployable component
   excluded from production builds.

## Example (TypeScript)
```ts
// testing API lives outside production bundle
export function newScenario() {
  const carts = new Map<string, number[]>();
  return {
    givenCart: (id: string, prices: number[]) => carts.set(id, prices),
    checkoutTotal: (id: string) => (carts.get(id) ?? []).reduce((a, b) => a + b, 0),
  };
}

const s = newScenario();
s.givenCart("c1", [500, 250]);
console.assert(s.checkoutTotal("c1") === 750);
```

## Language notes
- Python: pytest fixtures can host the testing API; keep it in a `testsupport` package not shipped.
- TypeScript: separate workspace package or tsconfig excluding it from the build.
- E2E browser tests are fine at the edge for UI behavior; keep them few.

## Common over-application
- Banning direct unit tests of genuinely stable, central abstractions.
- Building an elaborate testing API for a tiny script.
- Shipping the testing API to production with its security bypasses intact.

Source: Martin (2017), Ch. 28.
