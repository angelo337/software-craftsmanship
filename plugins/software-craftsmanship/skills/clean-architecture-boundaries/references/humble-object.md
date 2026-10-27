# Humble Object, Presenters, Gateways

## Core statement
Split behavior that is hard to test from behavior that is easy to test. The hard part
(the humble object) is reduced to near-nothing; the logic moves to a testable object.
Architectural boundaries often fall exactly along this split, with a simple data
structure crossing it.

## Symptoms
- View or template code formats dates, money, or colors, and nobody can unit test it.
- Use cases contain SQL, or tests require a database to check a rule.
- Controllers decide business outcomes.
- Service handlers parse wire formats and apply rules in the same function.
- Test suites rely on screenshots or browser automation to verify formatting.

## How to apply
1. Find the code that touches the screen, disk, network, or framework.
2. Move every decision and format into a presenter (or interactor) that returns plain data.
3. Define a view model of strings, booleans, and enums: everything the screen shows,
   including button labels, disabled flags, and "negative" flags for coloring.
4. Make the view copy the view model to the screen with no logic.
5. For persistence, give use cases a gateway interface with intent-named methods; implement
   it in the database layer with SQL. That implementation and any ORM (a data mapper) are humble.
6. For services, humble listeners translate wire data into plain structures and back.
7. Test the presenter and interactors with stubs and doubles; test humble parts lightly.

## Example (Python)
```python
from dataclasses import dataclass

@dataclass
class BalanceVM:
    text: str
    negative: bool

def present_balance(cents: int) -> BalanceVM:      # testable
    sign = "-" if cents < 0 else ""
    return BalanceVM(f"{sign}${abs(cents) / 100:,.2f}", cents < 0)

def render(vm: BalanceVM) -> str:                   # humble: no decisions
    return f"[red]{vm.text}[/]" if vm.negative else vm.text

assert present_balance(-123456).text == "-$1,234.56"
```

## Language notes
- TypeScript/React: presenter is a pure function; component only maps view model to JSX.
- Python: pure function or class returning dataclass; keep Jinja templates free of logic.
- Any language: the view model holds only primitives so it needs no framework types.

## Common over-application
- Presenters for screens with no formatting or logic.
- View models that carry entities, so the view still decides things.
- Gateways per table instead of per use-case need, recreating the schema in the core.
- Heavy mocking of humble parts, which tests the mock rather than the system.

Source: Martin (2017), Ch. 23.
