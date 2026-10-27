---
name: clean-code-tests
description: Write and review clean unit tests following Clean Code (Unit Tests, TDD laws, F.I.R.S.T.). Use whenever you create, fix, extend or review tests in any framework (pytest, JUnit, Jest, xUnit...), when tests are slow, flaky, unreadable, coupled to implementation, or missing boundary cases; and when building a feature test-first. Triggers on "unit test", "pruebas", "TDD", "test coverage", "flaky test", "mock".
---

# Clean unit tests

Tests are what let you change code without fear; dirty tests are a liability that will be dropped. Test code deserves the same care as production code (not the same performance constraints).

## Process: three laws of TDD

1. Write no production code until you have a failing test.
2. Write no more of a test than is sufficient to fail (not compiling counts).
3. Write no more production code than is sufficient to pass the current failing test.

Work in short red-green-refactor cycles; after each green step refactor production and test code.

## Rules

1. **Readability above all:** clarity, simplicity, density of expression. Use the build-operate-check structure (Arrange-Act-Assert) and domain-specific helper functions/builders to hide plumbing, so each test reads as a spec.
2. **One concept per test.** Prefer a single logical assertion (or a small group asserting one idea); split tests that check unrelated things. Name tests after the behaviour (`rejectsExpiredToken`), not the method.
3. **F.I.R.S.T.**
   - **Fast:** slow tests get skipped.
   - **Independent:** no ordering dependency; each test sets up its own state.
   - **Repeatable:** same result in any environment; control time, randomness, network, filesystem.
   - **Self-validating:** boolean pass/fail, no manual log reading.
   - **Timely:** written just before the production code.
4. **Cover everything that could break,** especially boundary conditions, error paths and edge cases; use a coverage tool to find gaps, and exhaustively test near a found bug (bugs cluster).
5. **Don't skip trivial tests;** an ignored/disabled test is an open question about requirements, so link it to one, not a graveyard.
6. **Look at patterns of failure** (which inputs fail) to diagnose.
7. **Keep tests fast and deterministic;** isolate slow external systems behind interfaces and fakes (see `clean-code-errors-boundaries`).
8. **Single command to run all tests** (and one to build); make it trivial.
9. **Test the public behaviour,** not private internals; avoid heavy mocking of what you own.

## Quick check

- Can a newcomer tell what behaviour a test specifies from its name and body?
- Does a failure message point at the cause?
- Do tests pass in any order and on another machine?
- Is each boundary (empty, one, max, off-by-one, null) covered?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 9, "Unit Tests"; Ch. 17 heuristics T1-T9, E1, E2). Prentice Hall.
