---
title: Diagram SPA
kind: Web application
technology: LikeC4 · nginx
---

## Diagram SPA

The architecture diagrams — including the one you clicked to get here — are built from `.c4` model
files that live in the content repository, alongside the prose that embeds them.

Any change to a `.c4` file triggers a rebuild of this image and a redeploy. That is markedly slower
than the prose path, which needs only a sixty-second poll, and the difference is inherent: prose is
data read at runtime, whereas diagrams are compiled into an artifact.

It is never exposed directly. The API reverse-proxies it, which keeps one origin, one TLS
certificate, and one security-header policy across everything.

### The constraint that governs authoring

Every `.c4` file in the repository is merged into **one** workspace. That has two consequences worth
knowing before adding a model: identifiers are globally unique across all books, and there may be
exactly one specification block in the entire repository. A second one does not fail locally — it
breaks every diagram on the site at once.
