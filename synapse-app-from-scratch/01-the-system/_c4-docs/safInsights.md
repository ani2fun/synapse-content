---
title: insights
kind: Component
technology: Rust
---

## `insights`

Readership. The platform could serve several hundred lessons and answer nothing about which of them
anyone opened, so every prioritisation decision was a guess. This is the smallest thing that ends
that: the catalog records an append-only row when a lesson is served, and an admin-only endpoint
reads the top paths.

**Content popularity, not user tracking.** There is deliberately no user id, no session, no IP and
no referrer in the table. One boolean distinguishes a signed-in reader from an anonymous one, and
that is the whole of the attribution — so the only questions it can answer are "which lessons get
opened" and "which never do".

That constraint is in the schema rather than in a policy document, which is the difference between a
privacy property and a privacy intention.
