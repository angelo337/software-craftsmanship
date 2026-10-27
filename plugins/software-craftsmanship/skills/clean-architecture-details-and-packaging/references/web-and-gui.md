# The Web Is a Detail

## Core statement
A GUI is a detail, the web is a GUI, so the web is a detail. Treat it as an IO device. Industry placement of computing power has swung between server and client for decades and will swing again, so keep those swings out of the business rules. The browser-to-app conversation is too specific to abstract, but the use-case boundary can be: once input is complete, pass a plain input structure to the use case and get a plain output structure back.

## Symptoms
- Use cases accept HTTP request objects, sessions or form types.
- Business rules produce HTML, JSON shaped for one screen, or status codes.
- A redesign, a move to SPA/mobile, or an SSR-vs-client change touches domain code.
- Validation lives only in JavaScript, or business validation is duplicated in the view.
- Testing a rule needs a running server.

## How to apply
1. Describe each use case by its input data, processing and output data.
2. Controller: parse the transport (HTTP, CLI, queue message) into the input structure, call the use case.
3. Presenter: turn the output structure into a view model (formatted strings, flags). Keep logic that decides what to show here, not in the template.
4. View: render the view model with minimal logic. It can be React, a template, a CLI printer.
5. Keep UI-only validation (format, required) separate from business validation (rules enforced in use cases/entities).
6. Prove the boundary by driving the use case from a test or script with no web stack.

## Example (TypeScript)
```ts
// use case: knows nothing about HTTP
export interface ShowOrderIn { orderId: string }
export interface ShowOrderOut { status: string; total: number }
export const showOrder = (repo: Orders) => async (i: ShowOrderIn): Promise<ShowOrderOut> => {
  const o = await repo.get(i.orderId);
  return { status: o.status, total: o.total };
};

// web adapter (Express): translate in, translate out
app.get("/orders/:id", async (req, res) => {
  const out = await showOrder(repo)({ orderId: req.params.id });
  res.json({ label: out.status.toUpperCase(), price: `$${out.total.toFixed(2)}` });
});
```

## Language and framework notes
- Django/Rails/Spring MVC/Next.js: views and controllers are outer; keep models and service code importable without the framework.
- SPA plus API: the API is another adapter. Do not let DTOs designed for one screen become domain types.
- GraphQL, gRPC and websockets are transports; the same boundary applies.

## Common over-application
- A separate presenter and view model for a three-field admin page. Use the simplest mapping that keeps the use case clean.
- Chasing full device independence (one abstraction for browser and desktop interaction). Only the data boundary is realistically abstractable.
- Building a headless core for an app that will only ever be a thin web wrapper over one database.

## Source
Martin (2017), Ch. 31 The Web Is a Detail.
