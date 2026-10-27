# Iterator

**Intent.** Give sequential access to the elements of a collection without exposing how it is stored.

## Use when (code signals)
- Callers index into internals (`tree.nodes[i].children`) or depend on whether a collection is a list, tree or DB cursor.
- You need several simultaneous traversals, or different orders (pre-order, breadth-first, filtered) over one structure.
- Lazy or paged data (API pages, file lines, DB rows) should look like one stream.

## Don't use when
- The language's built-in `for` over a standard collection already does the job: write nothing.
- You need random access or bulk operations: expose them directly.
- Mutating the collection while iterating is required and unsafe: redesign (copy, or collect changes first).

## Participants & structure
Iterator (`next`, `has_next` / `done`) ; ConcreteIterator (tracks position) ; Aggregate (creates an iterator) ; ConcreteAggregate.
```
for x in aggregate:   # aggregate.iterator() hands out an independent cursor
```
External iterators are driven by the client; internal iterators take a callback (`forEach`).

## Consequences
+ Multiple independent traversals; new traversals without touching the collection.
+ Uniform interface across different collections.
- Robustness: modifying the collection mid-iteration may skip or repeat items. Fail fast or iterate a snapshot.
- Extra object per traversal.

## Implementation tips
- Prefer lazy generation so huge or infinite sequences work.
- Define behavior on concurrent modification (throw, snapshot) and document it.
- Recursive structures: keep an explicit stack in the iterator instead of recursion when depth may be large.
- Null/empty iterators simplify boundary conditions of trees.

## Language mapping
- Python: `__iter__` + generators (`yield`, `yield from`). JS/TS: `[Symbol.iterator]`, `function*`, `for...of`, async iterators.
- Java: `Iterable<T>`/`Iterator<T>`, `Stream`. C#: `IEnumerable<T>` + `yield return`, `IAsyncEnumerable`.
- Go: `iter.Seq[T]` and range-over-func (1.23+), or channels/callback `func(yield func(T) bool)`.

## Example (Python)
```python
class Tree:
    def __init__(self, v, kids=()): self.v, self.kids = v, list(kids)
    def __iter__(self):               # depth-first
        yield self.v
        for k in self.kids:
            yield from k

print(list(Tree(1, [Tree(2), Tree(3, [Tree(4)])])))  # [1, 2, 3, 4]
```

## Related
Composite (iterate recursive structures), Factory Method (polymorphic iterators), Memento (save iteration position), Visitor (alternative traversal with operations).

## Source
Gamma et al., 1995, p. 257.
