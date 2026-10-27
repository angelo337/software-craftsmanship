# Factory Method (Class Creational)

## Intent
Declare an operation for creating an object, and let subclasses choose which concrete class it returns. A class defers instantiation to its subclasses. Also known as Virtual Constructor.

## Use when (code signals)
- Framework or base-class code needs to create objects whose concrete type only the application/subclass knows (`Application.open()` must make a `Document`).
- A `switch`/`if` on a type tag instantiates different classes inside a method that otherwise stays the same.
- A base class has a template of steps and one step is "make the helper object" (parser, dialog, connection).
- Two class hierarchies run in parallel and one must make instances of the other (figure -> its manipulator).

## Don't use when / cheaper alternative
- The class instantiated never changes: call the constructor.
- Creation happens in an overridable init method already.
- Variation is by value, not type: pass a parameter.
- Cheaper: inject a factory function/callable or the class itself (first-class functions/classes make subclassing unnecessary).
- Forcing clients to subclass the creator only to change the product adds a needless extension point.

## Participants & structure
- Product: interface of the objects the factory method returns.
- ConcreteProduct: implements Product.
- Creator: declares the factory method (maybe with a default implementation) and uses it inside its own logic.
- ConcreteCreator: overrides the factory method to return a ConcreteProduct.

```
Creator.operation() { p = self.factory_method(); p.use() }
Creator.factory_method() -> Product        (abstract or default)
ConcreteCreator.factory_method() -> ConcreteProduct
```
The creator relies on subclasses to supply the right product.

## Consequences
Benefits:
- Application-specific classes are not baked into framework code; it deals only with Product.
- Gives subclasses a hook: creating through an overridable method is more flexible than direct instantiation, and a default implementation gives sensible fallback (e.g. a default file dialog).
- Connects parallel hierarchies by localizing which classes belong together.
Liabilities:
- You may need a new Creator subclass just to change the product class; changes can cascade when the creator is itself made by a factory method.

## Implementation tips
- Two flavors: abstract creator (subclasses must implement; no sensible default) and concrete creator with a default (flexibility hook). Prefer the default when a reasonable one exists.
- Parameterized factory method: pass a key to select among several products sharing one interface; subclasses override to add or remap keys and delegate unknown keys to the parent.
- Do not call the factory method from the creator's constructor: the subclass override may not be ready (in C++/Java the subclass state is not initialized). Use lazy creation through an accessor.
- Where classes are objects, return the class (or a callable) instead of an instance, or store it in a field so no subclass is needed.
- Name factory methods clearly (`create_x`, `make_x`, `of`, `from_`); static named constructors are a related but non-polymorphic idiom.
- Factory methods are usually called from template methods.

## Language mapping
- Python: a plain function, `@classmethod` alternative constructor, or `dict[str, type]` registry; pass the class as an argument.
- TypeScript/JavaScript: a function returning an object, or a `Map<string, () => Product>`; subclass overriding only when a class framework already exists.
- Java: abstract/overridable method, static factory method (`List.of`), or `Supplier<T>`.
- C#: virtual method, static factory, `Func<T>`, or DI-registered factory.
- Go: no inheritance; a constructor function `NewX()` returning an interface, or a function-typed field.
See [language-mapping.md](language-mapping.md).

## Short example (Python)
```python
class Exporter:
    def make_writer(self):              # factory method with a default
        return CsvWriter()
    def export(self, rows):             # template: logic stays fixed
        w = self.make_writer()
        for r in rows: w.write(r)
        return w.close()

class JsonExporter(Exporter):
    def make_writer(self):              # subclass picks the product
        return JsonWriter()
```

## Related patterns
- Abstract Factory: often built from several factory methods.
- Template Method: factory methods are typically called inside one.
- Prototype: avoids subclassing the creator, but needs an initialize step on the product.

## Source
Gamma et al., 1995, Design Patterns, p. 107-116 (Related Patterns p. 116; discussion p. 135-136).
