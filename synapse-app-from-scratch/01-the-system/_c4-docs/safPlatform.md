---
title: platform
kind: Component
technology: Rust
---

## `platform`

The cross-cutting layer: security headers on every response including errors, cache-control stamped only on public content GETs, rate limiting, health and readiness probes, static and media serving, and the diagram proxy. Deliberately flat — it has no domain to model, and inventing layers for it would have been ceremony.
