---
title: "Platform"
summary: "C4 level 3 for the cross-cutting context: the layer stack every response passes through, the file routes, the two proxies, and the limits that protect the sandbox. Flat on purpose, because it has no domain to model."
essential: true
---

# Platform

> **You'll be able to:** list the layers every response passes through, in order; name the four
> routes that serve files from the content checkouts; and explain why the rate limiter and the
> admission gate are two mechanisms rather than one.

`platform` is the twelfth context and the odd one out. It has no domain — no aggregate, no rules
about the subject matter — so it has no layers either. It is one flat folder of about twenty modules,
each owning one cross-cutting concern.

## The layer stack

Every response the origin sends — API, proxied page, file, or error — passes through the same layers.
`lib.rs::app()` composes them, outermost first:

```d2
direction: right

classes: {
  edge: { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:  { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
}

req: "request" { shape: oval }
telemetry: "telemetry\n[span per request]" { class: edge }
limits: "limits\n[2 min · 1 MiB]" { class: edge }
compress: "compression\n[gzip/deflate > 1 KiB]" { class: edge }
headers: "security headers\n[5, on every response]" { class: edge }
routes: "routes\n[API · files · d2 · SEO]" { class: svc }
fallback: "Astro proxy\n[fallback]" { class: svc }

req -> telemetry -> limits -> compress -> headers -> routes
routes -> fallback: "no route matched"
```

| Layer | Module | What it does |
| --- | --- | --- |
| telemetry | `telemetry.rs` | opens a span with a request id; service and adapter spans nest inside it, so a 500 can be traced to the request that caused it |
| limits | `limits.rs` | a 2-minute timeout and a 1 MiB body cap; inside telemetry, so a request killed by the timeout still produces a span |
| compression | `tower_http` | gzip or deflate above 1 KiB, at the origin — the edge would otherwise still pull uncompressed bytes across the tunnel |
| security headers | `security_headers.rs` | `nosniff`, `SAMEORIGIN` framing, a referrer policy, HSTS, and a CSP built from the identity issuer |
| content cache stamp | `content_cache_control.rs` | `public, max-age=60, stale-while-revalidate=600` on public content GETs only, and only on 200s |

The CSP is the one with history. It allows `self`, the Keycloak origin and a short list of named third
parties, so a misconfigured issuer shows up as a broken sign-in rather than a wildcard policy. Its
looser allowances are each tied to a real breakage: Google Fonts and inline theme scripts; `blob:`
workers for Monaco; `'unsafe-eval'` because the D2 worker builds its layout engine with
`new Function()`; and `'wasm-unsafe-eval'` for the visualisation engine.

## Routes that read the checkouts

Four routes serve files directly from the mounted content checkouts, without going through a context:

| Route | Serves | Cache | Gated like the book? |
| --- | --- | --- | --- |
| `/media/{*rest}` | each source's root `_media/` tree: images, video, rendered frames | `public, max-age=3600` | yes |
| `/simulators/{*rest}` | each source's `_simulators/` bundles, embedded as same-origin iframes | HTML 60 s, assets 1 h | no |
| `/content-assets/{*rest}` | a lesson's `_assets/_simulators/` widgets (ADR RS012) | `public, max-age=60` | yes |
| `/api/synapse/d2/{hash}/{slug}` | walkthrough boards from d2-render | `immutable`, 1 year | — |

All of them probe the mounted sources in order, first hit wins, and each guards against path traversal
per root. Media is path-addressed, not content-hashed, because authors replace files in place — which
is why it gets an hour rather than a year. The boards get a year because their path *is* their
content: `{hash}` is the hash of the D2 source.

## Two proxies

- **Astro proxy** (`astro_proxy.rs`) — the router's *fallback*. Every registered route wins first, so a
  page path can never shadow an API route, and the web tier's 404 page becomes the site's 404.
  Hashed assets it forwards are stamped `immutable` for a year.
- **d2-render proxy** (`d2_render_proxy.rs`) — mounted only when `SYNAPSE_D2_RENDER_URL` is set.
  GET-only, buffered, content type forced to SVG, and an unreachable renderer is a 502, never a
  crash.

## Protecting the sandbox

Two mechanisms, because they measure different things:

| | `RateLimiter` | `Admission` |
| --- | --- | --- |
| Counts | runs **per time window** | runs **in flight right now** |
| Keys | IP for anonymous callers (`client_ip.rs`), subject when signed in | the same keys |
| Defaults | anonymous 10/60 s; all anonymous 120/window; signed in 100/h | 6 total, 2 per caller |
| Refuses with | 429 | 503 when the sandbox is full (`SandboxBusy`), 429 when this caller is (`CallerBusy`) |

A rate limit cannot see how long a run holds the sandbox. Ten slow runs a minute from one address is
inside the budget and still several minutes of sandbox time, and go-judge runs one program at a time.
Admission bounds the queue itself. Both keep their counters in process memory, which is why the
deployment must stay at one replica until they move to shared storage.

`client_ip.rs` resolves the anonymous key. Cloudflare names the real client in `CF-Connecting-IP`; the
origin trusts that header only on a request that actually came through the edge, so a direct request
cannot pick its own budget. It is good enough for budgets and never used for authorisation.

## Everything else

| Module | Job |
| --- | --- |
| `health.rs`, `readiness.rs`, `http.rs` | `/api/health` (process up) and `/api/ready` (Postgres reachable) — the one `dyn` port |
| `admin_gate.rs` | the shared "is this caller in `ADMIN_USERS`?" check |
| `seo_routes.rs` | `/robots.txt` and `/sitemap.xml`, generated from the in-memory catalog |
| `blocking.rs` | the one `run_blocking`, so filesystem walks never stall the async runtime |
| `frontmatter.rs` | the lenient frontmatter splitter shared by catalog, blog and authoring |
