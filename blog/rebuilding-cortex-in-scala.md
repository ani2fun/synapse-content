---
title: Rebuilding Cortex, from Hello World, in all Scala
summary: Why we're re-deriving a working platform slice by slice instead of porting it — and what a documented "build-book" buys you.
publishedAt: 2026-06-25
tags: [architecture, scala, process]
readMinutes: 6
eyebrow: Engineering · The Rebuild
---

# Rebuilding Cortex, from Hello World, in all Scala

Synapse is a deliberate, from-scratch rebuild of **Cortex** — an interactive platform for learning data
structures, algorithms, and system design. The old app worked. So why start again at `Hello, World`?

## Ownership over porting

The goal isn't a faster copy. It's **understanding**. Cortex is the reference oracle: we read it, port its
tests as the spec, and then re-derive each slice cleanly — never copying a decision we don't understand. A
blind port carries every shortcut forward; a re-derivation makes you re-justify each one.

## One language, end to end

The client is **Scala.js + Laminar** (no React), the server is **Scala 3 / ZIO / tapir**, and a `shared`
module cross-compiles to both. A change to the wire contract breaks *both sides at compile time* — the
safest possible refactor.

## Hexagonal, proportional to complexity

The server is **ports & adapters by bounded context** — `catalog`, `execution`, `submission`, `identity`,
and now `blog`. Each context layers `domain → application → infrastructure → http`, but only as much as its
complexity earns: a thin context stays flat, a rich one grows tactical DDD. The domain stays pure — no ZIO,
no JSON, no JDBC leaks past the seams.

## A build-book, not a changelog

Every step ships **code and a short chapter** explaining the decisions, plus one squashed, tagged commit.
`git checkout step-17` gives you the whole app exactly as it stood when the run endpoint went live. The
chapters are immutable snapshots; later changes are documented *forward*, never by rewriting history.

That's the whole method: small reversible steps, tests at the right altitude, and a paper trail you can walk
backwards through. This blog is part of it — the same pipeline that renders a lesson renders this post.
