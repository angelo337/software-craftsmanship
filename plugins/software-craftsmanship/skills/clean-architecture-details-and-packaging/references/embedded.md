# Clean Embedded Architecture

## Core statement
Software can live long; firmware is whatever depends tightly on hardware and ages as hardware evolves. Code is firmware because of what it depends on, not where it is stored. Unmanaged dependencies on hardware, processor, vendor extensions or the OS destroy software from within and force testing on the target (the target-hardware bottleneck). Separate software from firmware with abstraction layers shaped by the needs of the layer above, so most code runs and is tested off-target.

## Symptoms
- A single file mixes interrupt handlers, button logic, sensor math and flash storage.
- Business rules read registers or vendor-specific globals.
- Message parsing sits in the same file as UART access.
- You can only test by flashing a board; every minor change needs full regression.
- `#ifdef BOARD_X` repeated across the code.
- Legacy code is the only specification of behavior.
- Function names do not match what they do.

## How to apply
1. Do the work in three steps: make it work, make it right, then make it fast (only to needed performance). Do not stop at step one.
2. Group existing functions by concern: domain logic, hardware setup, input handling, ADC/sensor access, persistence. Move each group behind its own interface.
3. Define a HAL that expresses services the app needs (store a setting, indicate low battery) not register-level actions (set GPIO 5).
4. Confine vendor extensions, register names and compiler-specific headers to a few firmware files, optionally behind a PAL (processor abstraction layer).
5. Use standard integer types (`stdint.h` or equivalents) in software; provide a target mapping in firmware.
6. Add an OSAL over the RTOS/OS (threads, queues, timers) so apps depend on your interface; writing a new OSAL beats rewriting application code.
7. Keep header files as interfaces: declarations and constants callers need, nothing implementation-only.
8. Replace conditional compilation for board variants with link-time or runtime binding of implementations.
9. Run software tests on a host using fake HAL/OSAL implementations.

## Example (C-like, in Python for brevity)
```python
class Hal:                                  # app-shaped, no pins
    def indicate_low_battery(self): ...
    def save_setting(self, key: str, val: bytes): ...

class FakeHal(Hal):                         # host-side test double
    def __init__(self): self.log, self.store = [], {}
    def indicate_low_battery(self): self.log.append("low")
    def save_setting(self, k, v): self.store[k] = v

def monitor(hal: Hal, volts: float):        # software layer: testable off target
    if volts < 3.3: hal.indicate_low_battery()

h = FakeHal(); monitor(h, 3.0); assert h.log == ["low"]
```
On the device, a firmware class implements `Hal` with real GPIO and flash writes. In C use a header of function declarations and pick the `.c` at link time.

## Language and framework notes
- C/C++: header per abstraction; select implementations in the build system (separate object sets per target) instead of `#ifdef`.
- Rust embedded: traits (`embedded-hal`) play the HAL role.
- Arduino/Android-style SDKs: apply the same idea; business logic must not call the platform API directly.
- This applies beyond devices: SQL in code or platform calls spread around is also "firmware".

## Common over-application
- Abstracting everything on a tiny, single-product microcontroller with scarce memory. Keep indirection to seams that buy off-target testing or likely hardware change.
- A HAL that mirrors the vendor API one-to-one, adding layers without hiding anything.
- Assuming abstraction costs unacceptable code size; measure, since the layer often removes duplication.

## Source
Martin (2017), Ch. 29 Clean Embedded Architecture (James Grenning).
