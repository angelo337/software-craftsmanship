# Policy and level

## Core statement
A program is a collection of policies turning inputs into outputs. A policy's level is its distance from inputs and outputs: the farther away, the higher. Group policies that change together, and make source dependencies point toward higher levels, regardless of the direction data flows.

## Symptoms
- High-level logic calls read/write/network helpers directly.
- A change to a file format or device edits core algorithms.
- Core logic cannot be reused with another input or output.
- Components depend on each other in cycles.

## How to apply
1. List the policies (rules, formatting, validation, I/O) and rank them by distance from I/O.
2. Group by reason and time of change (single-responsibility and common-closure thinking).
3. Draw the component graph; edges must connect different levels and run toward the higher one; keep it acyclic.
4. For each edge that would point down, insert an interface owned by the high-level side and implemented by the low-level side.
5. Treat low-level components as plugins to high-level ones.

## Language and framework notes
- Spring/NestJS/ASP.NET: constructor injection of an interface is the usual mechanism.
- Django/Rails: pass collaborators as parameters or use thin adapters, since the frameworks encourage direct model access.
- FastAPI: dependency injection at the route edge; inner code receives ports as arguments.
- Any language: function parameters (callbacks) are enough; no container is required.

## Common over-application
- Inverting every call, including stable low-risk utilities.
- Splitting components that always change together.
- Reading "level" as "importance to users"; it means distance from I/O.

## Source
Martin (2017), Ch. 19.
