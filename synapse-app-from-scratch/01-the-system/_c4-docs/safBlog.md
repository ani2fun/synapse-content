---
title: blog
kind: Component
technology: Rust
---

## `blog`

A near-twin of `catalog` over the same filesystem seam, kept as a separate context rather than a flag on the first. The duplication is deliberate: lessons and posts have different lifecycles and different URL shapes, and merging them would have coupled two things that only look alike.
