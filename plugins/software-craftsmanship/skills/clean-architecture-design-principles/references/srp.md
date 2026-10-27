# SRP: Single Responsibility Principle

## Core statement
A module should be responsible to one, and only one, actor. An actor is the group of people who would request a change for the same reason. The older wording, "one reason to change", means this. It is not "a module does one thing"; that advice applies to functions. "Module" is a source file or any cohesive set of functions and data; cohesion binds code serving a single actor.

## Symptoms in code
- Accidental duplication: two actors depend on a shared helper. A change requested by one silently alters results for the other.
- Merge collisions: unrelated teams edit the same file for unrelated reasons.
- Class whose methods map to different departments (finance rules, reporting format, persistence).
- Names like `Manager`, `Util`, `Service` that accumulate everything.
- Tests for one concern break when another concern changes.

## How to fix
1. List each method and write down who requests changes to it.
2. Group methods by actor.
3. Move each group to its own class/module; keep helper functions private to that group, even if that duplicates a few lines.
4. Share only a plain data structure (no behavior) among the groups.
5. If callers now juggle several classes, add a thin facade that only constructs and delegates.
6. Alternative: keep the most important rule beside the data and let that class act as the facade for the others.

```python
@dataclass
class EmployeeData: id: int; hours: list[float]; rate: float

class PayCalculator:               # finance actor
    def pay(self, e: EmployeeData) -> float:
        return sum(e.hours) * e.rate

class HoursReporter:               # HR actor: own copy of the rule
    def report(self, e: EmployeeData) -> str:
        return f"{e.id}: {sum(e.hours)}h"

class EmployeeRepository:          # DBA actor
    def save(self, e: EmployeeData): ...
```

## Language notes
- TypeScript/Python: modules and files are natural boundaries; a file per actor works well. Python mixins that stack unrelated duties are a smell.
- Private helpers inside each class are expected; a class can have many methods and still be single-actor.

## Common over-application
- One class per method, producing dozens of anemic classes.
- Splitting when only one actor exists and nothing is colliding.
- Treating "reason to change" as any technical change rather than a stakeholder group.
- Deduplicating code across actors "to stay DRY" is the very coupling SRP warns against; same-looking code with different owners is not true duplication.

## Related principles
OCP (needs SRP to separate axes of change), at component level the Common Closure Principle, at architecture level axes of change that create boundaries. Also pairs with Conway's law: structure reflects who asks for change.

## Source
Martin (2017), Ch. 7 (SRP).
