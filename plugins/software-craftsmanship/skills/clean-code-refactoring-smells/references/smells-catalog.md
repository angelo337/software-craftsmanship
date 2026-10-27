# Smells and heuristics catalog (paraphrased)

Codes follow Chapter 17 of Martin (2009) so findings can be cited precisely.

## Contents
- Comments (C1-C5)
- Environment (E1-E2)
- Functions (F1-F4)
- General (G1-G36)
- Java-specific (J1-J3)
- Names (N1-N7)
- Tests (T1-T9)

## Comments
- **C1 Inappropriate information:** metadata (authors, dates, ticket numbers, history) belongs in version control/tracker, not comments.
- **C2 Obsolete comment:** outdated or wrong; update or delete at once.
- **C3 Redundant comment:** restates what the code already says.
- **C4 Poorly written comment:** if worth writing, write it well: brief, correct, precise.
- **C5 Commented-out code:** delete it.

## Environment
- **E1 Build requires more than one step:** one command to build.
- **E2 Tests require more than one step:** one command to run all tests.

## Functions
- **F1 Too many arguments:** prefer 0-2; avoid >3.
- **F2 Output arguments:** return values or change the owner's state instead.
- **F3 Flag arguments:** a boolean means two behaviours; split.
- **F4 Dead function:** never called; delete.

## General
- **G1 Multiple languages in one file:** minimise embedded languages.
- **G2 Obvious behaviour unimplemented:** violates least surprise (e.g. a day parser that ignores case/abbreviations).
- **G3 Incorrect behaviour at the boundaries:** test every corner case; don't trust intuition.
- **G4 Overridden safeties:** disabled warnings, skipped failing tests, forced casts.
- **G5 Duplication:** identical blocks, repeated switch/if chains (use polymorphism), similar algorithms (template/strategy).
- **G6 Code at wrong level of abstraction:** high-level concepts in base, low-level in derivatives; no leakage.
- **G7 Base classes depending on derivatives:** base should not know subclasses.
- **G8 Too much information:** keep interfaces small and tight; hide data and helpers.
- **G9 Dead code:** unreachable branches, unused catch blocks; delete.
- **G10 Vertical separation:** define variables/private functions near their use.
- **G11 Inconsistency:** same thing done the same way, same names for same concepts.
- **G12 Clutter:** empty constructors, unused variables/imports, noise comments.
- **G13 Artificial coupling:** things placed together for convenience (general enums inside specific classes).
- **G14 Feature envy:** a method uses another object's data more than its own; move it (exception: formatting/view separation).
- **G15 Selector arguments:** a flag/enum parameter that picks behaviour; split into functions.
- **G16 Obscured intent:** run-on expressions, Hungarian notation, magic numbers.
- **G17 Misplaced responsibility:** put code where readers would look for it.
- **G18 Inappropriate static:** prefer instance methods unless polymorphism is impossible.
- **G19 Use explanatory variables:** name intermediate results.
- **G20 Function names should say what they do:** including whether it mutates.
- **G21 Understand the algorithm:** passing tests is not understanding; refactor until it is obvious.
- **G22 Make logical dependencies physical:** ask the other module for what you assume (e.g. page size) instead of hard-coding.
- **G23 Prefer polymorphism to if/else or switch/case:** at most one switch per type selection, in a factory.
- **G24 Follow standard conventions:** team style from industry norms.
- **G25 Replace magic numbers with named constants:** exceptions for universally obvious values.
- **G26 Be precise:** check nulls, multiple matches, use integer/decimal types for money, lock concurrent updates; use the least constraining type.
- **G27 Structure over convention:** enforce rules with types/abstract methods rather than naming conventions.
- **G28 Encapsulate conditionals:** extract intent-named predicates.
- **G29 Avoid negative conditionals.**
- **G30 Functions should do one thing.**
- **G31 Hidden temporal couplings:** make call order explicit by data flow.
- **G32 Don't be arbitrary:** structure should have a reason that the code communicates.
- **G33 Encapsulate boundary conditions:** name `+1`/`-1` computations once.
- **G34 Functions should descend only one level of abstraction.**
- **G35 Keep configurable data at high levels:** defaults/config live at the top and are passed down.
- **G36 Avoid transitive navigation:** Law of Demeter; `a.getB().getC()` is a smell.

## Java-specific (adapt to your language)
- **J1** Avoid long import lists (use wildcard/package imports where the language allows and the team agrees).
- **J2** Don't inherit constants; import them.
- **J3** Prefer enums to integer constants.

## Names
- **N1** Choose descriptive names; **N2** names at the right abstraction level; **N3** use standard nomenclature and the project's ubiquitous language; **N4** unambiguous names; **N5** longer names for longer scopes; **N6** avoid encodings; **N7** names describe side effects.

## Tests
- **T1** Insufficient tests; **T2** use a coverage tool; **T3** don't skip trivial tests; **T4** an ignored test is a question about requirements; **T5** test boundary conditions; **T6** exhaustively test near bugs; **T7** patterns of failure are revealing; **T8** coverage patterns are revealing; **T9** tests should be fast.

Source: Martin, R. C. (2009). *Clean code: A handbook of agile software craftsmanship*. Prentice Hall.
