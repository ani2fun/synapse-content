---
title: "Containers"
summary: "C4 level 2: the nine separately running pieces of Synapse, what each one owns, and how reads, runs and writes each take their own path through them."
essential: true
---

# Containers

> **You'll be able to:** name every container in Synapse and the technology it runs on; trace a
> read, a run and a write through them; and explain why the origin is one process with one replica
> rather than a set of services.

A **container** in C4 is anything that runs as its own process and holds code or data you deploy:
an application, a database, a sidecar. It is not a Docker container, although here most of them
happen to be one.

## The picture

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  external: { style: { fill: "#f8fafc"; stroke: "#94a3b8"; font-color: "#475569"; stroke-dash: 3 } }
}

browser: "Browser\n[Astro pages · Preact islands · viz-wasm]" { class: client }
cdn: "Cloudflare\n[CDN]" { class: edge }

pod: "synapse pod" {
  style.stroke-dash: 3
  style.fill: "#fbfcfe"
  origin: "Origin server\n[Rust · axum]" { class: svc }
  web: "Web tier\n[Astro 7 SSR · Node 22]" { class: svc }
  d2: "d2-render\n[Go]" { class: svc }
}

sandbox: "Code sandbox\n[go-judge]" { class: svc }
db: "Application store\n[PostgreSQL 17]" { class: data; shape: cylinder }
files: "Content checkouts\n[git-sync PVC + satellite cache]" { class: data; shape: stored_data }
sync: "Content sync\n[git-sync]" { class: svc }
idp: "Keycloak" { class: external }
github: "GitHub" { class: external }

