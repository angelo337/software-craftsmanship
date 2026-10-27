---
name: refactoring-building-tests
description: Build the self-testing safety net required before refactoring (Fowler's "Building Tests"). Use whenever code about to be refactored has no tests or weak tests, when the user asks how to start testing legacy code, add characterization or regression tests, or when tests are manual, slow, or checked by eyeballing output. Triggers on "write tests before refactoring", "tests for legacy code", "safety net", "pruebas antes de refactorizar", "pruebas automáticas", "boundary tests".
---

# Building tests for refactoring

Refactoring requires tests. Without them you cannot prove behavior did not change, and debugging after a refactor eats the time you saved. You do not need exhaustive coverage to start: a small amount of well-aimed testing delivers most of the benefit.

## Principles

1. **Tests are automatic and self-checking.** They print a pass/fail verdict (or a green bar), not output a human must inspect. Compare actual results with expected values in code.
2. **Run them constantly,** after every small refactoring step. A bug found minutes after it was introduced sits in the few lines just changed.
3. **Test the areas you worry about.** Be risk-driven: skip trivial getters/setters, focus on logic that can break now or later. Incomplete tests that run beat complete tests that never run.
4. **Probe boundaries and failures.** Test the first and last element, empty input, one past the end, null/absent values, repeated operations, and that expected errors are raised. Play the enemy: try to break the code.
5. **Isolate each test.** Fresh fixture per test (setup/teardown), no order dependence, so any test can run alone.
6. **Write the test first when adding a feature:** it clarifies the interface and gives a clear "done" signal. When the code already exists, add tests for the behavior you are about to restructure.
7. **One command runs everything,** and fast. Slow suites get skipped.
8. **When a bug slips through, add a test that exposes it** before fixing it, so it never returns.

## Procedure for untested code

1. List the behaviors of the unit you will change (what callers rely on).
2. Write characterization tests: call the code with representative inputs, record what it currently returns, assert on that. This pins existing behavior, even quirks you may later decide to fix separately.
3. Add boundary and error-path cases for each behavior.
4. Run the suite; make sure it fails when you deliberately break the code (mutate a line) to prove it can catch regressions.
5. Hand over to `refactoring`: refactor in small steps, running the suite each time. Change tests only when an interface changes, not to make a failing test pass.

## Frameworks

Use the project's standard: pytest/unittest (Python), JUnit/TestNG (Java), Jest/Vitest (TypeScript/JS), xUnit/NUnit (C#), `testing` (Go). Name tests after behavior; use fixtures for shared setup; add assertion messages that explain failures.

## When tests are impossible

If the code cannot be tested without large changes, make the smallest safe changes to create a seam (extract a dependency, pass it in) with very careful, tool-assisted edits, add tests, then continue. If the code is too broken to stabilize, a rewrite may be the better option.

Source: Fowler, M., Beck, K., Brant, J., Opdyke, W., & Roberts, D. (1999). *Refactoring: Improving the design of existing code* (Ch. 4). Addison-Wesley.
