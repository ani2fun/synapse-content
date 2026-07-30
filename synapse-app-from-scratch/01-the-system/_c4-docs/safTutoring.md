---
title: tutoring
kind: Component
technology: Rust
---

## `tutoring`

A Socratic coach over an OpenAI-compatible endpoint, deliberately domain-free — its only real logic is the steering prompt. Disabled by default, and disabled means *structurally* absent: the route is never mounted, so there is no code path to reach rather than a flag to check.