browser -> cdn: "HTTPS"
cdn -> pod.origin: "cache miss"
pod.origin -> pod.web: "page (fallback)"
pod.web -> pod.origin: "API"
pod.web -> pod.d2: "d2 fence"
pod.origin -> pod.d2: "boards"
pod.origin -> files: "read"
pod.origin -> sandbox: "run"
pod.origin -> db: "write"
pod.origin -> idp: "JWKS"
pod.origin -> github: "tarballs · PRs"
github -> sync
sync -> files
```

## The containers

| Container | Technology | Owns | Runs as |
| --- | --- | --- | --- |
| **Origin server** | Rust · axum 0.8 · tokio | the front door: every API route, files, SEO, security headers, rate limits; 12 bounded contexts | process 1 in the `synapse` pod |
| **Web tier** | Astro 7 SSR on Node 22 | server-rendered HTML for every page | process 2 in the same pod |
| **d2-render** | Go | draws D2 fences and walkthrough boards to SVG, cached by content | sidecar in the pod |
| **Content sync** | git-sync v4.4 | clones the primary content repository and checks out new commits every 60 s | its own deployment, writing to a volume |
| **Content checkouts** | files on disk | the primary checkout, plus a tarball cache of every registered satellite repository | a volume the origin mounts read-only |
| **Code sandbox** | go-judge | compiles and runs untrusted code under CPU, wall-clock, memory and process caps | its own deployment, egress denied |
| **Application store** | PostgreSQL 17 | the only state that cannot be rebuilt from git: 10 tables | the cluster's shared Postgres |
| **Browser** | Astro pages, Preact islands, Monaco, `viz-wasm` | the editor, the visualiser, the diagram labs, the tracers | the reader's tab |
| **Coach LLM** | Ollama (`llama3.1`) | answers the coach chat | **local development only**, off in production |

Keycloak, GitHub and Cloudflare are not containers of Synapse; they are the outside systems from
[System context](/synapse/synapse-features/system-context/system-context).

## Three paths through them

Every request belongs to one of three traffic classes, and each class has its own path.

**A read** — a lesson, a post, a search, a diagram. The CDN answers most of these. A miss reaches
the origin, which forwards page requests to the web tier; the web tier renders against the origin's
own content API and asks d2-render for any D2 fence, which it inlines as SVG. Nothing on this path
touches Postgres except one append-only readership row.

**A run** — execute this code. The origin checks the rate limit and the admission gate (at most 6
runs in flight, 2 per caller), then sends the program to go-judge. Nothing is stored. An anonymous
run gets half of each language's CPU and wall-clock budget.

**A write** — a judged submission, a ✓ tick, a note, a Think canvas, an edit proposal. These need a
signed-in caller, go to Postgres, and are never cached. A submission is accepted with `202` and
judged in the background; the
[submission lifecycle](/synapse/synapse-features/code/the-submission-lifecycle) follows it end to end.

## Two processes behind one front door

The origin and the web tier are one container image running two processes (`dev-tools/start.sh`).
The origin is the only one the outside world talks to. It handles every route it owns — `/api/*`,
`/media`, `/simulators`, `/content-assets`, `/robots.txt`, `/sitemap.xml` — and forwards everything
else to the web tier as the router's **fallback**.

```d2
direction: right

classes: {
  edge: { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:  { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
}

cdn: "CDN" { class: edge }
origin: "axum front door\n/api · /media · /simulators · /content-assets\nrobots · sitemap\nsecurity headers · compression" { class: svc }
web: "Astro SSR\n(Node, same pod)" { class: svc }

cdn -> origin
origin -> web: "fallback: everything else"
web -> origin: "renders against the public API"
```

Two things follow from that ordering. A registered route can never be shadowed by a page path, so
a lesson called `api` cannot break the API. And the web tier renders by calling the same public
content API a browser would — a real loopback hop, paid for the property that there is exactly one
content contract.

Either process dying takes the container down (`wait -n` in the start script). Half-alive is the
worst state: one half gone would mean every page is a 502 while the orchestrator, which restarts
only a container that exits, sees nothing wrong.

## Why d2-render is its own container

D2 used to be compiled in the reader's browser, which cost 5.9 MB gzipped on a diagram-heavy lesson.
Then it moved into each content repository's CI, which committed the SVGs under `_media/d2` (ADR RS007).
Both are gone (ADR RS009). The web tier now **asks** a sidecar while it renders
the page, and inlines the SVG it gets back. The reason is memory: the WebAssembly build of d2 peaked
at about 5.2 GB on one 23-diagram lesson, against a 256 MiB web container, while the native engine
in the sidecar peaks at about 160–170 MB inside its own limit. A render spike can no longer take the
pages down with it.

A miss is not an error. If the sidecar is down or refuses a malformed diagram, the page ships the
source and the reader's browser draws it — the same floor every D2 miss lands on.

## One process, one replica, on purpose

All 12 bounded contexts ship as **one binary**. Splitting a codebase into bounded contexts buys
clean seams and the *option* to extract; splitting the deployment buys independent scaling at the
cost of a network between every call. Synapse takes the first and not yet the second. The
contexts themselves are [the next level down](/synapse/synapse-features/components/the-server-hexagon).

The deployment runs `replicas: 1`, and that is a correctness requirement, not a resource
compromise. The rate limiter and the admission gate keep their counters in process memory, so two
replicas would mean twice the intended limits. Scaling out means moving that state first — a
written-down trigger, covered in
[Scaling and maintainability](/synapse/synapse-features/deployment-and-operations/scaling-and-maintainability).

The one context designed to leave first is `execution`. It is CPU-bound, runs hostile input, and
its resource needs differ from the rest by an order of magnitude. Its port is already a trait and
its adapter already speaks HTTP to a separate process, which is why the sandbox is already a
separate container.

## What each container refuses to do

| Container | Fails how | Why |
| --- | --- | --- |
| Origin | **fails fast without Postgres** — no boot | the system of record is not optional |
| Origin | **degrades without Keycloak** — 503 on signed-in routes, never 401 | "I cannot check" is not "you are not allowed" |
| Origin | mounts a disabled feature **not at all** — the coach, the editor, the source registry and the d2 proxy are absent routes when switched off | a structural 404 cannot be defeated by a misread flag |
| Web tier | on a d2-render miss, ships the source | the browser can still draw it |
| Code sandbox | denies **all** egress; stops at the first failing test case | it runs code written by strangers |
| Content sync | on a failed fetch, keeps the last checkout | readers keep the last good content |

## 🧱 Container reference

<details>
<summary>Each container in detail — what it owns, the property it protects, and its honest limits</summary>

### Origin server
`Rust · axum 0.8 · tokio` · prod image `ghcr.io/ani2fun/synapse-rs`, port 8080

Stateless by construction apart from two in-memory counters (rate limit and admission). Every
response it sends — API, proxied page, file or error — passes through the same layer stack:
telemetry outermost, then a 2-minute timeout and a 1 MiB body cap, then compression (gzip or
deflate above 1 KiB), then security headers.

Public content GETs are stamped `public, max-age=60, stale-while-revalidate=600`: sixty seconds
because that is how often new content can arrive. Anything per-user — `/api/me`, `/api/run`,
submissions, the coach — is never stamped. A shared cache in front of a per-user response is one of
the most damaging mistakes available in web architecture, and the narrowness of the rule is the
defence.

### Web tier
`Astro 7 SSR · Node 22 · Preact islands`

Every page is server-rendered: the prose arrives as HTML in the first response. Hashed assets are
served `immutable` for a year. Interactivity hydrates per feature, and everything expensive — the
editor, the sign-in client, the diagram engines, the tracers, the visualisation bundle — is a dynamic
import a reader downloads only when they use it. [The web tier](/synapse/synapse-features/containers/the-web-tier)
has the detail.

### d2-render
`Go` · prod sidecar on port 8390, disk cache at `/var/cache/d2-render`

Content-addressed: a diagram is keyed by the hash of its source, so the same diagram in two lessons
is drawn once. Walkthrough boards are served through `/api/synapse/d2/{hash}/{slug}` as
`immutable` — the path *is* the content.

### Content sync and the checkouts
`git-sync v4.4.0`, period 60 s

git-sync clones the primary repository, and when the remote moves it checks the new commit out and
flips a symlink atomically. The origin reads through `SYNAPSE_ROOT=/content/current` and re-reads
the commit on each request, so new prose appears with no restart and no purge. Satellite
repositories (ADR RS005) are not git-synced; the origin fetches them as tarballs from the GitHub API
into its own cache on the same 60-second cycle, because adding a repository must not need a
redeploy. [The content pipeline](/synapse/synapse-features/containers/the-content-pipeline) traces
both routes.

### Code sandbox
`go-judge` · its own deployment, pinned to one node

Requests 250m CPU and 512 MiB, capped at 2 CPUs and 2 GiB. The network policy denies all egress.
Each run is capped at 15 s CPU, 30 s wall clock, 512 MiB memory and 256 processes by default, with
anonymous callers at half the time. go-judge needs a privileged container for its own sandboxing
syscalls; that, and the fact that this is process-level isolation rather than a separate kernel per
run, is the honest limit. It is right for a personal deployment with a handful of signed-in users and
would not be right at public scale, where the next step is a hardened runtime.

### Application store
`PostgreSQL 17`

Ten tables: submissions and the submit allowlist; lesson views; problem progress; content edit
requests and the editor allowlist; content sources and their readers; Think canvases; problem notes.
Books are not rows — they are Markdown on disk. The schema is in
[Data design](/synapse/synapse-features/code/data-design).

### Browser
`Astro pages · Preact · Monaco 0.52 · Mermaid 11 · viz-wasm`

The code that runs on the reader's machine: the code editor, the step-through visualiser (Rust
compiled to WebAssembly), the language tracers, the `/viz`, `/d2` and `/mermaid` labs, and the
D2 fallback renderer.

### Coach LLM
`Ollama · llama3.1` · not deployed

The coach chat (`/api/tutor/*`) is mounted only when `TUTOR_ENABLED` is set, which production
leaves unset. It is a development feature today.

</details>

<details>
<summary>The diagram would look the same whether these were nine services or one binary. So what is it telling you?</summary>

It tells you about **coupling**, not about topology. A box on a C4 container diagram has its own
runtime and talks to its neighbours through a declared contract. Whether the origin's contexts are
one process or twelve is a deployment decision, driven by scaling and failure requirements, not by
how the code is organised. Draw the boundaries first and choose the topology from evidence.

</details>
