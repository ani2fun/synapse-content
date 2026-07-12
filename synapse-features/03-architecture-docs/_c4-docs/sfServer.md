---
title: Server & DB
kind: Container
technology: API server + PostgreSQL
---

## Server & DB

The **Server & DB** is where the truth lives. It answers the Client's requests (an API) and stores the data
durably (a database).

**Responsibilities**

- Accept requests from the Client, validate them, and enforce the rules the client can't be trusted to keep.
- Read and write the database — the single **source of truth** that every client agrees on.
- Stay correct under concurrency: many clients, one consistent story.

**Where it grows.** In a real system this one box splits apart — a stateless API tier you scale horizontally, a
cache in front of the hot reads, read replicas, a queue for async work. Start here; add those pieces only when a
real bottleneck demands them.
