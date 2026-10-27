# Separate Query from Modifier

## Intent
Split a method that both returns a value and changes observable state into a pure query and a command, so queries can be called freely and commands are explicit.

## Use when
- A getter-looking method mutates state (pops, increments, sends, logs to an audit table, marks as read).
- Callers hesitate to call a method twice or reorder calls because of hidden effects.
- You want to test the answer without triggering the effect (or vice versa).

## Don't use when
- The only state change is an unobservable optimization such as a cache: queries may still memoize.
- The operation must be atomic (pop from a queue, compare-and-set, ID allocation) in concurrent code: keep an atomic combined operation, built from the two parts, as a third method.
- The effect is the entire point and the return value is only a status: consider Replace Error Code with Exception instead.

## Mechanics
1. Create a query that returns what the original returns, without side effects. If the result is a local variable, find where it is assigned.
2. Change the original so every return statement returns the query's result.
3. Run tests.
4. At each call site, replace the single call with two: the original (for its effect) followed by the query (for the value). Test after each.
5. Change the original's return type to void/None and remove its return expressions.
6. Rename the original to reflect that it is a command; if it now duplicates the query's logic, simplify it to call the query.

## Example (Python)
```python
# Before: returns the next ticket AND advances the counter
class Dispenser:
    def next_ticket(self):
        self._n += 1
        return self._n

# After
class Dispenser:
    def current_ticket(self):          # query, safe to repeat
        return self._n

    def advance(self):                 # command
        self._n += 1

# caller: d.advance(); t = d.current_ticket()
# atomic variant under threads:
#   with self._lock: self.advance(); return self.current_ticket()
```

## Language notes
- Python: iterators (`next()`), `dict.pop`, `list.pop` are deliberate query-modifiers; do not "fix" idioms from the standard library. For your own APIs use `@property` only for pure queries.
- TypeScript: mark queries as `readonly`-friendly getters; avoid effects in `get` accessors.
- Java: `Iterator.next()` and `Queue.poll()` are known exceptions; for concurrent code keep a `synchronized` combined method or use `AtomicInteger.incrementAndGet`.
- C#: properties with side effects are especially surprising; make them methods. `Interlocked` for atomic variants.
- Go: use a pure method for the query and a method with pointer receiver for the command; guard combined operation with `sync.Mutex`.

## Related
- Rename Method (name the command), Hide Method (make the unsynchronized halves non-public), Substitute Algorithm (remove duplicated logic between the two).
- Smells: Duplicated Code after the split, Temporary Field.
- Principle: command-query separation.

## Source
Fowler et al., 1999, Refactoring, Ch. 10, p. 226.
