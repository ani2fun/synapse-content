---
title: identity
kind: Component
technology: Rust
---

## `identity`

Verifies bearer tokens against cached signing keys and canonicalises usernames exactly once. It also owns account deletion, which authenticates as a scoped service account limited to managing users in one realm — so a leak of the application's credentials cannot take over the identity provider.
