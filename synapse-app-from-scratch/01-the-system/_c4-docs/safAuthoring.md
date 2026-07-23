---
title: authoring
kind: Component
technology: Rust
---

## `authoring`

In-app prose editing. An allow-listed reader edits a lesson's Markdown inside Synapse, previews it,
and submits; this context opens — or reuses — a pull request against the content repository on their
behalf. The repository stays the single source of truth and every word still passes a human review.

Four ports, all use-case shaped rather than technology shaped: `LessonSource` (the file as it is on
disk this instant, frontmatter fence included), `ContentEditors` (a **separate** allowlist from the
submit one), `EditRequestRepository` (branch, attempt, pull-request state) and `ContentForge`
("commit this file, open a pull request" — not "PUT /contents, POST /pulls").

That last shape is what makes a credential-free dry-run adapter a first-class citizen rather than a
mock: dev, CI and the end-to-end suite run the entire flow — gate, drift guard, validation, branch
derivation, stored history — and skip only the forge call.

There is no `git` binary and no working copy. Every forge operation is a stateless HTTP call whose
failure leaves nothing to clean up, which is the property a pod that can be evicted mid-request
needs.
