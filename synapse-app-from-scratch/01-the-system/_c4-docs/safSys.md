---
title: Synapse
kind: Software system
technology: Rust · WebAssembly · PostgreSQL
---

## Synapse

An interactive learning platform: prose you read, code you run, algorithms you watch execute
step by step, and solutions a judge accepts or rejects.

Everything inside this boundary is one thing I own end to end. Everything outside it — the
identity provider, the git host, the CDN — is a system I depend on but do not operate.

### What the boundary is doing

The interesting property is how little lives inside. The platform's largest asset is its
content, and content is **outside** this box: it lives in a git repository and arrives on disk
through a sidecar. There is no CMS, no content database, no upload path. That is why the
boundary looks thin for a system with this much surface area.

What is genuinely inside: a single Rust binary serving seven bounded contexts, a WebAssembly
client, a sandbox that runs untrusted code, and one Postgres holding the only state that cannot
be rebuilt from a repository.

### The three traffic classes

| Class | Share | Where it is answered |
|---|---|---|
| Reads — lessons, diagrams, search | ~99% | the edge, ideally never reaching this boundary |
| Runs — execute this code | ~1% | the sandbox, isolated and resource-capped |
| Writes — submit a solution | ≪1% | Postgres, judged asynchronously |

Almost every design decision inside this boundary follows from those three lines having nothing
in common. Designing for their average would produce something mediocre at all three.

### One process, on purpose

The seven contexts ship as one binary with `replicas: 1`. The single replica is not a resource
compromise — it is a correctness requirement, because the rate limiter holds per-process state
and N replicas would mean N× the intended limit. Scaling out therefore requires moving that
state, which is a deliberate, documented trigger rather than an accident waiting to happen.

The execution context is the one designed to leave first: it is CPU-bound, it runs hostile
input, and its resource profile differs from the rest by an order of magnitude. Its port is
already a trait and its adapter already speaks HTTP to a separate process, so extracting it is a
wiring change.
