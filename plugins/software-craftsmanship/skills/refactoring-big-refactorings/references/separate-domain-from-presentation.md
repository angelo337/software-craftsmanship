# Separate Domain from Presentation

## Intent
Move business logic out of UI classes into domain classes, so presentation code only handles display and input (the idea behind model-view-controller).

## Use when
- Window/page/controller classes contain pricing rules, validation, SQL, or other business logic (the classic two-tier style: data in the database, logic in the UI).
- You need multiple presentations of the same logic, or want to test the logic without a UI.

## Don't use when
- The screen is truly a throwaway with no real logic.

## Mechanics
1. Create a domain class for each window or page.
2. If there is a grid/list, create a class for its rows and hold a collection of them in the window's domain class.
3. Examine each data item: used only by the UI stays in the UI; used only by domain logic (not displayed) moves with Move Field/Move Method; used by both is kept in both places synchronized with Duplicate Observed Data.
4. Examine the logic in the presentation class. Use Extract Method to separate presentation logic from domain logic, then Move Method to push the domain part into the domain classes.
5. Drive progress by moving all database/SQL calls into the domain layer; removing database imports from the UI class is a good completion signal.
6. Accept that the resulting domain classes are not yet well factored; refactor them afterwards. Order the work by risk: if mixing concerns is the main risk, finish the separation first; if another area (such as pricing strategies) is riskier, move that logic out first.

## Language notes
- Web stacks: move logic out of controllers/views/components into services or domain models; the equivalent of Duplicate Observed Data is syncing form state with domain state through events or a state store.
- Frontend frameworks: keep components thin; put rules in plain modules testable without rendering.

## Related
Extract Method, Move Method, Move Field, Duplicate Observed Data; smells: Large Class, Feature Envy.

Source: Fowler et al. (1999), Ch. 12.
