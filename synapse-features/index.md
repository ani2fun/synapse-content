---
title: "Synapse"
summary: "What Synapse can do, then how it is built: a tour of every lesson feature — diagrams, runnable code, visualisers, the D2 library — followed by the architecture, design decisions, measurements and operations of the platform serving this page."
essential: true
---

# Synapse

Synapse is the platform serving you this page. This book has two halves, and you can read either on its own.

| | Part 1 — Features | Part 2 — Deep dive |
| --- | --- | --- |
| **Question** | What can a lesson do? | How does the platform work, and why is it built this way? |
| **Reader** | Learners, and anyone writing a lesson | Contributors, reviewers, and anyone who wants the real architecture |
| **Style** | Short, hands-on pages; every example runs | Long-form, drawn from the code; every number measured |
| **Start with** | [Reading a Synapse lesson](/synapse/synapse-features/reading-a-lesson/reading-a-lesson) | [Why a rebuild](/synapse/synapse-features/the-system/why-a-rebuild) |

Read Part 1 first. It shows what the product does; Part 2 explains the machinery behind each thing Part 1 demonstrated.

---

# Part 1 — Features

A guided tour of what a lesson can do. Every page is itself a working lesson, so the examples are live: edit the code, run it, step through it.

## Reading a lesson

- [Reading a Synapse lesson](/synapse/synapse-features/reading-a-lesson/reading-a-lesson) — Mermaid and D2 diagrams, stepped image sequences, and code you can open in an editor, run and visualise step by step.
- [D2 diagram snippets](/synapse/synapse-features/reading-a-lesson/d2-diagrams-snippets) — the D2 syntax a lesson can render.
- [D2 walkthroughs](/synapse/synapse-features/reading-a-lesson/d2-walkthroughs) — one D2 source, many boards, and a reader who clicks down through them.

## Practice problems

- [Flip characters](/synapse/synapse-features/flip-characters/flip-characters) — an interactive coding problem with a hidden test suite: write, run, submit, read the verdict.

## Architecture docs in the lesson

- [Architecture docs that live in the lesson](/synapse/synapse-features/architecture-docs/architecture-docs) — a diagram drawn from a fence, with the write-up of every box directly underneath. One artifact, one commit, no service to keep running.

## Visualisation

- [Visualisation gallery](/synapse/synapse-features/visualisation-gallery/visualisation-gallery) — one runnable block per bespoke DSA visualiser: array cells, stacks, heaps, Fenwick trees, skip lists, force-directed graphs.
- [Visualisation lab](/synapse/synapse-features/visualisation-lab/visualisation-lab) — the `/viz` page: paste any Python or Java program and step through it line by line, as a structure or as frames and objects.

## The D2 component library

Copy-and-adapt D2 templates, static and animated.

- [Using the library](/synapse/synapse-features/d2-component-library/using-the-library) — the theme, the state classes, the two-panel transition and the four layout rules.
- Data structures and algorithms:
  [arrays and windows](/synapse/synapse-features/d2-component-library/dsa-arrays-and-windows),
  [stacks, lists and hashing](/synapse/synapse-features/d2-component-library/dsa-stacks-lists-hashing),
  [trees and heaps](/synapse/synapse-features/d2-component-library/dsa-trees-and-heaps),
  [graphs](/synapse/synapse-features/d2-component-library/dsa-graphs),
  [DP and divide-and-conquer](/synapse/synapse-features/d2-component-library/dsa-dp-and-divide).
- System design:
  [primitives](/synapse/synapse-features/d2-component-library/sd-primitives) and
  [patterns](/synapse/synapse-features/d2-component-library/sd-patterns).
- Animation:
  [animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram),
  [animated system design](/synapse/synapse-features/d2-component-library/animated-system-design),
  [animated DSA](/synapse/synapse-features/d2-component-library/animated-dsa).

---

# Part 2 — Deep dive

This half documents the platform serving you this page. Not a sanitised version of it — *it*: the same code, the same four machines, and the outage that took it offline for ninety-odd minutes while these chapters were being written.

