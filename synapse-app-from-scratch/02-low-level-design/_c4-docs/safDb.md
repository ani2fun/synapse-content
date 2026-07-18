---
title: Submissions store
kind: Relational database
technology: PostgreSQL 17
---

## Submissions store

The system of record, and the only thing in the platform that grows without bound. Everything else
— lessons, diagrams, test suites — is derived data reconstructable from a git repository.

```mermaid
erDiagram
    SUBMISSIONS {
        uuid id PK
        text lesson_path
        text language
        text source
        text user_id "nullable — opaque OIDC sub"
        timestamptz created_at
        text status "pending | judging | completed"
        jsonb outcome "null unless completed"
        timestamptz completed_at "null unless completed"
    }
    SUBMISSION_ALLOWLIST {
        text username PK "lowercase IdP username"
        text note
        timestamptz granted_at
    }
    SUBMISSIONS }o..o| SUBMISSION_ALLOWLIST : "logical only — no FK, different identifiers"
```

Two tables. That is the whole schema.

### Why it is this small

The platform's largest asset by far is its content, and content is **not** in the database. Books
live as Markdown in a git repository, are pulled onto disk by a sidecar, and are re-indexed from the
filesystem whenever the commit changes. That single decision removes an entire class of schema — no
`books`, `chapters`, `lessons`, `revisions`, or `authors` tables — and replaces the write path for
authoring with `git push`.

What remains in Postgres is exactly the state that cannot be derived from a repository: **what a
reader attempted, and what the judge decided**.

### Capacity, honestly

At the current scale this database holds single-digit rows and a `pg_dump` is thirteen kilobytes.
Even at a million monthly readers the arithmetic stays undramatic — submissions arrive at well under
one per second, and a submission is a few kilobytes of source plus a small JSON verdict. This is a
table that gets partitioned by time long before it ever gets sharded.

The scarce resource is not capacity but **availability**: the database currently runs on
node-local storage on a single machine, which makes that machine a single point of failure for the
whole platform. That is discussed honestly in the
[homelab case study](/synapse/synapse-app-from-scratch/running-it/the-homelab-case-study).

### Migrations and adoption

Schema changes are embedded SQL migrations applied at boot, and the application **fails fast** if
the database is unreachable — the system of record does not degrade, unlike the identity provider,
which does.

The production schema was not created by these migrations. It was created by the previous
implementation's migration tool and then *adopted*: the migration bookkeeping table was
hand-baselined so the new tool considered both migrations already applied, and boot no-ops instead
of trying to re-create live tables. That procedure was rehearsed on a byte-for-byte copy of
production first — which is what proved a verdict written by the old implementation still decodes
correctly through the new one.
