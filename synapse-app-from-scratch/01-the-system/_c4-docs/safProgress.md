---
title: progress
kind: Component
technology: Rust
---

## `progress`

Per-account completion: one row per lesson a reader has finished, keyed by the opaque OIDC subject.
The sidebar's ✓ ticks used to live in `localStorage`, which made them per-browser, unsynced, and
blind to who was signed in.

Two writers, one table. The reader syncs its ticks here, and an accepted judged submission records
into it through a small adapter — so solving a problem marks it done without the client having to
remember to say so.

Deliberately thin: no `domain/`, no aggregate, three files. This is convenience state the account
owns, and `DELETE /api/progress` clears these rows and **nothing else** — a reset never touches the
submissions history. Giving it four layers would be filing, not design.
