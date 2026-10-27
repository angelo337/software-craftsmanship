# Introduce Foreign Method

## Intent
Add a missing helper for a class you cannot modify by writing it in the client, taking the foreign object as its first argument.

## Use when
- A third-party, library or generated class lacks one or two operations you need.
- The same workaround expression appears repeatedly in a client.
- You want the gap to be visible and easy to relocate later.

## Don't use when
- You can edit the class: add the method there.
- You need many such methods or other classes need them too (use Local Extension).
- The helper needs state from the client class; then it is not a foreign method.

## Mechanics
1. Create a method in the client that does the job.
2. Make an instance of the server class its first parameter; pass anything else it needs as parameters, and avoid reading client state.
3. Mark it with a comment such as "foreign method, belongs on <Server>" so it is findable by text search.
4. Replace the repeated expressions with calls to it.

## Example (Python)
```python
# before
next_start = datetime(end.year, end.month, end.day) + timedelta(days=1)
# after
def next_day(d: datetime) -> datetime:
    # foreign method: belongs on datetime
    return d + timedelta(days=1)
next_start = next_day(end)
```

## Language notes
- C#: extension methods (`static T Foo(this Server s)`) are the built-in form. Kotlin and Swift have extension functions; Scala has implicit classes; Rust has extension traits.
- TS/JS: a standalone function or module augmentation (`declare module`) typing; prototype patching is possible but global and risky.
- Python: a plain module function. Monkey patching built-ins is not allowed and for other classes is global, order-dependent and invisible to type checkers; avoid it.
- Java: static helper in a utility class (as in this pattern). Go: a function taking the type, or a method on a local named type.

## Related
Introduce Local Extension (for several methods), Move Method (when the owner accepts it). Smells: Incomplete Library Class, Duplicated Code.

## Source
Fowler et al. (1999), Chapter 7 (Introduce Foreign Method).
