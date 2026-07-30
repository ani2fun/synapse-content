---
title: submission
kind: Component
technology: Rust
---

## `submission`

The aggregate with the most interesting lifecycle in the system: accept in 202, judge in a detached task, poll for the verdict. Its two hard-won properties are that authorisation runs before anything is stored, so a rejected submission never creates a row, and that anything a dying process left unfinished is reconciled at the next boot — because a detached task cannot outlive its process.
