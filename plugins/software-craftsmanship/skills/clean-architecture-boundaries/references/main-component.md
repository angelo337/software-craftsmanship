# The Main Component

## Core statement
Main is the lowest-level policy: the entry point, depended on by nothing but the
operating system. It creates factories, strategies, configuration, and wiring, then
hands control to the high-level system. Treat it as a plugin; there can be many.

## Symptoms
- Business classes read environment variables, build their own collaborators, or choose implementations.
- A DI container is referenced throughout the codebase.
- Switching between dev, test, and production needs edits in domain code or `if env ==` branches.
- Concrete class names appear deep inside the core.
- Startup code is scattered across modules.

## How to apply
1. Create one entry module per configuration (dev, test, production, per customer or country).
2. In it, read config, construct concrete adapters, and wire them to the interfaces.
3. If you use a DI framework, confine it to Main; after injection, pass dependencies plainly.
4. Reference very dirty or volatile classes by name or via a factory so changes do not force Main to rebuild.
5. Run the top-level loop or server start from Main, delegating all decisions inward.
6. Keep Main free of business rules; if logic accumulates, move it into the core.
7. Add a smoke test per Main variant to prove the wiring resolves.

## Example (Python)
```python
# main_prod.py -- dirtiest module; nothing imports it
import os
from shop.core import Checkout
from shop.adapters.pg import PgOrders
from shop.adapters.smtp import SmtpMailer

def main():
    dsn = os.environ["DATABASE_URL"]
    app = Checkout(orders=PgOrders(dsn), mailer=SmtpMailer("smtp.local"))
    app.run()

if __name__ == "__main__":
    main()
# main_test.py would wire in-memory orders and a fake mailer instead.
```

## Language notes
- Python: `__main__` modules or console entry points; one per config.
- TypeScript: separate `index.prod.ts` and `index.test.ts` composition roots.
- Java/C#: composition root class; Spring or similar contexts stay in that module.

## Common over-application
- Service locators leaking out of Main into the core, bringing the container with them.
- Many Mains with copy-pasted wiring where a shared helper would do.
- Putting configuration logic that is really policy (pricing, eligibility) in Main.

Source: Martin (2017), Ch. 26.
