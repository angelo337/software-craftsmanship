---
name: patterns-behavioral
description: Apply, detect, refactor toward, or design with the 11 GoF behavioral design patterns (Chain of Responsibility, Command, Interpreter, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor). Use whenever code has a long if/switch on type or state, interchangeable algorithms, event or notification systems, undo/redo or queued commands, request pipelines and middleware, custom traversal of collections, many objects that must coordinate, snapshots and restore, operations over object structures or ASTs, small grammars or DSLs, or an algorithm skeleton with hooks. Also trigger on "design pattern", "refactor this conditional", "patrón de comportamiento", "patrón observador", "patrón estrategia", "patrón estado", "patrón comando", "mediador", "visitante", "memento", "iterador". Use it even if the user never names a pattern but describes one of these problems.
---

# Behavioral design patterns (Gamma et al., 1995)

Behavioral patterns describe how objects share responsibility and communicate. Most of them encapsulate something that varies: an algorithm (Strategy), a state-dependent behavior (State), a protocol among objects (Mediator), a traversal (Iterator), a request (Command). Name what varies, put it behind an interface, and let the rest of the code depend on that interface.

In modern languages many patterns shrink to a language feature (a function, a generator, an event, a sum type). Check `references/language-mapping.md` before writing classes.

## Decision table: pick by problem

| Problem you have | Pattern | Cheapest first move |
|---|---|---|
| Several handlers, unknown which one acts; order matters | Chain of Responsibility | list of functions + loop |
| Need undo/redo, queue, log, schedule, or replay of actions | Command | closure; add `undo` only if needed |
| Evaluate expressions of a small language | Interpreter | existing parser/engine, else AST + `match` |
| Walk a collection without exposing its structure | Iterator | generator / `for...of` |
| Many peers tightly cross-referencing each other | Mediator | one coordinator object or store |
| Save and restore an object's state | Memento | immutable value: keep the old one |
| One change must update unknown number of dependents | Observer | callback list / event emitter |
| Behavior differs by lifecycle state, `switch(state)` repeats | State | enum + one `match`; classes if large |
| Swap an algorithm or policy | Strategy | pass a function |
| Same algorithm skeleton, a few steps vary | Template Method | higher-order function |
| Many operations over a stable set of node types | Visitor | sum type + exhaustive `match` |

### Confusable pairs
- **State vs Strategy.** Same structure (context delegates to an interchangeable object). Strategy: the client chooses the algorithm and it rarely changes during the object's life. State: the object switches its own behavior as it transitions, and states know about each other or the transition rules. Ask "who decides the swap?"
- **Observer vs Mediator.** Observer broadcasts one-to-many with no knowledge of reactions. Mediator centralizes many-to-many coordination logic (who enables what, in what order). Use Observer to notify, Mediator to decide.
- **Command vs Strategy.** Command is a request object (what to do, with args, possibly later/undoable/loggable). Strategy is an interchangeable how for one task. If you never queue, log, or undo, you are likely holding a Strategy or a plain callback.
- **Template Method vs Strategy.** Template varies steps via inheritance (fixed skeleton). Strategy swaps the whole algorithm via composition. Prefer composition when inheritance becomes awkward.
- **Visitor vs Interpreter.** Interpreter defines a grammar's evaluation inside nodes; Visitor puts operations outside the nodes. Combine them when you need many operations on one AST.
- **Chain of Responsibility vs Decorator.** A chain may stop early; a decorator always forwards.

## Workflow

Pick the mode matching the request, then open only the references you need.

### Mode A: detect in existing code
1. Scan for signals: type/state conditionals repeated in several functions, hand-written listener lists, `isinstance` chains, copy-paste algorithm skeletons, god-object coordinators, public fields read for undo.
2. Match each signal to the table, then open that pattern's reference and read "Use when" and "Don't use when".
3. Report: location, pattern or existing partial form, benefit, cost. Say "no pattern needed" when the code is fine.

### Mode B: refactor toward a pattern
1. Confirm there is pain (a second variation, repeated change, or test difficulty). One occurrence rarely justifies a pattern.
2. Cover the current behavior with a test before moving code.
3. Take the cheapest form from the table (function, generator, enum), and escalate to full classes only if state, undo, serialization, or multiple operations require it.
4. Move one branch/case at a time; keep tests green after each.
5. Delete the old conditional and its flags. Leaving both is the common failure.

### Mode C: design new
1. Write the varying aspect as a sentence: "this part changes when ...".
2. Choose by the decision table and read that reference's Participants, Consequences, Implementation tips.
3. Use the language-mapping section for the target language; follow its idiom.
4. Start with the simplest working shape and add pieces (undo, unsubscribe, default handler) when a requirement demands them.

## Warnings against over-use
- A pattern is a response to variation that exists today or is certain; "might need later" is not enough.
- Do not create an interface with one implementation or a class hierarchy for two cases.
- Do not translate the book's class diagram into languages with closures, generators, events, or sum types; use the language feature.
- Observer and Mediator both hide control flow: log events and keep cascades shallow, or debugging becomes hard.
- Visitor makes new node types expensive; State multiplies classes; Interpreter does not scale to big grammars; Memento can eat memory. Check the Consequences before committing.
- Name classes after the domain (`RefundPolicy`, `OrderState`), not the pattern, unless the pattern name aids reader.

## When to read each reference
Read the file only when that pattern is a candidate or the user asks about it.

- `references/chain-of-responsibility.md`: pipelines, middleware, escalation, "first handler that accepts".
- `references/command.md`: undo/redo, job queues, macros, action logs, menu/hotkey bindings.
- `references/interpreter.md`: rule/filter/query expressions, DSLs, small grammars.
- `references/iterator.md`: custom traversal, lazy or paged data, tree/graph walking.
- `references/mediator.md`: form/dialog/component coordination, chat-room style hubs.
- `references/memento.md`: snapshots, rollback, checkpoints, cancel/restore.
- `references/observer.md`: events, signals, pub/sub, reactive updates, data binding.
- `references/state.md`: lifecycle/workflow objects, protocols, repeated `switch(state)`.
- `references/strategy.md`: interchangeable algorithms, policies, pricing/sorting/validation variants.
- `references/template-method.md`: shared skeleton with hooks, framework extension points.
- `references/visitor.md`: operations over ASTs and document trees, type-switch chains.
- `references/language-mapping.md`: read first when the target language is Python, TS/JS, Java, C#, or Go.

Each reference ends with Related patterns and the source page (Gamma et al., 1995) for citation. Answer in the user's language (Spanish or English), and keep code identifiers in English.
