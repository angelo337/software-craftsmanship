# Composite

## Intent
Arrange objects into trees representing part-whole hierarchies, and let clients treat a single object and a group of objects through the same interface.

## Use when
- Data is naturally a tree: files/folders, UI widgets, org charts, menus, ASTs, bill of materials, nested permissions or rules.
- Client code branches on "is this a group or an item?" (`isinstance(x, list)`, `if node.children`), repeated across functions.
- An operation (total size, price, render, validate, count) must apply to a leaf and to any nested group in the same way.
- New node kinds should work with existing traversal code.

## Don't use when / cheaper alternative
- Structure is flat or depth is fixed: a list or dict is enough.
- Leaves and groups have truly different operations and clients must tell them apart: use a tagged union/sum type with pattern matching.
- You need to restrict which children a node may hold and want compile-time enforcement; Composite makes that a runtime check.
- Operations vary far more than node types: add Visitor, or externalize traversal.

## Participants & structure
Component (common interface; default behavior), Leaf (no children), Composite (stores children, implements the operation by forwarding to them, often adding its own work), Client (talks only to Component).

```
Component <|-- Leaf
Component <|-- Composite --has many--> Component
```

## Consequences
- Uniform client code; recursion replaces type-switch functions.
- Easy to add new node kinds.
- Design can become too general: constraints on allowed children are runtime checks.
- Transparency vs safety trade-off for `add/remove` (see tips).

## Implementation tips
- Decide where child management lives. Root of the hierarchy: uniform but leaves expose meaningless `add` (make it raise a clear error). Only on Composite: type-safe but clients must distinguish. Choose consciously and document.
- Give Component a default "no children" iteration so leaves need no special case.
- Parent pointers help upward traversal and removal; update them only inside add/remove to keep the invariant.
- Do not store the child list in the base class if leaves are numerous; it wastes space.
- Cache costly aggregates (bounding box, total) in composites and invalidate up the parents on change.
- Preserve child order when it matters (z-order, statement order); pair with Iterator for traversal.
- Shared leaves (Flyweight) cannot keep a parent reference.

## Language mapping
- Python: ABC or Protocol plus a class holding `list`; `__iter__` for traversal; recursion with generators (`yield from`). `os.walk`/`pathlib` hide a composite.
- TypeScript/JavaScript: discriminated unions (`type Node = Leaf | Group`) with a recursive function are often lighter than classes; DOM nodes are a canonical Composite.
- Java: abstract class/interface; `java.awt.Container`/`Component`, Swing, and `Path` trees. Records + sealed interfaces enable exhaustive switches.
- C#: interface with `IEnumerable<T>` children; WPF/WinForms controls are composites.
- Go: interface type with `Children() []Node`; leaf returns nil. Recursion via a plain function over the interface.

## Example (Python)
```python
class Item:
    def __init__(self, price): self.price = price
    def total(self): return self.price

class Bundle:
    def __init__(self, *parts): self.parts = list(parts)
    def total(self): return sum(p.total() for p in self.parts)

order = Bundle(Item(5), Bundle(Item(3), Item(2)))
assert order.total() == 10
```

## Related patterns
Decorator (a degenerate one-child composite whose goal is embellishment; commonly combined). Flyweight (share leaves). Iterator (traverse). Visitor (add operations without touching node classes). Chain of Responsibility (uses parent links).

## Source
Gamma et al., 1995, Design Patterns, p. 163.
