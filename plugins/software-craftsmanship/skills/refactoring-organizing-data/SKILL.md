---
name: refactoring-organizing-data
description: Refactor how data is represented and exposed, following Fowler's "Organizing Data" catalog (16 refactorings). Use this whenever code shows primitive obsession, magic numbers, public fields, getters that expose a mutable list/set/dict, type codes or status strings driving switch/if chains, arrays or tuples used as records, raw dicts from DB/JSON, data clumps, tangled two-way associations (back pointers), duplicated subclasses that only return constants, or domain data trapped in UI widgets. Trigger on "magic number", "type code", "encapsulate field", "encapsulate collection", "primitive obsession", "replace array with object", "value object", "enum instead of constants", "encapsular colección", "código de tipo", "número mágico", "objeto de valor", "campo público". Use even if the user does not name the refactoring.
---

# Organizing Data (Fowler et al., 1999, Ch. 8)

Purpose: pick and apply the right data-focused refactoring in small, test-backed steps. Each of the 16 refactorings has a detailed card in `references/`. Read the card only for the refactoring you chose, not all of them.

## Decision table: symptom -> refactoring

| Symptom | Refactoring | Card |
|---|---|---|
| Subclass must override or compute a field's value; need lazy/validated access; preparing a type-code move | Self Encapsulate Field | `self-encapsulate-field.md` |
| Primitive (string/number) is gaining formatting, validation, or extra attributes | Replace Data Value with Object | `replace-data-value-with-object.md` |
| Many equal copies of an entity must share state and changes | Change Value to Reference | `change-value-to-reference.md` |
| Shared small immutable object needs a registry just to be used | Change Reference to Value | `change-reference-to-value.md` |
| `row[0]`, `row[1]` with positional meaning | Replace Array with Object | `replace-array-with-object.md` |
| Business logic stuck in a UI class because the data lives in widgets | Duplicate Observed Data | `duplicate-observed-data.md` |
| Class B must reach the A objects that point at it | Change Unidirectional Association to Bidirectional | `change-unidirectional-association-to-bidirectional.md` |
| Back pointer causes bugs, leaks, or cyclic dependencies and is barely used | Change Bidirectional Association to Unidirectional | `change-bidirectional-association-to-unidirectional.md` |
| Unexplained literal such as `9.81` or `86400` | Replace Magic Number with Symbolic Constant | `replace-magic-number-with-symbolic-constant.md` |
| Public mutable field | Encapsulate Field | `encapsulate-field.md` |
| Getter returns the internal list/set/dict, or a setter replaces it | Encapsulate Collection | `encapsulate-collection.md` |
| Untyped dict/row/struct from DB, JSON or a legacy API | Replace Record with Data Class | `replace-record-with-data-class.md` |
| Type code, no behavior depends on it | Replace Type Code with Class | `replace-type-code-with-class.md` |
| Type code drives conditionals, fixed for the object's life | Replace Type Code with Subclasses | `replace-type-code-with-subclasses.md` |
| Type code drives conditionals and changes over time, or subclassing is taken | Replace Type Code with State/Strategy | `replace-type-code-with-state-strategy.md` |
| Subclasses differ only by methods returning constants | Replace Subclass with Fields | `replace-subclass-with-fields.md` |

## Type-code decision (ask in this order)

1. Does any `if/switch/match` branch on the code? If no -> **Class** (an enum is usually enough).
2. If yes, can the code change after the object is created? If yes -> **State/Strategy**.
3. If it is fixed, is the owner class already subclassed for another reason (or the language is single-inheritance and the slot is taken)? If yes -> **State/Strategy**.
4. Otherwise -> **Subclasses**.

After 2 or 4, follow with Replace Conditional with Polymorphism; the type-code step is scaffolding for it. Subclasses that later hold only constants are a signal to go back with Replace Subclass with Fields.

## Generic safe procedure

1. Confirm there are passing tests around the code. If not, write a characterization test first.
2. Find every use of the thing you will change (grep reads, writes, constructors, serialization, reflection, config, docs). Hidden uses are the usual cause of breakage.
3. Introduce the new structure beside the old one, then switch callers over one at a time; keep the old interface as a thin delegate until the last caller moves.
4. Run tests after every small step; revert a step rather than debug a big one.
5. Delete the old interface only when searches show zero callers.
6. Once data is encapsulated, look for logic in callers that wants to live on the new object (Move Method). Wrapping alone gives little value.
7. Do not mix this with behavior changes; commit the refactoring separately.

## When NOT to apply

- Throwaway scripts, or data that is intentionally a plain record (DTO, dataclass, config) with no invariants.
- Python/Ruby/C# properties exist: do not add accessors pre-emptively; a public attribute can become a property later without changing callers.
- When the framework already does it (ORM identity map and back references, reactive/two-way binding, generated models): use that, do not hand-roll.
- No tests and no way to get them, in code you do not own or understand: report the risk first.
- Sharing mutable objects across threads or services (Change Value to Reference) without a lifecycle owner.
- Do not wrap values only to wrap them: if no behavior, validation, or type safety results, skip it.

## Using the references

Open `references/<slug>.md` once you chose a refactoring; each has intent, when and when not, numbered mechanics, a short Python before/after, notes for Python/TS/Java/C#/Go, related refactorings and smells, and the source. For combos, typical order is: Encapsulate Field -> Encapsulate Collection -> Replace Data Value with Object -> Change Value to Reference (or back) -> type-code family.

## Output expectations

- Name the smell found and the refactoring chosen with a one-line reason.
- Show the change as small steps, each leaving the code working.
- Match the user's language (Spanish or English) and the project's conventions (naming, enum style, immutability).
