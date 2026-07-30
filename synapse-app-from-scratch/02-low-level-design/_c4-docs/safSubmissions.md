---
title: submissions
kind: Table
technology: PostgreSQL
---

## `submissions`

One row per attempt. This is where the domain's state ADT flattens into columns — and, deliberately,
the only place it does.

```sql
create table submissions (
    id           uuid primary key,
    lesson_path  text        not null,
    language     text        not null,
    source       text        not null,
    user_id      text,
    created_at   timestamptz not null,
    status       text        not null check (status in ('pending', 'judging', 'completed')),
    outcome      jsonb,
    completed_at timestamptz,
    constraint completed_shape check
        ((status = 'completed') = (outcome is not null and completed_at is not null))
);

create index submissions_lesson_recency on submissions (lesson_path, created_at desc);
```

### The constraint is the design

`completed_shape` is a **biconditional**, not a null check. Read it as *"completed if and only if a
verdict and a completion time are present"*. That single line rules out two bad rows at once:

- a `pending` row that somehow carries a verdict, and
- a `completed` row with no verdict.

In the domain those states are unrepresentable because `Completed` is an enum variant that *owns*
its `outcome` and `at`. The constraint is that same invariant restated where the type system cannot
reach — anything writing to this table, including a hand-typed `UPDATE`, is held to it.

### How the ADT maps

| Domain state | `status` | `outcome` | `completed_at` |
|---|---|---|---|
| `Pending` | `'pending'` | `NULL` | `NULL` |
| `Judging` | `'judging'` | `NULL` | `NULL` |
| `Completed { outcome, at }` | `'completed'` | JSONB | set |

The inverse read fails loudly on an unrecognised `status` rather than defaulting — a value outside
the three means the database disagrees with the code, and guessing would hide that.

### Notes on the columns

- **`lesson_path`** is the joined path (`dsa/basics/two-sum`), not an array. The only query that
  matters is "recent attempts at this lesson", which the one index serves.
- **`user_id`** is nullable and stores the **opaque OIDC subject** — not a username. It is null for
  the anonymous submissions the deployment permitted before the allowlist gate was enforced.
- **`source`** stores the submitted code verbatim. There is no size column and no blob store; at
  this scale the text column is the simpler correct answer.
- **`outcome`** is JSONB in an **adapter-owned** shape that is deliberately *not* the wire DTO. It
  is externally tagged (`{"Rejected": {...}}`) for compatibility with the previous implementation's
  serialiser, so this schema could be adopted without rewriting a single stored row.
