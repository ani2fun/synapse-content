---
title: Reader client
kind: Web application
technology: Rust · Leptos · WASM
---

## Reader client

A fine-grained reactive client compiled to WebAssembly. There is no virtual DOM: a signal update
touches exactly the DOM nodes that depend on it.

### The island boundary

The heavy machinery is not Rust. The code editor, the Markdown pipeline, the diagram renderers and
the language tracers are all TypeScript, loaded on demand as separate chunks. Rust reaches them
through a narrow set of typed externs confined to one module tree — the only place in the client
that touches JavaScript.

This was a deliberate refusal to rewrite working code. Those libraries have no Rust equivalent worth
the effort, and porting them would have added risk for no user-visible gain.

### Three layers

Features are split into pure `logic`, reactive `state`, and `view`. The purity of the first is
enforced by a CI grep rather than by convention: nothing under a `logic/` directory may import the
UI framework, which keeps the interesting parts testable without a browser.
