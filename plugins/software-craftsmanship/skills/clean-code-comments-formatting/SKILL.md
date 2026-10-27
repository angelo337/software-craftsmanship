---
name: clean-code-comments-formatting
description: Decide when to comment and how to lay out code following Clean Code (Comments, Formatting). Use whenever you add, review or remove comments or docstrings, find commented-out code, TODOs, change histories, or noisy headers; and when organising a file, ordering functions, vertical spacing, line length, indentation, and team style. Triggers on "comment this", "documentar", "docstring", "formatting", "style", "layout", "linter".
---

# Comments and formatting

## Comments

A comment is an apology for failing to express yourself in code. Try to fix the code first (better name, extracted function); comment only what code cannot say. Comments rot because they are not compiled or tested.

**Good comments (use sparingly)**
- Legal/licence headers where required.
- Explanation of intent or a non-obvious decision ("why", not "what").
- Clarifying an opaque value you cannot rename (e.g. a library return value).
- Warning of consequences ("slow: ~10 min on full data set").
- `TODO` for work that is genuinely pending, and then track it; scan and clear them regularly.
- Amplifying the importance of something that looks trivial but is not.
- Public API docs for code consumed by others, and then written carefully and kept accurate.

**Bad comments (delete or fix)**
- Mumbling, redundant or noisy comments that restate the code (`i++; // increment i`, empty docstrings that echo the signature).
- Misleading or obsolete comments.
- Mandated comments on every function/variable (they add noise).
- Journal/change-log comments, bylines, "added by", closing-brace comments, position markers, banners. Version control has that data.
- **Commented-out code: delete it.** Version control remembers.
- Comments that stand in for a good name or a function (`// check if employee is eligible` → `employee.isEligibleForBenefits()`).
- Too much information, historical trivia, rambling, or nonlocal information describing something other than the adjacent code.

Rule of thumb: if you are about to write a comment, first try renaming or extracting; keep the comment only if the code still cannot carry the meaning.

## Formatting

Formatting is communication; it also sets expectations for the team.

- **File size:** prefer small files (a few hundred lines is a good ceiling; typical files are far smaller). A file should read like a newspaper article: name and high-level concepts first, details further down.
- **Vertical openness:** blank lines separate distinct concepts (imports, functions, groups). **Vertical density:** keep tightly related lines together with no blank lines or noisy comments between.
- **Vertical distance:** declare variables close to their first use (local vars at the top of tiny functions, loop counters inside the loop). Put a called function below its caller. Related functions (same naming, same operation, one calling the other) sit close together. Instance variables go in one consistent place.
- **Horizontal:** keep lines short (≈100-120 chars max). Use whitespace around operators to show precedence and association; do not align columns of declarations with padding. Indent consistently to show scope; never collapse a short block into one line to dodge indentation.
- **Team rules:** one agreed style beats personal taste. Use the project's formatter/linter and let it decide; do not reformat unrelated code in a focused change.
- Prefer one language per source file where practical, and keep embedded snippets (SQL, HTML, regex) minimal and isolated.

## Source

Martin, R. C. (2009). *Clean code* (Ch. 4, "Comments"; Ch. 5, "Formatting"; Ch. 17 heuristics C1-C5, G10, G11, G12, G24). Prentice Hall.