Most architecture writing has a credibility problem. The system described is either hypothetical, or real but unreachable, so claims cannot be checked. Here they can. The implementation is public at [ani2fun/synapse](https://github.com/ani2fun/synapse), the content you are reading lives in [ani2fun/synapse-content](https://github.com/ani2fun/synapse-content), and the running system is the one that just served this request. When a chapter says a request takes 48 milliseconds from the edge, that is a number I measured, from a stated location, on a stated day.

## Who Part 2 is for

You are comfortable reading code and want to see how a non-trivial system actually fits together — not the pattern-book version, the version with the awkward parts still attached. Some Rust and some TypeScript help but neither is assumed; the design arguments are language-independent, and where a language forces a choice the text says so explicitly.

The awkward parts include the book's own corrections. Since it was first written the platform has deleted a client it had just built, gained three bounded contexts, and grown a write path it had argued against having. Where a chapter's earlier reasoning turned out to be wrong, the reasoning is still there with the correction next to it — that being more useful than a document which has only ever been right.

## The one rule

**Every diagram is drawn from the source, and every number was measured.** Where something is an estimate it is labelled an estimate. Where the measurement has a limitation — a single vantage point, a small sample — the limitation is stated next to the number rather than in a footnote.

This rule has teeth. While writing, I found the project's own design documents contained a stale API contract, chapters describing behaviour that later steps had replaced, and cross-references pointing at the wrong chapters entirely. Consolidating those by transcription would have published known-wrong material. So Part 2 was written against the code and the live system, and the older documents were treated as leads to verify rather than facts to copy.

## The system

- [Why a rebuild](/synapse/synapse-features/the-system/why-a-rebuild) — two rewrites six days apart: Scala to Rust on the server, and a Rust client deleted almost as soon as it shipped. What each measurably bought, and which one the evidence never supported.
- [Architecture](/synapse/synapse-features/the-system/architecture) — C4 from context to component. Ten bounded contexts, two processes behind one front door, and why the seams fall there.

## Low-level design

Drawn from the code, with the traps that make an idealised diagram wrong.

- [The server hexagon](/synapse/synapse-features/low-level-design/the-server-hexagon) — seventeen port traits, their adapters, and a purity rule enforced by CI rather than by discipline.
- [The submission lifecycle](/synapse/synapse-features/low-level-design/the-submission-lifecycle) — accept in 202, judge in a detached task, poll for the verdict, and what happens when the process dies mid-judge.
- [Data design and the schema](/synapse/synapse-features/low-level-design/data-design) — six small tables, one check constraint that makes an illegal state unrepresentable, and what a schema tells you by the columns it refuses to have.
- [The web tier](/synapse/synapse-features/low-level-design/the-client) — server-rendered prose, islands that cannot share state, a budget measured per page, and a staleness guard that lost a guarantee in translation.
- [The visualisation engine](/synapse/synapse-features/low-level-design/the-visualisation-engine) — how a running program becomes a picture, stage by stage. The visualisers Part 1 demonstrates, taken apart.

## Choices and their cost

- [The technology stack](/synapse/synapse-features/choices/technology-stack) — what was chosen, what was rejected, what each decision cost, and the one rejected option that turned out to be rejected for a bad reason.
- [Trade-offs](/synapse/synapse-features/choices/trade-offs) — the deliberate asymmetries. Why the database fails fast but the identity provider degrades; why granting access is instant but granting admin needs a commit.

## Running it

- [The content pipeline](/synapse/synapse-features/running-it/the-content-pipeline) — how a `git push` becomes this page, by two different routes with very different latencies.
- [Content contribution, without git](/synapse/synapse-features/running-it/content-contribution) — a reader fixes a typo from inside the app and it lands as a reviewed pull request. Optimistic concurrency without a lock, and a credential-free mode that runs the whole flow.
- [Performance, measured](/synapse/synapse-features/running-it/performance) — the numbers, the method, and the limits of both.
- [The homelab case study](/synapse/synapse-features/running-it/the-homelab-case-study) — four nodes, one of them in a datacentre and three behind a domestic router. Capacity, failure modes, and the outage — reconstructed from timestamps — that exposed the real dependency graph.
- [Scaling and maintainability](/synapse/synapse-features/running-it/scaling-and-maintainability) — what it serves today under load, the arithmetic from requests to readers, what breaks first, and the trigger-gated path to millions.

## Appendices

- [The authoring reference](/synapse/synapse-features/appendices/authoring-reference) — the complete fence vocabulary and content layout. Part 1 shows each feature; this page is the complete spec, and the whole book is written in it.
- [Glossary](/synapse/synapse-features/appendices/glossary) — the words this codebase uses in a specific way. Start here if a term reads oddly.
