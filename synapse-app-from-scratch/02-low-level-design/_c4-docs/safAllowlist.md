---
title: submission_allowlist
kind: Table
technology: PostgreSQL
---

## `submission_allowlist`

Who is permitted to submit-and-save. Reading and running code need no entry here; only the act of
storing an attempt against the shared judge does.

```sql
create table submission_allowlist (
    username   text        primary key,
    note       text,
    granted_at timestamptz not null default now()
);
```

Three columns, and the interesting one is the primary key.

### Why there is no foreign key

The obvious relational move — `submissions.user_id REFERENCES submission_allowlist(username)` — is
wrong here, because the two columns hold **different identifiers on purpose**:

| Column | Holds | Chosen because |
|---|---|---|
| `submissions.user_id` | the opaque OIDC `sub` | stable forever; survives a username change; never re-issued |
| `submission_allowlist.username` | the lowercase IdP username | a human has to be able to type it into an admin form |

A `sub` looks like `f7c1…-9b2e`. Granting access by pasting a UUID would be miserable and
error-prone, so grants are keyed by the name a person actually knows. The cost is that the
association is **logical, not referential** — the database will not enforce it, and the application
resolves it by canonicalising the username to lowercase exactly once, at the token verifier, so
both sides of the comparison are always in the same case.

This is a genuine trade: referential integrity given up in exchange for an admin surface a human can
operate. It is defensible at this scale precisely because the allowlist is small and hand-curated.

### Lifecycle

Grants are **live** — an insert takes effect on the next request, with no restart and no deploy. That
is a deliberate asymmetry with *admin* rights, which are configuration and can only change through a
commit and a rollout. A compromised admin session can therefore widen who may submit, but cannot
mint another admin.

### A wrinkle worth knowing

The migration seeds two development usernames so a fresh local database works out of the box. On a
production database created from these migrations they are inert — no such users exist in the real
identity realm — but they do appear in the admin panel and should be revoked. On the actual
production database the point is moot: the schema predates these migrations and was adopted by
baselining, so the seeds never ran.
