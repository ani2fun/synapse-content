---
title: "System context"
summary: "C4 level 1: who uses Synapse, which outside systems it depends on, and where its boundary sits. Includes the walkthrough that drills from context to containers to components."
essential: true
---

# System context

> **You'll be able to:** name the four kinds of people Synapse serves and what each one needs from
> it; list the outside systems it depends on and what happens when each one fails; and use the
> walkthrough below to drill from the whole system down to the code's bounded contexts.

## How Part 2 is organised

Part 2 follows the [C4 model](https://c4model.com): four zoom levels, each answering one question.

| Level | Question | Where |
| --- | --- | --- |
| 1 · System context | Who uses it, and what does it depend on? | this page |
| 2 · Containers | Which separately running pieces make it up? | [Containers](/synapse/synapse-features/containers/containers) |
| 3 · Components | What is inside each container? | [The server hexagon](/synapse/synapse-features/components/the-server-hexagon) and the rest of *Components* |
| 4 · Code | How is one component actually written? | [Data design](/synapse/synapse-features/code/data-design) and the rest of *Code* |

Deployment, decisions and appendices follow the four levels. Every box on every diagram is drawn
from the source code, and every count matches it.

## The walkthrough

This is the whole system at three zoom levels in one diagram. Click a box with a link badge to
drill down a level; use ◀ ▶ ⌂ and the board menu to walk back out.

```d2 boards name="c4-synapse" root="System Context"
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  external: { style: { fill: "#f8fafc"; stroke: "#94a3b8"; font-color: "#475569"; stroke-dash: 3 } }
}

reader: "Reader\n[Person · anonymous]" { class: client; shape: person }
learner: "Learner\n[Person · signed in]" { class: client; shape: person }
contributor: "Contributor\n[Person]" { class: client; shape: person }
admin: "Admin\n[Person]" { class: client; shape: person }

sys: "Synapse\n[Software system]" {
  class: svc
  link: layers.containers
}

github: "GitHub\n[content repos · pull requests]" { class: external }
idp: "Keycloak\n[identity provider]" { class: external }
cdn: "Cloudflare\n[CDN edge]" { class: external }
quotes: "Quote feed\n[RSS]" { class: external }

reader -> cdn: "reads, runs code"
learner -> cdn: "submits, saves notes"
admin -> cdn: "manages access and sources"
cdn -> sys: "HTTPS"
contributor -> github: "git push, reviews PRs"
contributor -> sys: "suggests an edit"
sys -> github: "pulls content, opens PRs"
sys -> idp: "verifies sign-in"
sys -> quotes: "header quote"

layers: {
  containers: {
    direction: right

    reader: "Reader\n[Person]" { class: client; shape: person }

    browser: "Browser\n[viz-wasm · Monaco · islands]" {
      class: client
    }

    cdn: "Cloudflare\n[CDN edge]" { class: external }

    origin: "Origin server\n[Rust · axum · tokio]" {
      class: svc
      link: _.layers.components
    }
    web: "Web tier\n[Astro 7 SSR · Preact islands]" { class: svc }
    d2: "d2-render\n[Go sidecar]" { class: svc }
    sync: "Content sync\n[git-sync]" { class: svc }
    sandbox: "Code sandbox\n[go-judge]" { class: svc }
    db: "Application store\n[PostgreSQL 17]" { class: data; shape: cylinder }
    files: "Content checkouts\n[primary + satellite cache]" { class: data; shape: stored_data }
    coach: "Coach LLM\n[Ollama · local only]" { class: external }

    github: "GitHub" { class: external }
    idp: "Keycloak" { class: external }

    reader -> browser
    browser -> cdn: "HTTPS"
    cdn -> origin: "pages, API, media"
    origin -> web: "page requests (fallback)"
    web -> origin: "renders against the API"
    web -> d2: "draws d2 fences"
    origin -> d2: "walkthrough boards"
    origin -> sandbox: "run code"
    origin -> db: "SQL"
    origin -> files: "reads lessons"
    sync -> files: "checks out every 60s"
    github -> sync: "primary repo"
    origin -> github: "satellite tarballs, PRs"
    origin -> idp: "JWKS"
    origin -> coach: "chat" { style.stroke-dash: 3 }
  }

  components: {
    direction: down

    origin: "Origin server\n[12 bounded contexts]" {
      class: svc

      catalog: "catalog" { class: svc }
      blog: "blog" { class: svc }
      authoring: "authoring" { class: svc }
      execution: "execution" { class: svc }
      submission: "submission" { class: svc }
      identity: "identity" { class: svc }
      progress: "progress" { class: svc }
      insights: "insights" { class: svc }
      notes: "notes" { class: svc }
      canvas: "canvas" { class: svc }
      tutoring: "tutoring" { class: svc }
      platform: "platform\n[cross-cutting]" { class: svc }

      submission -> execution: "judge each case"
      submission -> progress: "accepted marks solved"
      catalog -> insights: "records a view"
    }

    db: "PostgreSQL" { class: data; shape: cylinder }
    sandbox: "go-judge" { class: svc }
    files: "Content checkouts" { class: data; shape: stored_data }
    github: "GitHub" { class: external }
    idp: "Keycloak" { class: external }

    origin.catalog -> files: "walks"
    origin.execution -> sandbox: "/run"
    origin.authoring -> github: "commit + PR"
    origin.identity -> idp: "JWKS"
    origin.submission -> db
    origin.progress -> db
    origin.notes -> db
    origin.canvas -> db
    origin.insights -> db
    origin.authoring -> db: "edit requests"
    origin.catalog -> db: "source registry"
    origin.blog -> files
  }
}
```

## The people

| Person | Signed in? | What they do | What it needs from Synapse |
| --- | --- | --- | --- |
| **Reader** | no | reads lessons and posts, runs any code block, opens the visualiser and the `/viz`, `/d2` and `/mermaid` labs | pages that load fast from anywhere; runs that come back quickly |
| **Learner** | yes | edits code in place, submits solutions to the judge, keeps ✓ progress, Notes and Think canvases across devices, reads private books it is listed for | its own state, kept per account |
| **Contributor** | yes, on an allowlist | fixes a lesson with **Suggest an edit**, which opens a pull request; or pushes to a content repository directly | the repository stays the only source of truth |
| **Admin** | yes, named in `ADMIN_USERS` | manages the submit allowlist, content editors, registered content repositories and their readers, and reads lesson-view counts | one screen, `/admin`, instead of SQL |

The split that shapes the whole system is the first row. **Reading and running never need an
identity.** An anonymous reader can run code, with a smaller time budget and a stricter rate limit,
but never needs to sign in. That is what lets the read path be cached at the edge and keep working
when the identity provider is down.

## The outside systems

| System | What Synapse uses it for | When it fails |
| --- | --- | --- |
| **GitHub** | Hosts every content repository. The primary one is cloned by git-sync; the satellites are fetched as tarballs. Also the forge that **Suggest an edit** opens pull requests on, and the upstream sign-in provider behind Keycloak. | Existing content keeps serving from the last checkout; new pushes and new edit proposals wait. |
| **Keycloak** | Signs people in (authorization code with PKCE). The server verifies tokens locally against cached signing keys. | Signed-in features return 503 (*cannot check*), not 401 (*not allowed*). Reading and running keep working. |
| **Cloudflare** | CDN in front of the origin: caches public pages and lesson JSON, and names the real client IP for rate limiting. | Requests go to the origin directly, slower; nothing is lost. |
| **Quote feed** | The quote in the page header, from an RSS feed. | A built-in fallback list is used. |

Keycloak runs in the same homelab, but it is drawn **outside** the boundary on purpose. It is a
separate deployment with its own lifecycle, and Synapse depends only on its public contract (OIDC
and JWKS). Two
smaller dependencies are left off the diagram because only the reader's browser touches them: the
D2 icon CDN and the web fonts.

## Where the boundary sits

The most important thing about the boundary is what it leaves **out**: the content. Lessons,
diagrams, problems and their hidden test suites live in git repositories on GitHub, not in a
database inside Synapse. The platform reads them; it never writes to them. Even **Suggest an edit**
does not write content — it opens a pull request, and the change reaches readers only after a human
merges it.

That one decision is why the read path is cacheable. A lesson is derived from a known commit, so a
cached copy is a correct answer for that commit rather than a guess about freshness.

### Three traffic classes

Almost every design decision inside the boundary follows from one observation: the system serves
three kinds of request that have nothing in common.

| Class | Share | Character | What it needs |
| --- | --- | --- | --- |
| **Reads** — lessons, diagrams, search | ~99% | the same for every reader; changes only when an author pushes | never to reach the origin |
| **Runs** — execute this code | ~1% | CPU-bound, interactive, *hostile* | isolation and a bounded blast radius |
| **Writes** — submissions, progress, notes, canvases, edits | ≪1% | durable, per account | correctness, not speed |

The shares are estimates from the traffic shape, not a measurement. Designing for their average
would produce something mediocre at all three. The [containers](/synapse/synapse-features/containers/containers)
page shows how each class gets its own path.

<details>
<summary>Why is the browser a container, when the user owns it?</summary>

Because Synapse ships code that runs there. The visualisation engine is Rust compiled to
WebAssembly (`viz-wasm`), and the code editor, the diagram labs and the tracers all run in the
reader's browser. C4 draws a container wherever code you deploy runs as its own process — and a
browser tab running your bundle is exactly that, even though you do not operate the machine.

</details>
