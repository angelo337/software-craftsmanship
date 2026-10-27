# Form Template Method

## Intent
When subclass methods run the same sequence of steps but each step differs, put the sequence once in the superclass and let subclasses supply only the steps.

## Use when
- Two methods in sibling classes have the same outline with different details (for example, text vs HTML report rendering).
- Adding another variant today means copying the whole method.

## Don't use when
- The steps themselves are not parallel; forcing hooks produces a confusing skeleton.
- Variation is better chosen at runtime: a strategy object or passed-in functions may fit better than inheritance.

## Mechanics
1. If the methods are not yet on sibling classes, first arrange that (for example, move each into a class in a new hierarchy).
2. Use Extract Method so each method splits into pieces that are either identical or completely different.
3. Pull up the identical pieces.
4. Rename the differing pieces so each step has the same signature in every subclass; test after each rename.
5. Pull up one of the original methods; declare the step signatures abstract on the superclass.
6. Delete the other copies, testing after each.

## Example (Python)
Before:
```python
class TextReport:
    def render(self, rows):
        return "REPORT\n" + "".join(f"- {r}\n" for r in rows)
class HtmlReport:
    def render(self, rows):
        return "<h1>REPORT</h1>" + "".join(f"<li>{r}</li>" for r in rows)
```
After:
```python
class Report:
    def render(self, rows):
        return self.header() + "".join(self.line(r) for r in rows)
class TextReport(Report):
    def header(self): return "REPORT\n"
    def line(self, r): return f"- {r}\n"
class HtmlReport(Report):
    def header(self): return "<h1>REPORT</h1>"
    def line(self, r): return f"<li>{r}</li>"
```

## Language notes
- Python: ABC with `@abstractmethod` hooks; functions as arguments are often a lighter alternative.
- TypeScript/Java/C#: abstract class with `protected abstract` steps; mark the template `final`/`sealed` if it must not be overridden.
- Go: no virtual dispatch from an embedded type, so pass an interface (the steps) into the shared function instead.

## Related
Pull Up Method, Extract Method, Rename Method, Replace Inheritance with Delegation (strategy alternative). Smell: Duplicated Code. Pattern: Template Method.

## Source
Fowler et al. (1999), Refactoring, ch. 11, pp. 281-288.
