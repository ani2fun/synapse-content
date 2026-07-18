---
title: Content sidecar
kind: Worker
technology: git-sync
---

## Content sidecar

The mechanism that makes `git push` a deployment.

It clones the content repository beside the application, polls every sixty seconds, and — when the
remote has moved — checks the new commit out and flips a symlink atomically. The application reads
through that symlink and re-reads the commit SHA on every request, so new prose appears without a
restart, a redeploy, or a cache purge.

### Why the SHA matters

The commit hash is used as the content **version**, which turns lesson responses into
version-addressed derived data. That is what makes them safe to cache: a cached response is a correct
answer *for the version it was derived from*, so a stale copy is a slightly old truth rather than a
wrong one.

You can observe the whole mechanism from outside. The repository's `main` and the symlink inside the
running pod point at the same commit — the pipeline is verifiable end to end without logging into
anything.
