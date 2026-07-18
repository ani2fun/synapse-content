---
title: Code sandbox
kind: Service
technology: go-judge
---

## Code sandbox

Runs code written by strangers. Every design decision here follows from that sentence.

Isolation is layered: a separate process with its own resource caps, a network policy denying **all**
egress, execution pinned to one node, and a concurrency limit so a burst cannot starve the rest of
the cluster. Wall-clock and memory ceilings are enforced per run, and the judge stops at the first
failing case rather than running a suite to completion.

### The honest limitation

This is process-level isolation, not virtualisation. It is appropriate for a personal deployment
with a handful of trusted-ish users and would not be appropriate at public scale, where the next
step is a hardened runtime that gives each execution its own kernel boundary. The
[scaling chapter](/synapse/synapse-app-from-scratch/running-it/scaling-and-maintainability) treats
that as a gated stage rather than a someday-maybe.

It currently shares a physical machine with the database, which is the arrangement the
[case study](/synapse/synapse-app-from-scratch/running-it/the-homelab-case-study) argues should
change first.
