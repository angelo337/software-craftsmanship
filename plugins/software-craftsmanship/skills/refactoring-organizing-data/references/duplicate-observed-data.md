# Duplicate Observed Data

## Intent
Keep a copy of data that currently lives only in a UI widget inside a domain object, and synchronize the two with an observer, so business logic can leave the UI class.

## Use when
- Business rules are tangled into a view/controller class because the data lives in controls.
- You need the logic testable without the GUI, or reusable by several views.
- Several views must show the same value.

## Don't use when
- Logic already lives in the model and views merely bind to it.
- A framework gives two-way binding or reactive state (use it instead of hand-rolled sync).
- The UI has no logic worth extracting.

## Mechanics
1. Make the presentation class an observer of a domain class; create the domain class and the link if absent.
2. Apply Self Encapsulate Field to the widget value inside the UI class and route all uses through the accessors.
3. In each UI event handler, call the setter with the widget's current value (read the widget directly, not via the getter) so user edits flow through it.
4. Add the field and accessors to the domain class, with the setter notifying observers; keep the same type as the UI (usually text) first.
5. Point the UI accessors at the domain field, and make the observer callback copy domain data into the widget using direct widget access (never the setter, to avoid recursion).
6. Test, repeat per field, then Move Method the calculations into the domain class.

## Example (Python)
```python
# before: logic reads the widgets
class Window:
    def on_start_change(self):
        self.length_box.set(int(self.end_box.get()) - int(self.start_box.get()))

# after: domain object owns data and notifies
class Interval:
    def __init__(self): self._end = "0"; self._observers = []
    def subscribe(self, fn): self._observers.append(fn)
    @property
    def end(self): return self._end
    @end.setter
    def end(self, v):
        self._end = v
        for fn in self._observers: fn()

class Window:
    def __init__(self):
        self.subject = Interval(); self.subject.subscribe(self.refresh)
    def on_end_edit(self): self.subject.end = self.end_box.get()
    def refresh(self): self.end_box.set(self.subject.end)  # direct widget write
```

## Language notes
- Python: callbacks, `Signal` libs, or Qt signals/slots; Tkinter `StringVar` traces.
- TypeScript/React: lift state into a store/model (Redux, MobX, signals) rather than hand-written observers.
- Java: `Observable`/`PropertyChangeSupport`; C#: `INotifyPropertyChanged`; Go: channels or callback slices.
- Always guard against feedback loops: write to the widget directly in the observer.

## Related refactorings and smells
- Self Encapsulate Field, Move Method, Extract Class, Change Unidirectional Association to Bidirectional.
- Smells: Divergent Change and Large Class in the GUI class; Feature Envy.

## Source
Fowler, Beck, Brant, Opdyke, Roberts (1999), *Refactoring: Improving the Design of Existing Code*, Chapter 8 "Organizing Data", section "Duplicate Observed Data". Page numbers were not reliably visible in the text extract.
