# Command

**Intent.** Turn a request into an object so you can parameterize callers, queue or log requests, and support undo.

## Use when (code signals)
- Undo/redo, macro recording, transaction logs, "replay these actions".
- Menu items, buttons, hotkeys, CLI subcommands that all trigger the same operation.
- Jobs queued, scheduled, retried, or sent over the wire (task queues, job runners).
- The caller currently hard-codes `if action == "x": receiver.do_x(...)`.

## Don't use when
- You only need to pass behavior once, with no undo/queue/log: pass a function (closure).
- The object exists only to wrap a single method call with no extra state.
- Undo is required but state is large and undefined: consider Memento snapshots instead.

## Participants & structure
Command (execute, optional undo) -> ConcreteCommand (holds receiver + args) ; Invoker stores and fires commands ; Receiver does the real work ; Client wires them.
```
Client creates Cmd(receiver,args) -> Invoker.run(cmd) -> cmd.execute() -> receiver.action()
```

## Consequences
+ Invoker is decoupled from the operation's implementation.
+ Commands are first-class: store, compose (macro = Composite), serialize.
+ New commands need no change to existing code.
- One small class per action unless closures are used.
- Undo needs extra captured state; repeated undo/redo can drift if that state is incomplete.

## Implementation tips
- For undo, store what is needed to reverse (receiver, args, old values). Keep a history list; undo walks it backward, redo forward.
- Copy a command before pushing to history if its state changes per execution.
- Use a Memento when reversing by inverse operation is lossy.
- Make commands serializable if they cross process boundaries.

## Language mapping
- Python/JS/TS: a closure or `functools.partial`; use a small class only when you need `undo` or serialization.
- Java: `Runnable`/`Callable`/`Supplier`; C#: `Action`/`Func`, `ICommand` in WPF/MAUI.
- Go: `func()` values; struct with `Do()`/`Undo()` methods when undo is needed.

## Example (TypeScript)
```ts
interface Cmd { run(): void; undo(): void }
const insert = (doc: Doc, at: number, s: string): Cmd => ({
  run: () => doc.insert(at, s),
  undo: () => doc.remove(at, s.length),
});
const history: Cmd[] = [];
function exec(c: Cmd) { c.run(); history.push(c); }
function undo() { history.pop()?.undo(); }
```

## Related
Memento (undo state), Composite (macro commands), Prototype (copying commands), Strategy (swaps how; Command packages a what-to-do request).

## Source
Gamma et al., 1995, p. 233.
