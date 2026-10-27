# Observer

**Intent.** Define a one-to-many dependency so that when one object changes, all its dependents are notified automatically.

## Use when (code signals)
- Code that manually calls several "refresh/update/notify" methods after each state change.
- A model must stay independent from its views, caches, loggers, or analytics.
- Event emitters, pub/sub, reactive UI, domain events, webhooks, data binding.
- You do not know in advance how many parties care about a change.

## Don't use when
- One known dependent: call it directly.
- Subscribers must coordinate or order their reactions: use Mediator or an explicit workflow.
- Cross-process delivery with durability: use a message broker, not in-memory observers.
- Cascades of updates become hard to trace: prefer explicit data flow.

## Participants & structure
Subject (attach / detach / notify) ; Observer (`update`) ; ConcreteSubject (state, notifies on change) ; ConcreteObserver (reads state, reacts).
```
subject.set(x) -> notify() -> each observer.update(subject or payload)
```
Push model sends the data; pull model sends a reference and observers query.

## Consequences
+ Subject and observers are loosely coupled; broadcast with open-ended subscribers.
- Unexpected cascading updates: observers do not know about each other, and a small change can trigger costly refreshes.
- Memory leaks from forgotten subscriptions (lapsed listener problem).
- Notification during unfinished state change gives observers inconsistent data.

## Implementation tips
- Notify only after the subject's state is consistent.
- Return an unsubscribe handle from `subscribe` and call it on teardown.
- Batch or debounce notifications for multi-step updates; let observers subscribe to specific events or aspects.
- Decide push versus pull; pull keeps the subject unaware of observer needs.
- Iterate over a copy of the subscriber list to allow unsubscribe during notify.

## Language mapping
- Python: callback list, `blinker`/signals, `asyncio` events; JS/TS: `EventTarget`, `EventEmitter`, RxJS `Observable`, signals (Solid/Angular/Preact), `Proxy`-based reactivity.
- Java: `PropertyChangeListener`, `Flow.Publisher`, Reactor/RxJava (`java.util.Observable` is deprecated). C#: `event` + delegates, `IObservable<T>`, `INotifyPropertyChanged`.
- Go: channels or a slice of `func(T)`; fan-out with goroutines.

## Example (TypeScript)
```ts
class Signal<T> {
  private subs = new Set<(v: T) => void>();
  constructor(private v: T) {}
  get() { return this.v; }
  set(v: T) { this.v = v; [...this.subs].forEach(f => f(v)); }
  subscribe(f: (v: T) => void) { this.subs.add(f); return () => this.subs.delete(f); }
}
```

## Related
Mediator (coordinates versus broadcasts), Singleton (global change manager), Command (events as objects).

## Source
Gamma et al., 1995, p. 293.
