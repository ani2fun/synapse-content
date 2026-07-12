---
title: The anonymous seam — designing a feature around the auth you don't have yet
summary: How we shipped problem submissions before identity existed, by making user_id nullable on purpose — and closing the seam later without a migration of behavior.
publishedAt: 2026-07-02
tags: [architecture, design, identity]
readMinutes: 5
eyebrow: Engineering · Design Notes
---

# The anonymous seam

We wanted learners to **submit solutions and get judged** long before we wanted a login screen. Auth is
real work — an identity provider, token validation, a sign-in flow — and blocking a whole feature on it is
how roadmaps stall. So we designed submissions to *not need* identity, in a way that would accept it later
without changing behavior.

## Nullable on purpose

The `submissions` table got a `user_id` column that was **nullable from day one**. The domain modelled it as
`Option[UserId]`. Every submission worked anonymously; the column simply sat empty. This isn't laziness —
it's a **named seam**: a place the design explicitly leaves open for a capability that's coming.

## Closing it without a rewrite

When identity landed — Keycloak, JWKS token validation, a `GET /api/me` — closing the seam was almost
anticlimactic. The submit endpoint gained an **optional** bearer: present, it attaches the caller's id;
absent, the submission stays anonymous exactly as before. No behavior migration, no backfill, no flag day.
A signed-in reader's work now carries their identity; everyone else's still just works.

## The lesson

A good seam is invisible until you need it, and cheap to close when you do. `Option` in the domain and
`NULL` in the schema aren't gaps to apologize for — they're the shape of a feature you haven't built yet,
drawn deliberately so the one you have doesn't have to wait.
