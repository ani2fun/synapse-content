---
title: "Learner state"
summary: "C4 level 3 for the four small contexts that remember things: progress, notes, canvas and insights. Why each is its own context, why none of them has a domain layer, and how the browser and the server share the work."
essential: true
---

# Learner state

> **You'll be able to:** say what each of the four state-keeping contexts stores and why they do not
> share a table; explain how a note survives a dropped connection; and name the one table that never
> records who you are.

Four contexts hold small amounts of per-reader or per-lesson state. Each is a few files — a port, a
Postgres adapter and a router — with **no `domain/` layer**, because a row here is a user, a lesson
path, some content and a timestamp, and nothing about it has behaviour worth modelling. That is the
proportionality rule from [the server hexagon](/synapse/synapse-features/components/the-server-hexagon)
at its clearest.

| Context | Table | Key | What a row is | Written by |
| --- | --- | --- | --- | --- |
| `progress` | `problem_progress` | (user, lesson) | a ✓ tick | the reader's sidebar, and an accepted submission |
| `notes` | `problem_notes` | (user, problem) | **one** living Markdown note per problem, replaced on each save | the Notes tab |
| `canvas` | `canvas_entries` | id, indexed by (user, problem, time) | **one of many** saved snapshots of a plan, as JSON | the Think pane's Save |
| `insights` | `lesson_view` | id | one lesson served | the catalog, on every resolved lesson |

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

browser: "Browser" {
  sidebar: "reader sidebar\n[✓ ticks]" { class: client }
  notes_tab: "Notes tab\n[local copy first]" { class: client }
  think: "Think pane\n[local draft]" { class: client }
}

origin: "Origin server" {
  progress: "progress\n/api/progress" { class: svc }
  notes: "notes\n/api/notes" { class: svc }
  canvas: "canvas\n/api/canvas" { class: svc }
  insights: "insights\n/api/admin/lesson-views" { class: svc }
  catalog: "catalog" { class: svc }
  submission: "submission" { class: svc }
}

db: "Postgres" {
  pp: "problem_progress" { class: data; shape: cylinder }
  pn: "problem_notes" { class: data; shape: cylinder }
  ce: "canvas_entries" { class: data; shape: cylinder }
  lv: "lesson_view" { class: data; shape: cylinder }
}

browser.sidebar -> origin.progress
browser.notes_tab -> origin.notes: "when signed in"
browser.think -> origin.canvas: "Save"
origin.submission -> origin.progress: "SolvedRecorder"
origin.catalog -> origin.insights: "record_view"
origin.progress -> db.pp
origin.notes -> db.pn
origin.canvas -> db.ce
origin.insights -> db.lv
```

## Why four contexts and not one

Each could have been a column somewhere else, and each was kept out on purpose.

- **`progress` is not `submission`.** A submission is the reader's *code*; a tick is a fact about the
  reader. A problem is ticked by an accepted verdict, but a prose lesson is ticked by the reader, and
  `DELETE /api/progress` must clear ticks without touching submission history.
- **`notes` is not `canvas`.** A note is *one living document* per problem that each save replaces. A
  canvas entry is a *snapshot* the reader chose to keep, one of many. Sharing a table would force one
  of those shapes onto the other.
- **`canvas` is not `submission`.** A canvas is the plan the reader made before writing code. It is
  never judged and outlives any submission.
- **`insights` is not `catalog`.** The catalog's only output port is a filesystem; giving it a
  Postgres port would make it a dual store for a concern that is not content.

Each owns its own Postgres port, so no context becomes a second store for somebody else's concern.

## The browser does half the work

Signing in is never required to *think*. The Think pane keeps an in-progress **draft** in
`localStorage`, keyed by username and problem path, so a reader who half-fills it and reloads — or
comes back tomorrow — keeps what they wrote, signed in or not. Only **Save** turns the draft into an
entry on the server.

Notes go further. The local copy is written **first** on every edit, so a note survives a
dropped connection or a closed tab, and it carries two facts that make syncing safe:

- `synced` — whether the server already has this exact text. An unsynced copy is pushed the next time
  the problem is opened, so a save lost to a closing tab is late rather than gone.
- `base` — the server's `updatedAt` this copy started from. If the server still says `base`, nobody
  else has written since, and local edits can go up without a conflict.

Both stores key by **username** as well as path. A shared browser never shows one account's notes or
plan to the next, and anonymous drafts live under their own name and are never adopted on sign-in —
what the previous person typed is not this account's work.

## The table that does not know you

`lesson_view` has four columns: an id, a lesson path, a timestamp, and one boolean, `authed`. There is
no user id, no session, no IP address and no referrer. The only questions it can answer are "which
lessons get opened" and "which never do" — content popularity, not user tracking.

That constraint lives in the schema rather than in a policy document, which is the difference between
a privacy property and a privacy intention. It is also why deleting an account has nothing to erase
here. An admin reads the top paths at `/api/admin/lesson-views`.

## Resetting and erasing

`/account` exposes each store's erase on its own — reset progress, erase submissions — and an "erase
all data" that calls all four (submissions, canvases, notes, progress) before anything else. Deleting
the account runs that erase, then deletes the identity, then signs out; the order is in
[Identity and access](/synapse/synapse-features/components/identity-and-access).
