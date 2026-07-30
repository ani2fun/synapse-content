---
title: Origin API
kind: Service
technology: Rust · axum · tokio
---

## Origin API

Stateless by construction. Every request carries everything needed to serve it, so the process holds
no session state and can be replaced at any moment — which is what makes a rolling deploy safe and a
crash survivable.

Internally it is a **modular monolith**: ten bounded contexts in one binary, each with its own
domain types, its own error enum, and ports it declares but does not implement. The deployment unit
is one process; the *design* unit is the context. That choice buys the clean seams of services
without the operational cost of ten of them — and the run path is the one context explicitly
earmarked for extraction if load ever demands it.

### It is also the front door

The API is what the edge talks to. It owns `/api`, `/media`, the `/c4` proxy, `robots.txt` and the
sitemap, and it stamps security headers and compression over everything — including responses it did
not generate. Page requests reach the Astro web tier only as the router's **fallback**, which is the
ordering that matters: a registered route can never be shadowed by a page path, and the sidecar's
404 becomes the site's 404.

### One replica, deliberately

`replicas: 1` is a correctness requirement here, not a compromise. The rate limiter keeps its
counters in process memory, so N replicas would mean N × the configured limit. Scaling out requires
moving that state first — the constraint is written down rather than left to be discovered.

### What it refuses to do

- **It does not degrade on the database.** No Postgres, no boot: the system of record is not
  optional.
- **It does degrade on everything else.** Identity provider unreachable returns 503, never 401 —
  "I cannot check" and "you are not allowed" are different answers and conflating them would lock
  out legitimate users during an outage.
- **A disabled feature is not mounted.** The coach and the in-app editor are absent routes when
  switched off, not gated ones — a structural 404 cannot be defeated by a flag misread at request
  time.
