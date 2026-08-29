---
title: "Architecture docs that live in the lesson"
summary: "A diagram drawn from a fence in this file, and the write-up of every box in it directly underneath — one artifact, one commit, no service to keep running."
---

# Architecture docs that live in the lesson

An architecture diagram is only half a document. The other half is what each box *is*: what it owns,
what it promises, and what happens when it fails. Below is a minimal client–server app — a **User**
talks to a **Client** (the app in their browser), which talks to a **Server & DB** — followed by the
write-up of every box in it.

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
}

user: "User\n[Person]" {
  class: client
  shape: person
}

client: "Client\n[Browser SPA]" {
  class: svc
}

server: "Server & DB\n[API + Postgres]" {
  class: svc
}

user -> client: "uses (HTTPS)"
client -> server: "API calls (reads / writes)"
```

Both halves are the same file. The picture above is a fenced `d2` source a few lines up in this
lesson's Markdown, drawn on demand by a renderer beside the application; the write-ups are the prose
below. Nothing is generated ahead of time and nothing is committed alongside — which means the
diagram cannot drift from the words about it, because editing either one is editing this lesson.

That is worth saying plainly, because it was not always true here. These write-ups used to live in a
sidecar folder and appear only when a reader clicked the matching box in a diagram served by a
separate application. It read well and it hid well: nothing in the prose, in search, or in the
sitemap knew the text existed, and a reader who did not think to click never met it.

They are still folded away below — reference material earns a click, not a scroll past. The
difference is where the text lives. It is in this document now, so search finds it, the sitemap
carries it, and opening it is a disclosure rather than a fetch from somewhere else.

## The write-ups

<details>
<summary>3 components — what each one owns, the invariant it protects, and where it breaks</summary>

### User
`Actor` · `Web browser`

The **User** is the person the app exists for — someone opening it in a web browser to get something done.

In C4 terms this is an **actor**: a role that lives *outside* the system's boundary. The user never talks to the
server directly; everything they do goes through the **Client** (the box this one points to).

**What to notice**

- The arrow **User → Client** is labelled *uses (HTTPS)* — every interaction is a request sent from the browser.
- The user has no idea whether there's one server or a thousand behind the Client. That's the whole point of a
  boundary: the architecture inside can change completely without changing what the user sees.

### Client
`Container` · `Browser SPA`

The **Client** is the single-page app that runs in the user's browser: it renders the UI, holds view state, and
turns clicks into API calls.

**Responsibilities**

- Render the interface and react to user input.
- Call the **Server & DB** over HTTP for anything it can't do locally — data, authentication, persistence.
- Keep the experience fast: cache what it can, show optimistic UI, and avoid a round-trip when it doesn't need one.

**Where it breaks first.** A pure client can't be the source of truth — two browsers can't see each other's writes
until the server tells them. The moment you need shared, durable state, you need the box it points to.

### Server & DB
`Container` · `API server + PostgreSQL`

The **Server & DB** is where the truth lives. It answers the Client's requests (an API) and stores the data
durably (a database).

**Responsibilities**

- Accept requests from the Client, validate them, and enforce the rules the client can't be trusted to keep.
- Read and write the database — the single **source of truth** that every client agrees on.
- Stay correct under concurrency: many clients, one consistent story.

**Where it grows.** In a real system this one box splits apart — a stateless API tier you scale horizontally, a
cache in front of the hot reads, read replicas, a queue for async work. Start here; add those pieces only when a
real bottleneck demands them.

</details>

## What you give up, and what you get

You lose the per-box aim. Clicking *User* used to open *User*; now one disclosure opens all three,
and finding the right one is a scan rather than a click. For three boxes that is nothing. For
thirty it is the reason the section is collapsed at all — and why the diagram beside it is a
[walkthrough](/synapse/synapse-features/reading-a-lesson/d2-walkthroughs): one source, a tree of
boards, and a reader who clicks their way down a level at a time.

What you get is that the words are *in the document*. They are indexed, linkable, and printable;
they survive the diagram being redrawn in another language; and they cannot be orphaned by a
service going down, because there is no service.
