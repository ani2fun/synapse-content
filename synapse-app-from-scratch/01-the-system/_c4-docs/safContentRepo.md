---
title: synapse-content
kind: Source repository
technology: git (GitHub)
---

## synapse-content

The authoring plane. Books as Markdown, architecture models as `.c4`, hidden judge suites as JSON
sidecars — all in one public repository with exactly one writer and arbitrarily many readers.

Using git as the content store means version history, review, rollback and branching arrive for free,
and it removes the write path that a CMS would otherwise need. It also means the content has a
**commit hash**, which the platform reuses as a cache key — the single decision that makes lesson
responses safely cacheable at the edge.
