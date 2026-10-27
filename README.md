# Software Craftsmanship for Claude Code

A Claude Code plugin that teaches Claude to write, review and refactor code the way two classic books describe it: **Clean Code** (Martin, 2009) and **Design Patterns** (Gamma et al., 1995, the "Gang of Four" or GoF).

It ships **13 skills**. Claude loads them automatically when your request matches a skill's description (for example "refactor this class", "which pattern fits here?", "review this PR"), so you rarely need to invoke them by hand. Skill descriptions also respond to Spanish phrases such as *código limpio*, *patrones de diseño* and *refactorizar*.

> The skills paraphrase the books. They do not reproduce book text or book code, and every code example is original. Buy the books for the full treatment.

---

## Contents

- [What you get](#what-you-get)
- [Features by skill](#features-by-skill)
  - [Clean Code (9 skills)](#clean-code-9-skills)
  - [Design Patterns (4 skills)](#design-patterns-4-skills)
- [Working modes](#working-modes)
- [Language support](#language-support)
- [Installation](#installation)
- [Usage examples](#usage-examples)
- [Update and uninstall](#update-and-uninstall)
- [Repository layout](#repository-layout)
- [Design principles of the plugin](#design-principles-of-the-plugin)
- [Limitations](#limitations)
- [References](#references)
- [License](#license)

---

## What you get

| Area | Skills | Main outcomes |
|---|---|---|
| Clean Code | 9 | Readable names, small single-purpose functions, honest comments, cohesive classes, explicit error handling, fast and readable tests, safer concurrency, a smell catalog for reviews and refactors |
| Design Patterns | 4 | Detect patterns in existing code, refactor toward the right one, or choose one for a new design, across all 23 GoF patterns |

---

## Features by skill

### Clean Code (9 skills)

#### `clean-code` (entry point and router)
- States the core principles: visible intent, small units that do one thing, no duplication, least surprise, no dead code, explicit failures.
- Defines a working loop: understand first, make it work, then make it clean, apply the Boy Scout rule, re-read as a stranger.
- Routes each situation to the right specialised skill (table of situations to skills).
- Ends every task with a final checklist covering names, functions, comments, smells, errors, tests and project conventions.

#### `clean-code-names`
- Rules for variables, functions, classes, modules and files: reveal intent, avoid disinformation, make meaningful distinctions, pronounceable and searchable names.
- Bans encodings (Hungarian notation, member prefixes), mental mapping, cute names and noise words such as `Manager`, `Data`, `Info`.
- One word per concept, no puns, solution-domain vs problem-domain vocabulary, meaningful context.
- Names must describe side effects (`getOrCreate`, not `get`) and match the abstraction level of the surrounding code.
- Quick pre-finish checklist for identifiers.

#### `clean-code-functions`
- Small functions that do one thing, at one level of abstraction, read top-down (stepdown rule).
- Argument guidance: prefer zero to two, justify three, avoid flag and output arguments, group related parameters.
- No hidden side effects; command-query separation; exceptions instead of error codes.
- Readable conditionals: encapsulate boolean logic, avoid negatives, name boundary arithmetic, replace magic numbers.
- Replace repeated switch/if chains with polymorphism; make temporal coupling explicit; remove duplication.
- Encourages writing a rough draft first and refining it with tests green.

#### `clean-code-comments-formatting`
- When a comment is worth writing (intent, warnings, legal headers, public API docs, tracked TODOs) and when to delete it (redundant, misleading, journal comments, banners, **commented-out code**).
- Advice to fix the code first (rename, extract) before reaching for a comment.
- Layout rules: newspaper-style file organisation, vertical openness and density, variables near use, callers above callees, sensible line length and indentation.
- Respect the team's formatter and linter; avoid unrelated reformatting in focused changes.

#### `clean-code-objects-classes`
- Objects vs data structures, avoiding hybrids; Law of Demeter and "train wreck" calls.
- Class design: small by responsibility, Single Responsibility Principle, high cohesion, open-closed organisation, standard member layout, tight interfaces.
- Warnings for feature envy, artificial coupling, misplaced responsibility, inappropriate statics, and base classes that know their subclasses.
- System design: separate construction from use, dependency injection, cross-cutting concerns outside domain classes, incremental architecture.
- The four simple-design rules in priority order (passes tests, no duplication, expressive, minimal).

#### `clean-code-errors-boundaries`
- Error handling: exceptions or idiomatic result types instead of return codes, try/catch structure first, error handling kept at one level, context-rich messages.
- Do not return or pass `null`; use empty collections, optionals or special-case objects; never swallow exceptions; validate at trust boundaries.
- Boundaries: wrap third-party and cross-team APIs behind your own interface, write learning tests, program against the interface you wish you had and adapt later.

#### `clean-code-tests`
- The three laws of TDD and the red-green-refactor rhythm.
- Test readability: arrange-act-assert, domain-specific helpers, one concept per test, behaviour-based names.
- F.I.R.S.T. (fast, independent, repeatable, self-validating, timely).
- Boundary coverage, coverage tools, exhaustive testing around found bugs, treating ignored tests as open questions, and one command to build and one to test.

#### `clean-code-concurrency`
- Concurrency as a separate responsibility; limit shared data, prefer immutability and thread-confined state.
- Use high-level primitives (executors, futures, channels, queues) before raw threads and locks; keep critical sections small; design shutdown early.
- Testing threaded code: run repeatedly, vary load and platforms, treat one-off failures as real bugs, instrument to expose ordering problems.

#### `clean-code-refactoring-smells`
- A safe refactoring procedure: pin behaviour with tests, understand, find smells, change one thing at a time, run tests after each step, stop when the code reads clearly.
- A review output format (location, smell code, why it hurts, concrete fix, severity) that separates must-fix from nice-to-have.
- **Smell catalog** in `references/smells-catalog.md`, with the book's codes: Comments (C1-C5), Environment (E1-E2), Functions (F1-F4), General (G1-G36), Java-specific (J1-J3), Names (N1-N7), Tests (T1-T9), plus guidance to adapt language-specific items.

### Design Patterns (4 skills)

#### `design-patterns` (entry point and router)
- Three modes: detect, refactor, design (see [Working modes](#working-modes)).
- A method that starts from the problem, not the pattern: name the force, shortlist candidates, check what the language already gives you, weigh the cost, apply minimally.
- Reference files:
  - `selection-by-problem.md`: problem to candidate patterns, plus the commonly confused pairs (Strategy vs State, Decorator vs Proxy vs Adapter vs Facade, Abstract Factory vs Factory Method vs Builder, Observer vs Mediator, Command vs Strategy, Template Method vs Strategy).
  - `detection-signals.md`: code smells that suggest each pattern, and cues for patterns already present (naming, framework features).
  - `language-mapping.md`: how each pattern collapses or changes in Python, TypeScript/JavaScript, Java/C# and Go.
  - `report-template.md`: output format for pattern reviews.
  - `source.md`: bibliography and the catalog with page numbers.
- Guardrails: no forcing a pattern, "no pattern needed" is a valid answer, prefer dependency injection over Singleton.

#### `patterns-creational` (5 patterns)
Abstract Factory, Builder, Factory Method, Prototype, Singleton.
- Decision table to choose among the five by problem.
- One reference file per pattern: intent, use-when signals, don't-use-when and cheaper alternatives, participants and structure, consequences, implementation tips, per-language mapping, a short original example, related patterns and book page.
- A creational language cheat sheet (for example builder as keyword arguments or options object, singleton as module instance or injection).

#### `patterns-structural` (7 patterns)
Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy.
- Decision table, including the Adapter / Decorator / Proxy / Facade distinction.
- One reference file per pattern with the same sections as above.
- A structural language cheat sheet (for example decorators and middleware, caching for Flyweight, dynamic proxies).

#### `patterns-behavioral` (11 patterns)
Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor.
- Decision table with the State/Strategy, Observer/Mediator and Command/Strategy distinctions.
- One reference file per pattern with the same sections as above.
- A behavioral language cheat sheet (for example Strategy as a function, Iterator as a generator, Observer as events or signals, Visitor as pattern matching on sum types).

---

## Working modes

| Mode | Trigger examples | What Claude does |
|---|---|---|
| **A. Detect** | "What patterns does this module use or need?" | Scans the code, reports patterns present (explicit and implicit) and recommended ones with evidence, cost and priority, and lists patterns considered and rejected |
| **B. Refactor** | "Replace this big switch", "decouple creation from use" | Applies small behaviour-preserving steps, with tests green after each one |
| **C. Design** | "Design a notification system", "how should I structure plugins?" | Names the force, picks the lightest option, sketches the participants, then writes idiomatic code |

For general code quality the `clean-code` skills follow a similar loop: understand, make it work, make it clean, verify, and report what changed.

---

## Language support

The guidance is language-neutral. Pattern skills include explicit mapping for **Python, TypeScript/JavaScript, Java, C# and Go**, and aim to produce the idiomatic form (a function, closure, generator, module or dependency injection) instead of a textbook class hierarchy when the language allows it. Claude answers in the language you write in.

---

## Installation

### From git (marketplace)

```bash
claude plugin marketplace add YOUR_USER/software-craftsmanship
claude plugin install software-craftsmanship@creangel-craftsmanship
```

Inside a Claude Code session: `/plugin marketplace add YOUR_USER/software-craftsmanship`, then `/plugin install software-craftsmanship@creangel-craftsmanship`. Any git URL works in place of `owner/repo`, including private repositories you can access.

### From a local folder

```bash
claude plugin marketplace add ./software-craftsmanship-marketplace
claude plugin install software-craftsmanship@creangel-craftsmanship
```

Try it without installing: `claude --plugin-dir ./software-craftsmanship-marketplace/plugins/software-craftsmanship`

### Plain skills (no plugin)

```bash
./install.sh              # personal: ~/.claude/skills
./install.sh --project    # current repo: .claude/skills (commit it to share)
./install.sh --uninstall  # remove
```
Windows: `.\install.ps1`, `.\install.ps1 -Project`, `.\install.ps1 -Uninstall`.
Or with the skills CLI (requires Node.js 22.20+): `npx skills add YOUR_USER/software-craftsmanship -a claude-code`.

Restart Claude Code (or start a new session) after installing. Run `claude plugin list` or `/skills` to confirm.

---

## Usage examples

Plugin skills are namespaced, for example `/software-craftsmanship:clean-code`, but Claude will usually pick them up on its own.

```text
Implement a CSV importer for orders with validation and tests.
→ clean-code, names, functions, errors-boundaries, tests

Review this pull request for code smells and tell me what to fix first.
→ clean-code-refactoring-smells (findings with smell codes and severity)

This 400-line class handles billing, emails and PDFs. Help me split it.
→ clean-code-objects-classes, then refactoring-smells

I have a giant switch on payment type that appears in five places.
→ design-patterns → patterns-behavioral (Strategy) or polymorphism

What design patterns does src/notifications use, and what is missing?
→ design-patterns (mode A) with a structured report

Design a plugin system where third parties add exporters.
→ design-patterns (mode C) → creational and behavioral skills

Explain the difference between Decorator and Proxy with an example in TypeScript.
→ patterns-structural
```

---

## Update and uninstall

```bash
claude plugin marketplace update creangel-craftsmanship
claude plugin uninstall software-craftsmanship@creangel-craftsmanship
claude plugin marketplace remove creangel-craftsmanship
```
Bump `version` in `plugins/software-craftsmanship/.claude-plugin/plugin.json` on every release so users receive updates.

---

## Repository layout

```text
software-craftsmanship-marketplace/
├── .claude-plugin/marketplace.json        # marketplace: creangel-craftsmanship
├── plugins/software-craftsmanship/
│   ├── .claude-plugin/plugin.json         # plugin manifest (v1.0.0)
│   └── skills/
│       ├── clean-code/                    # + 8 clean-code-* skills
│       ├── clean-code-refactoring-smells/references/smells-catalog.md
│       ├── design-patterns/references/    # selection, signals, language mapping, report, source
│       ├── patterns-creational/references/   # 5 pattern files + language mapping
│       ├── patterns-structural/references/   # 7 pattern files + language mapping
│       └── patterns-behavioral/references/   # 11 pattern files + language mapping
├── install.sh / install.ps1               # plain-skills installers
├── LICENSE
└── README.md
```

---

## Design principles of the plugin

- **Progressive disclosure:** each `SKILL.md` stays short; per-pattern and catalog details live in `references/` files that Claude reads only when needed, which keeps context small.
- **Triggering by description:** descriptions are written to fire on realistic requests (English and Spanish), including when the user does not name the skill.
- **Judgment over dogma:** both book families are heuristics. The skills tell Claude to follow the project's existing conventions, keep diffs focused and avoid over-engineering.

---

## Limitations

- The skills have been validated structurally (`claude plugin validate`, skill validator) and installation was tested, but **no with-skill vs baseline evaluation has been run yet**, so measured improvement is unproven.
- Part of the behavioral-pattern reference files was completed from general knowledge of the patterns after only a partial pass over the source text; review them against the book if exactness matters.
- Skills are written in English. Spanish triggers are included in descriptions, and Claude replies in your language.
- Java-specific heuristics from the Clean Code catalog are flagged for adaptation to other languages.

---

## References

- Martin, R. C. (2009). *Clean code: A handbook of agile software craftsmanship*. Prentice Hall.
- Gamma, E., Helm, R., Johnson, R., & Vlissides, J. (1995). *Design patterns: Elements of reusable object-oriented software*. Addison-Wesley.
- Fowler, M., Beck, K., Brant, J., Opdyke, W., & Roberts, D. (1999). *Refactoring: Improving the design of existing code*. Addison-Wesley.
- Anthropic. (n.d.). *Create and distribute a plugin marketplace*. Claude Code Docs. https://code.claude.com/docs/en/plugin-marketplaces

## License

MIT. See [LICENSE](LICENSE). The books themselves remain under their respective copyrights.
