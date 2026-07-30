---
title: lesson_view
kind: Component
technology: table
---

## `lesson_view`

```sql
create table lesson_view (
    id          bigserial   primary key,
    lesson_path text        not null,
    viewed_at   timestamptz not null default now(),
    authed      boolean     not null
);

create index lesson_view_path_recency on lesson_view (lesson_path, viewed_at desc);
```

Append-only. The catalog writes one row when it serves a lesson; an admin-only endpoint reads the
top paths, most recent first — which is exactly what the index is shaped for.

### What is deliberately absent

No user id. No session id. No IP address. No referrer. `authed` is one bit distinguishing a
signed-in reader from an anonymous one, and that is the entire attribution.

The questions this table can answer are therefore *"which lessons get opened"* and *"which never
do"* — and it is structurally incapable of answering "what did this person read". That is a stronger
guarantee than a privacy policy, because it does not depend on anyone honouring it.

### The cost of append-only

It is the one table that grows with **traffic** rather than with engagement, so it is also the first
one that will need attention: a time-partition, or a nightly roll-up into counts with the raw rows
aged out. Neither is worth building before the row count justifies it, and the shape above does not
make either harder later.
