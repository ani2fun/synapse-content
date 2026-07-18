---
title: catalog
kind: Component
technology: Rust
---

## `catalog`

The reference hexagon walk, and the context every other one was modelled on. It walks the content tree into a catalog, resolves lesson paths, and serves lesson bodies. Its cache is version-gated on the content commit, so a new push invalidates it without any explicit purge. The filesystem work happens off the async runtime's threads, because a directory walk is blocking and pretending otherwise stalls unrelated requests.
