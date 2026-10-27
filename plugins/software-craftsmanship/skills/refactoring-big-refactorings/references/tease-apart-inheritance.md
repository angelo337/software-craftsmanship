# Tease Apart Inheritance

## Intent
Split one inheritance hierarchy that is doing two jobs into two hierarchies, linked by delegation.

## Use when
- Subclasses at one level share an adjective or prefix (`Tabular*`, `Legacy*`, per-country subclasses of per-type subclasses): a grid of variation compressed into one tree.
- Adding a new variation on one axis forces new subclasses under every node on the other axis.
- Logic for two concerns (for example deal type and presentation style) is tangled, and strategies for one problem are scattered across the tree.

## Don't use when
- There is only one real axis of variation.
- Variations are few and stable; the extra indirection would cost more than it saves.

## Mechanics
1. Identify the jobs the hierarchy performs. Draw a grid (two or more dimensions) with each job on an axis; treat additional dimensions with repeated passes, one at a time.
2. Decide which job stays in the current hierarchy (usually the more important one, or the one with more code, so less moves).
3. At the common superclass, Extract Class for the secondary job and hold it in a field.
4. Create subclasses of the extracted class that mirror the original subclasses; initialize the field to the right one in each original subclass's constructor.
5. Move Method and Move Field from each original subclass into its counterpart in the new hierarchy.
6. When an original subclass has no code left, delete it. Continue until all those subclasses are gone.
7. Simplify the new hierarchy: often differences collapse into a few fields, so subclasses may vanish too. Apply Pull Up Method/Field where useful.

## Tips
- Expect more classes midway; simplification comes after separation.
- Work one subclass at a time with tests green.

## Language notes
- Python/TS/Go: the secondary job often becomes a strategy object, a function table, or a Protocol/interface instead of a class hierarchy.
- Java/C#: the extracted hierarchy is typically an interface with implementations injected in the constructor.

## Related
Extract Class, Move Method, Move Field, Replace Inheritance with Delegation, Replace Type Code with State/Strategy; smells: Parallel Inheritance Hierarchies, Divergent Change.

Source: Fowler et al. (1999), Ch. 12.
