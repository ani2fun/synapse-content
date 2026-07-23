---
title: Web tier
kind: Web application
technology: Astro 5 SSR · TypeScript islands · Preact
---

## Web tier

Every page is **server-rendered**: the prose a reader came for is HTML in the first response, not
something a client framework produces after it boots. The tier runs as a Node sidecar inside the
same pod as the API, which forwards page requests to it as the router's fallback.

This replaced a Leptos client compiled to WebAssembly — 641 KiB gzipped that had to download,
instantiate and mount before any text appeared. The architecture of the read path had to answer to
that number, and a bundle is the wrong place to keep a document.

### Islands, and what makes them lazy

Interactivity hydrates per feature, not per page. Vanilla TypeScript is the default; Preact is used
only where there is real component state — the workbench, the problem page, the editorial pane, the
account and admin panels.

Everything expensive is a **dynamic import behind a loader**: the code editor, the OIDC client, the
two diagram engines, the language tracers, and the visualisation bundle. A reader who never opens an
editor never downloads one. Because those are dynamic imports they cannot appear in the page's HTML,
so they stay out of the eager budget by construction rather than by a glob someone maintains.

### Islands cannot share signals

Separate islands are separate mounts with no common reactive graph, so every seam between them is an
explicit, named `CustomEvent` or a window-scoped provider — and all of them are declared once, in a
single contracts module. An event name spelled in two files is a typo waiting to disagree.

That is a real cost compared with one application owning one signal graph. What it buys is that no
island can accidentally depend on another's internals, and any island can be deleted without hunting
for reads of its state.

### The budget is per page

There is no single bundle to measure, because Astro ships each page only its own assets. So the gate
measures **per page kind**: fetch the page, sum the gzipped weight of everything its HTML makes the
browser download before content is readable, and fail the build over a limit. Four page kinds are
gated — landing, prose lesson, problem page, blog index.
