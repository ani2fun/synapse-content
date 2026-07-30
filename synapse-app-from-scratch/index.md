---
title: "Synapse App From Scratch"
summary: "The syllabus: what this book covers, who it is for, and the one rule it follows — every diagram matches the source, every number was measured."
essential: true
---

# Synapse App From Scratch

This book documents the platform serving you this page. Not a sanitised version of it — *it*: the
same code, the same four machines, and the outage that took it offline for ninety-odd minutes while
this book was being written.

Most architecture writing has a credibility problem. The system described is either hypothetical,
or real but unreachable, so claims cannot be checked. Here they can. The implementation is public
at [ani2fun/synapse](https://github.com/ani2fun/synapse), the content you are reading lives in
[ani2fun/synapse-content](https://github.com/ani2fun/synapse-content), and the running system is
the one that just served this request. When this book says a request takes 48 milliseconds from the
edge, that is a number I measured, from a stated location, on a stated day.

## Who this is for

You are comfortable reading code and want to see how a non-trivial system actually fits together —
not the pattern-book version, the version with the awkward parts still attached. Some Rust and some
TypeScript help but neither is assumed; the design arguments are language-independent, and where a
language forces a choice the book says so explicitly.

The awkward parts include the book's own corrections. Since it was first written the platform has
deleted a client it had just built, gained three bounded contexts, and grown a write path it had
argued against having. Where a chapter's earlier reasoning turned out to be wrong, the reasoning is
still there with the correction next to it — that being more useful than a document which has only
ever been right.

## The one rule

**Every diagram is drawn from the source, and every number was measured.** Where something is an
estimate it is labelled an estimate. Where the measurement has a limitation — a single vantage
point, a small sample — the limitation is stated next to the number rather than in a footnote.

This rule has teeth. While writing the book I found the project's own design documents contained a
stale API contract, chapters describing behaviour that later steps had replaced, and cross-references
pointing at the wrong chapters entirely. Consolidating those by transcription would have published
known-wrong material. So the book was written against the code and the live system, and the older
documents were treated as leads to verify rather than facts to copy.

## Part 1 — The system

- [Why a rebuild](/synapse/synapse-app-from-scratch/the-system/why-a-rebuild) — two rewrites six days
  apart: Scala to Rust on the server, and a Rust client deleted almost as soon as it shipped. What
  each measurably bought, and which one the evidence never supported.
- [Architecture](/synapse/synapse-app-from-scratch/the-system/architecture) — C4 from context to
  component, with a live clickable model. Ten bounded contexts, two processes behind one front door,
  and why the seams fall there.

## Part 2 — Low-level design

Drawn from the code, with the traps that make an idealised diagram wrong.

- [The server hexagon](/synapse/synapse-app-from-scratch/low-level-design/the-server-hexagon) —
  seventeen port traits, their adapters, and a purity rule enforced by CI rather than by discipline.
- [The submission lifecycle](/synapse/synapse-app-from-scratch/low-level-design/the-submission-lifecycle)
  — accept in 202, judge in a detached task, poll for the verdict, and what happens when the
  process dies mid-judge.
- [Data design and the schema](/synapse/synapse-app-from-scratch/low-level-design/data-design) —
  six small tables, one check constraint that makes an illegal state unrepresentable, and what a
  schema tells you by the columns it refuses to have.
- [The web tier](/synapse/synapse-app-from-scratch/low-level-design/the-client) — server-rendered
  prose, islands that cannot share state, a budget measured per page, and a staleness guard that
  lost a guarantee in translation.
- [The visualisation engine](/synapse/synapse-app-from-scratch/low-level-design/the-visualisation-engine)
  — how a running program becomes a picture, stage by stage.

## Part 3 — Choices and their cost

- [The technology stack](/synapse/synapse-app-from-scratch/choices/technology-stack) — what was
  chosen, what was rejected, what each decision cost, and the one rejected option that turned out to
  be rejected for a bad reason.
- [Trade-offs](/synapse/synapse-app-from-scratch/choices/trade-offs) — the deliberate asymmetries.
  Why the database fails fast but the identity provider degrades; why granting access is instant
  but granting admin needs a commit.

## Part 4 — Running it

- [The content pipeline](/synapse/synapse-app-from-scratch/running-it/the-content-pipeline) — how
  a `git push` becomes this page, by two different routes with very different latencies.
- [Content contribution, without git](/synapse/synapse-app-from-scratch/running-it/content-contribution)
  — a reader fixes a typo from inside the app and it lands as a reviewed pull request. Optimistic
  concurrency without a lock, and a credential-free mode that runs the whole flow.
- [Performance, measured](/synapse/synapse-app-from-scratch/running-it/performance) — the numbers,
  the method, and the limits of both.
- [The homelab case study](/synapse/synapse-app-from-scratch/running-it/the-homelab-case-study) —
  four nodes, one of them in a datacentre and three behind a domestic router. Capacity, failure
  modes, and the outage — reconstructed from timestamps — that exposed the real dependency graph.
- [Scaling and maintainability](/synapse/synapse-app-from-scratch/running-it/scaling-and-maintainability)
  — what it serves today under load, the arithmetic from requests to readers, what breaks first,
  and the trigger-gated path to millions.

## Appendices

- [The authoring reference](/synapse/synapse-app-from-scratch/appendices/authoring-reference) —
  the complete fence vocabulary and content layout. This book is written in it.
- [Glossary](/synapse/synapse-app-from-scratch/appendices/glossary) — the words this codebase uses
  in a specific way. Start here if a term reads oddly.
