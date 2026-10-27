# Mediator

**Intent.** Put the interaction logic of a group of objects into one object, so the members no longer refer to each other directly.

## Use when (code signals)
- Many-to-many references: each widget/service/component calls several others and changing one forces edits in many.
- Form dialogs where enabling/disabling/validating fields depends on other fields.
- Chat rooms, air-traffic style coordination, workflow orchestrators, UI state coordinators.
- Components cannot be reused elsewhere because they know too much about their neighbors.

## Don't use when
- Only two objects talk: a direct call or Observer is simpler.
- Interaction is one-to-many notification with no coordination logic: use Observer.
- The mediator would become a god object holding unrelated rules: split by feature or use events.

## Participants & structure
Mediator (interface) ; ConcreteMediator (knows colleagues, implements coordination) ; Colleagues (each knows only the mediator and reports changes to it).
```
A -> M <- B        A notifies M; M decides what B and C should do
     ^
     C
```

## Consequences
+ Colleagues become reusable and decoupled; many-to-many becomes one-to-many.
+ Control logic lives in one place.
- Centralized logic can grow into a monolith that is hard to maintain.

## Implementation tips
- Omit the abstract Mediator if colleagues only ever work with one mediator.
- Colleagues report with a generic `changed(self)` or typed events; the mediator reads their state. Choose events if colleagues are heterogeneous.
- Observer is a common transport: colleagues publish, the mediator subscribes.
- Keep the mediator thin: coordination only, domain rules stay in colleagues.

## Language mapping
- Python/JS/TS: a controller class or event bus; in UI frameworks, a parent component or store (Redux/Pinia/state hooks) is the mediator.
- Java: `java.util.Timer`-like coordinators, Spring `ApplicationEventPublisher`, MediatR-style libraries. C#: MediatR library.
- Go: a goroutine owning state and receiving messages over channels (actor style).

## Example (TypeScript)
```ts
class SignupForm {
  constructor(private email: Input, private submit: Button, private terms: Checkbox) {
    [email, terms].forEach(c => c.onChange(() => this.refresh()));
  }
  refresh() { this.submit.enabled = this.email.valid && this.terms.checked; }
}
```

## Related
Observer (transport; broadcasts versus coordinates), Facade (one-way simplification of a subsystem; mediator is multi-directional), Colleagues may use Observer.

## Source
Gamma et al., 1995, p. 273.
