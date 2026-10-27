# Interpreter

**Intent.** Represent a small language's grammar as a class hierarchy and evaluate sentences by walking the resulting tree.

## Use when (code signals)
- A recurring problem can be stated as sentences in a simple language: filter expressions, rule engines, search queries, pricing formulas, routing rules.
- Users or config files supply expressions that must be evaluated safely.
- Grammar is small (a handful of productions) and efficiency is not critical.

## Don't use when
- The grammar is large or evolving: use a parser generator (ANTLR, PEG, Lark) or an existing engine.
- A fixed set of options suffices: use data (dicts, enums) plus Strategy.
- Performance matters: compile to bytecode or closures instead of re-walking trees.
- A standard format exists (JSON Logic, regex, SQL, CEL): reuse it rather than invent one.

## Participants & structure
AbstractExpression (`interpret(context)`) ; TerminalExpression (literals, variables) ; NonterminalExpression (holds sub-expressions, e.g. And, Or, Add) ; Context (variable bindings/state) ; Client builds the tree (often from a parser).
```
And( Eq(var "age", 18), Not( Eq(var "banned", true) ) )   evaluated recursively
```

## Consequences
+ Grammar is easy to change and extend: one class per rule.
+ Tree is plain Composite, so it can be printed, optimized, visited.
- Class count grows fast; complex grammars become unmanageable.
- Parsing is NOT part of the pattern; you still need a parser or builder.

## Implementation tips
- Keep the tree immutable and pass variable bindings via Context so one tree is reusable.
- Add new operations (pretty-print, type-check, optimize) via Visitor rather than more methods on every node.
- Share identical terminal nodes (Flyweight) if memory matters.
- Cap recursion depth and reject unknown symbols when input is untrusted.

## Language mapping
- Python/TS: dataclasses/ADTs plus `match`/switch eval function; or closures built by a compile step.
- Java: sealed interfaces + records + pattern-matching `switch`; C#: records + `switch` expressions; `System.Linq.Expressions` is a ready interpreter tree.
- Go: interface with `Eval(env) any`, or a type switch.

## Example (Python)
```python
from dataclasses import dataclass
@dataclass
class Var: name: str
@dataclass
class And: l: object; r: object
@dataclass
class Gt: l: object; r: int

def ev(e, env):
    match e:
        case Var(n): return env[n]
        case Gt(l, r): return ev(l, env) > r
        case And(l, r): return ev(l, env) and ev(r, env)
```

## Related
Composite (the tree), Visitor (operations over nodes), Iterator (traversal), Flyweight (shared terminals).

## Source
Gamma et al., 1995, p. 243.
