# Case Study: Video Sales

## Core statement
Start architecture from actors and use cases, then partition into components along two axes: actors (reasons to change, via SRP) and policy level (rates of change, via the Dependency Rule). Preserve the freedom to bundle components into deployables however current conditions demand.

## Symptoms (when you need this process)
- A change requested by one stakeholder group breaks features of another.
- One "service" class serves buyers, authors and admins.
- Everything ships as one blob, or is split into artifacts that all change together.
- Near-duplicate screens for different roles diverge accidentally.

## How to apply (steps)
1. List actors: here viewer, purchaser, author, administrator. Each is a source of change.
2. List use cases per actor (browse catalog, buy streaming license, upload video, set prices). Skip completeness early, but note omissions (login, logout).
3. Spot near-duplicates (catalog for viewer vs purchaser) and give them an abstract base use case holding shared policy.
4. For each actor create controller, interactor, presenter and view components. Shared abstractions (catalog view/presenter) get their own component; actor-specific ones inherit from it.
5. Draw boundaries; ensure all source dependencies cross toward higher-level policy. Use "uses" relations along control flow and inheritance against it, so details depend on policy.
6. Build each component independently; decide deployment grouping later (jar per layer, views+presenters vs the rest, or two).
7. Revisit grouping when change patterns show which parts move independently.

## Example (TypeScript, shared policy with actor-specific variants)
```ts
// catalog-core: shared, depends on nothing UI-specific
export abstract class CatalogPresenter {
  protected abstract priceFor(v: Video): string;
  present(vs: Video[]) { return vs.map(v => ({ title: v.title, price: this.priceFor(v) })); }
}
// purchaser component
export class PurchaserCatalogPresenter extends CatalogPresenter {
  priceFor(v: Video) { return `$${v.streamPrice} stream / $${v.downloadPrice} own`; }
}
// viewer component
export class ViewerCatalogPresenter extends CatalogPresenter {
  priceFor(_: Video) { return "Included"; }
}
```

## Language and framework notes
- Components can be jars, DLLs, npm packages, Gradle/Maven modules, or Python packages; the build boundary matters more than the file format.
- Microservices are one deployment grouping of the same components, not a different architecture.

## Common over-application
- Splitting into dozens of artifacts for a tiny product. Keep the logical components, but compile them together until independent deployment pays off.
- Inventing abstract use cases for coincidental similarity; extract only when the policy is truly shared.
- Treating the diagram as final; it is a preliminary partition.

## Source
Martin (2017), Ch. 33 Case Study: Video Sales.
