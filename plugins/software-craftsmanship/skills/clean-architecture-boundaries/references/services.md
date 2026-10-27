# Services (Great and Small)

## Core statement
A service is a function call across a process or network boundary. It is not an
architecture by itself. Architecture is the set of boundaries that put policy above
detail along the Dependency Rule; those boundaries run through services, not between them.

## Symptoms
- A "simple" feature requires coordinated changes and deploys across many services.
- Services share record formats, so one new field touches all of them.
- Services are decomposed by function (find, select, dispatch) and break on cross-cutting features.
- Teams claim independence yet release in lockstep.
- Microservice count tracks headcount rather than axes of change.

## How to apply
1. Ask what policy-versus-detail line, if any, a proposed service split creates. If none, it is
   an expensive function call: justify it by scale, platform, or team needs instead.
2. Discount the decoupling claim: map shared data and shared meaning between services.
3. Discount the independence claim: list the changes that need both sides to move together.
4. Test with a cross-cutting feature (a new rule that affects selection, pricing, dispatch).
   If every service changes, decomposition is by function and needs rethinking.
5. Give each service an internal component structure: abstract base behavior in one
   component, features as derived components that plug in (open-closed).
6. Load extensions without redeploying the base (plugins, packages, config), and keep
   dependency arrows inward inside each service.
7. Keep service references (URIs) in Main or configuration only.

## Example (Python)
```python
# Base service component: knows only the abstraction.
class Eligibility:
    def allowed(self, driver: dict, order: dict) -> bool: return True

def pick(drivers, order, rules: list[Eligibility]):
    return next((d for d in drivers if all(r.allowed(d, order) for r in rules)), None)

# New feature lives in its own component; base is unchanged.
class NoAllergyDrivers(Eligibility):
    def allowed(self, driver, order):
        return not (order.get("kitten") and driver.get("cat_allergy"))

assert pick([{"cat_allergy": True}, {}], {"kitten": True}, [NoAllergyDrivers()]) == {}
```

## Language notes
- Plugin loading differs by stack: Python entry points, Node dynamic import, JVM ServiceLoader.
- Schema-first contracts (protobuf, OpenAPI) formalize interfaces but do not remove data coupling.
- Many cases are legitimately about scaling or isolation; this is not a ban on services.

## Common over-application
- Rejecting services outright; they are useful for scale and platform reach.
- Splitting a codebase into services as a substitute for component design.
- One service per entity or per programmer, forming a distributed monolith.

Source: Martin (2017), Ch. 27.
