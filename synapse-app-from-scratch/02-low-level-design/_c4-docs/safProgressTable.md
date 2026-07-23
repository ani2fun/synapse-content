---
title: problem_progress
kind: Component
technology: table
---

## `problem_progress`

```sql
create table problem_progress (
    user_id      text        not null,
    lesson_path  text        not null,
    completed_at timestamptz not null default now(),
    primary key (user_id, lesson_path)
);

create index problem_progress_user on problem_progress (user_id);
```

One row per (account, lesson) finished — a prose lesson read to the end, or a problem with an
accepted judged submission. `user_id` is the opaque OIDC subject, the same value `submissions`
stores.

### The composite key is the design

There is no surrogate id and no "completed" boolean, because the row's *existence* is the fact.
Marking a lesson done twice is an upsert on the primary key rather than a duplicate, so the client
can re-sync freely and the table cannot drift into two disagreeing rows for one lesson.

### Why it exists at all

The ticks used to live in `localStorage`. That made them per-device and invisible to the account —
a reader who finished a chapter on a laptop saw an empty sidebar on a phone, and clearing site data
erased the record of months of reading. Storage that survives a browser is the entire feature.

### It is convenience state, and it says so

`DELETE /api/progress` clears these rows and **nothing else**. Keeping the reset scoped is what lets
it be offered on the account page without a confirmation dialog full of warnings: a reader who
resets progress has not lost their submission history, because that history is a different table
with a different owner and a different meaning.
