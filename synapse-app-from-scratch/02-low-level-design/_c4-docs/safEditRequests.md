---
title: content_edit_request
kind: Component
technology: table
---

## `content_edit_request`

```sql
create table content_edit_request (
    id          uuid        primary key,
    username    text        not null,
    lesson_path text        not null,
    file_path   text        not null,
    branch      text        not null unique,
    attempt     int         not null,
    pr_number   bigint,
    pr_url      text,
    state       text        not null,
    commits     int         not null default 1,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now()
);

create index content_edit_request_owner_page on content_edit_request (username, lesson_path);
```

One row per (contributor, page, attempt): the branch the server commits to and the pull request it
opened. Both reads are owner-scoped — *"is there an open request from this person on this page"* (the
reuse probe, on every submit) and *"every request of mine"* (the account page) — which is what the
index serves.

### The reuse rule lives on this table

A second edit to the same page by the same person, while their pull request is still open, becomes
another **commit on the same branch** rather than a second pull request. Once that request is merged
or closed the row stops being reusable and the next edit allocates `attempt + 1` — which is what puts
the `-2`, `-3` suffix on the branch name.

`branch` is `unique` because it is the value the forge keys on. Two rows claiming one ref would mean
two pull requests silently sharing commits, which is the kind of bug that is invisible until someone
merges the wrong one.

### The stored state is a cache, not the truth

`state`, `pr_number` and `commits` record what the forge said last time. The forge is asked for the
live state before anything is reused, because a maintainer can merge or close a pull request without
this database hearing about it. Treating the row as authoritative would mean committing to a branch
whose request closed yesterday.

Reconciliation is therefore lazy — on the contributor's next submit for that page, or their next
account-page load. A webhook is the obvious upgrade; the row is shaped so adding one changes when it
is refreshed, not what it stores.

### Nullable pull-request columns are load-bearing

`pr_number` and `pr_url` stay nullable so a **dry-run** deployment records the branch it *would* have
pushed and opens nothing. That is what lets development, CI and the end-to-end suite exercise the
whole flow — gate, drift guard, validation, branch derivation, stored history — without a credential
anywhere near them.
