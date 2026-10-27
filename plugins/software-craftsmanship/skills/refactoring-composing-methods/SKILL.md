---
name: refactoring-composing-methods
description: Refactor long, tangled, or unclear methods into small, well-named ones using the Composing Methods catalog (Fowler et al., 1999, ch. 6). Use whenever a method is too long, has temporaries that are reused or hard to extract around, repeats code, contains dense expressions or comment-labelled blocks, reassigns its parameters, or uses a convoluted algorithm. Covers Extract Method, Inline Method, Inline Temp, Replace Temp with Query, Introduce Explaining Variable, Split Temporary Variable, Remove Assignments to Parameters, Replace Method with Method Object, Substitute Algorithm. Trigger on "extract method", "long method", "método largo", "extraer método", "simplificar método", "split this function", "too many temp variables", "clean up this function", even if the user does not name a refactoring.
---

# Composing Methods

Purpose: make methods small and clear so each reads like a short summary of intent. Most
problems come from long methods that bury information under tangled logic. The central move
is Extract Method; the other eight either prepare for it (remove temporaries, untangle
variables), undo it when it went too far (Inline Method), or replace a body wholesale.

## Symptom -> refactoring

| Symptom | Refactoring | Reference |
|---|---|---|
| Block of code needs a comment, or the method is long | Extract Method | references/extract-method.md |
| Method body says no more than its name; pointless delegation | Inline Method | references/inline-method.md |
| Temp holds a trivial expression and blocks another refactoring | Inline Temp | references/inline-temp.md |
| Temp holds an expression result and you want to extract around it | Replace Temp with Query | references/replace-temp-with-query.md |
| Dense expression or condition that is hard to read, extraction is awkward | Introduce Explaining Variable | references/introduce-explaining-variable.md |
| One temp reused for unrelated purposes (not a loop or accumulator) | Split Temporary Variable | references/split-temporary-variable.md |
| Parameter is overwritten inside the method | Remove Assignments to Parameters | references/remove-assignments-to-parameters.md |
| Many interdependent locals make extraction impossible | Replace Method with Method Object | references/replace-method-with-method-object.md |
| Whole algorithm is convoluted, or a library/simpler way exists | Substitute Algorithm | references/substitute-algorithm.md |

## Typical order of attack

1. Split Temporary Variable and Remove Assignments to Parameters (make each variable single-purpose).
2. Replace Temp with Query (or Inline Temp) to shrink the set of locals.
3. Extract Method repeatedly.
4. If locals still block you, Replace Method with Method Object, then keep extracting.
5. Once decomposed, consider Substitute Algorithm; Inline Method any extraction that did not earn its keep.

## Safe procedure (every refactoring)

1. Confirm tests pass before you start. No tests? Write a characterization test first, or stop and say so.
2. Make one small mechanical step. Small steps keep the failing step obvious.
3. Run the tests (or at least compile/lint/type-check) after each step.
4. If a test fails, revert that step rather than debugging a large diff.
5. Do not mix behavior changes into a refactoring commit; keep the observable behavior identical.
6. Prefer the IDE/tool's automated refactoring when it exists; it handles variable capture for you.
7. Name by intent (what, not how). If no better name than the code itself comes to mind, do not extract.

## When NOT to apply

- No test safety net and no way to check behavior: add tests first.
- Short is not the goal; clarity is. Do not extract when the name would be no clearer than the code.
- Do not inline a method that subclasses override or that is genuinely polymorphic.
- Do not remove a temp that is a loop variable or an accumulator by splitting it; those are legitimate multi-assignment uses.
- Do not worry about a temp-to-query rewrite costing performance until profiling says it matters; but do not apply it to expensive or side-effecting expressions blindly.
- Code that is about to be deleted or rewritten does not need polishing.

## Which reference to open

- Extracting a block, or handling locals read/modified by the block: extract-method.md
- Undoing needless indirection or preparing to re-extract: inline-method.md
- Temp assigned once to a simple expression, in the way: inline-temp.md
- Temp assigned once, want a reusable query: replace-temp-with-query.md
- Long arithmetic/boolean expression to annotate: introduce-explaining-variable.md
- Variable assigned twice for different meanings: split-temporary-variable.md
- `param = ...` inside a function: remove-assignments-to-parameters.md
- Extraction blocked by too many locals: replace-method-with-method-object.md
- Rewriting the algorithm itself: substitute-algorithm.md

Source: Fowler, Beck, Brant, Opdyke, Roberts (1999), Refactoring, chapter 6. Paraphrased; examples are original.
