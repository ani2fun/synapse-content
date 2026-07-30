---
title: execution
kind: Component
technology: Rust
---

## `execution`

Owns the language vocabulary — eleven languages, their aliases, and the recipe for compiling and running each — plus the port through which code reaches the sandbox. Note the relationship with `submission`: that context *consumes* this one rather than duplicating a runner. Customer and supplier, with the dependency pointing one way only.
