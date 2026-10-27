---
name: clean-code-concurrency
description: Write safer concurrent code following Clean Code (Concurrency). Use whenever code involves threads, async/await shared state, locks, mutexes, queues, executors, parallel jobs or race conditions, deadlocks, or flaky concurrency tests. Triggers on "thread", "concurrent", "race condition", "deadlock", "async", "concurrencia", "synchronized".
---

# Concurrency

Concurrency is a decoupling strategy (what gets done vs. when), not a performance silver bullet. It adds complexity, so use it deliberately and keep it small.

## Principles

1. **Single Responsibility:** concurrency-related code is separate from other code; it has its own life cycle and challenges.
2. **Limit shared data.** Prefer immutability, copies of data, and thread-confined state; where sharing is unavoidable, keep the critical section small and the shared surface minimal.
3. **Use thread-safe collections and the language's high-level primitives** (executors, futures, channels, actors, queues) before raw threads and manual locks.
4. **Keep threads as independent as possible:** no shared state; each handles one request with its own local data.
5. **Know the library's guarantees** and the basic models (producer-consumer, readers-writers, dining philosophers) and the standard fixes.
6. **Beware dependencies between synchronised methods;** avoid calling more than one synchronised method on a shared object, or lock at the client/server level on purpose.
7. **Keep synchronised sections small;** locks are expensive and serialise work. Don't over-lock.
8. **Shutdown is hard;** design it early (graceful stop, no orphaned threads, no deadlock on exit).

## Testing threaded code

- Write tests that can expose problems, and run them many times, on varied platforms and loads; failures are often rare.
- Treat every one-off failure as a real bug, not a "glitch".
- First get the non-threaded code correct; make pluggable thread-based code, tunable thread counts, and tests that run with more threads than processors.
- Instrument code (jiggle/forced yields) to shake out ordering bugs; use tools that detect races.

## Quick check

- Which data is shared and why can't it be immutable?
- Is the lock scope the minimum and the lock order consistent?
- Is concurrency logic isolated from business logic?
- How do you prove it doesn't deadlock under load?

## Source

Martin, R. C. (2009). *Clean code* (Ch. 13, "Concurrency"). Prentice Hall.
