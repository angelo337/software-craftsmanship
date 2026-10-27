# Frameworks Are Details

## Core statement
A framework is not your architecture. Its author solves their own problems, offers no commitment to you, and invites you to inherit from its classes everywhere. Use frameworks, but keep them in outer components that plug into your core; do not marry them. Where a marriage is unavoidable (language standard library), make it a deliberate decision.

## Symptoms
- Entities extend framework base classes or carry framework annotations.
- Business logic imports the framework in many files; upgrade guides become project plans.
- The team bends requirements to what the framework makes easy.
- Tests need the framework container to boot.
- Fear of upgrading or replacing it; the framework fights newer needs.

## How to apply
1. List framework imports in your core packages; the target is zero for entities and use cases.
2. Define your own core classes and interfaces. Where the framework needs its own types, create adapters or proxies in an outer component that translate.
3. Do dependency injection wiring in Main/composition root only; business objects receive collaborators via constructors.
4. Put framework-specific config, annotations, routes and serializers in plugin modules.
5. Delay adoption: begin with the plain version of the feature; adopt the framework piece once the need is proven.
6. Before a true marriage (ORM-heavy admin, batch engine), write down why and the cost of leaving.

## Example (Python)
```python
# core/pricing.py  - no framework imports
@dataclass
class Invoice:
    lines: list[Line]
    def total(self) -> Decimal: return sum(l.amount for l in self.lines)

# adapters/django_models.py - the framework side
class InvoiceRow(models.Model):
    data = models.JSONField()
    def to_domain(self) -> Invoice: return Invoice([Line(**l) for l in self.data["lines"]])
    @classmethod
    def from_domain(cls, inv: Invoice): return cls(data={"lines": [asdict(l) for l in inv.lines]})
```

## Language and framework notes
- Spring: use it to wire in Main/config; avoid autowiring annotations inside domain classes. Constructor injection keeps domain POJOs clean.
- Django/Rails: the active-record model is the framework's idea; for small apps accept it, for complex domains wrap it.
- Angular/React/Vue: keep business logic in plain modules/services without framework decorators where feasible.
- Standard library, STL, JVM: marry knowingly.

## Common over-application
- Hand-building what the framework does well in a throwaway app. Coupling is cheap if the app is short-lived.
- Wrapping every library call in your own interface. Protect against frameworks that shape your structure, not every utility (JSON parser, date helpers).
- Parallel hierarchies of identical classes when a thin mapper suffices.

## Source
Martin (2017), Ch. 32 Frameworks Are Details.
