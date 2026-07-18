---
title: "Performance and efficiency, measured"
summary: "Real numbers from the live system with their methodology and their limits: what the cache is worth, what the origin costs, and why the honest headline is a range rather than a single figure."
essential: true
---

# Performance and efficiency, measured

> **You'll be able to:** report a latency figure so someone else can check it; recognise when your
> own measurement method is the thing producing the result; and decide what to optimise from
> evidence rather than instinct.

## How these numbers were taken

Every figure here was measured against the live deployment on **2026-07-18** from a single client in
**Western Europe**, twelve samples per figure, reporting median with min and max.

That last part is the important caveat: **one vantage point is not a global latency profile.** A
reader in Sydney will see different numbers, dominated by physics I cannot measure from here. Where
this chapter says "48 ms", it means "48 ms from one place, on one day" — not a service-level
objective.

## Latency

| Path | Median | Min | Max | What it includes |
|---|---|---|---|---|
| Edge cache hit | **48 ms** | 39 ms | 133 ms | CDN edge only; never reaches the origin |
| Origin, cache miss | **208 ms** | 109 ms | 403 ms | full round trip to the homelab and back |

So the edge cache is worth roughly **4×** on content reads, and — more importantly — it removes the
long tail. The cached path's worst sample was 133 ms; the origin path's worst was 403 ms, and that
variance is a home network with a domestic uplink behaving exactly as one should expect.

The `cf-cache-status` header distinguishes the two, and it is the reason the cache rule is verifiable
rather than assumed.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Two measurement mistakes I made while producing this table**, both of which produced
confident, wrong numbers:

1. **Probing with `HEAD` instead of `GET`.** The cache-control middleware applies to `GET`, so a
   `HEAD` probe showed the header missing. The header was there the whole time; my request was not
   the request I was reasoning about.
2. **Reading the cache status from a second request.** Timing the `GET` and then reading
   `cf-cache-status` from a follow-up request to the same URL reports a `HIT` — because the first
   request just populated the cache. The fix is to capture timing and headers from *one* request.

Both are the same failure: measuring something adjacent to what you meant to measure. If a number
looks decisive, check the instrument before believing it.

</div>

## Caching policy

| Asset class | Header | Reasoning |
|---|---|---|
| Hashed JS/CSS/WASM | `public, max-age=31536000, immutable` | content-addressed: a change is a new URL |
| Content JSON | `public, max-age=60, stale-while-revalidate=600` | authored content, tolerant of a minute |
| Media | long-lived | large and rarely edited |
| Authenticated endpoints | not cached | per-user |

The `stale-while-revalidate` window is the part that most changes how the site feels. Within it, a
reader whose cached copy has just expired gets the stale copy **instantly** while the refresh happens
behind them. Nobody waits for revalidation; the cost is that someone might see a version up to a
minute old.

## The bundle

Measured from production as delivered:

| Asset | Transfer size |
|---|---|
| Entry JS | 10,329 B |
| CSS | 16,100 B |
| WASM | 619,122 B |
| **Critical path** | **~630 KiB** (budget: 700 KiB) |

The WASM is 96% of it, and it is the whole application: routing, state, the catalog, the executor
machine, the visualisation engine. What is *not* in there is as important — the code editor and the
diagram engines are megabytes and load only when a page needs them.

The budget is a **CI gate**. A number like this only moves upward unless something refuses to let it,
and the honest reason for a hard limit is that no individual dependency ever looks like the problem.

## The origin is nearly idle

| Metric | Value |
|---|---|
| Memory limit | 256 Mi |
| Actual usage at idle | **~6 Mi RSS** |
| Replicas | 1 |
| In-cluster response time | ~14 ms |

The application is not the bottleneck and is not close to being one. At ~99% cache-hit-eligible
traffic, the origin only sees cache misses, revalidations and the small volume of runs and writes.

This is the payoff from the architecture chapter's traffic table: reads were designed to be
derived, cacheable data, so the origin's job at scale is mostly *not answering*.

## The one real performance bug, and how it was found

The most user-visible performance problem was not throughput. It was that a lesson with several
diagrams rendered **nothing** — blank page, then everything at once, seconds later.

The cause was ordering, not slowness: diagrams were rendered during markdown parsing, sequentially,
inside the promise the page waited on. So the slowest diagram's layout gated the first paint of the
entire page, including prose that had been ready immediately.

The fix was to change *when*, not *how fast*: parsing now emits a placeholder holding the diagram
source, and rendering happens at mount, near the viewport. Prose paints at once; diagrams fill in
independently and concurrently; below-the-fold diagrams do not render until approached; the heavy
engines load only if the page uses them.

The lesson generalises past this codebase. **The parse loop was never the slow part — the dependency
order was.** A profiler would have shown time inside diagram layout, which is true and useless; the
question that mattered was *why is prose waiting for this at all?* Optimising the layout engine would
have made a blank page appear slightly sooner.

## What is deliberately not optimised

- **The database.** Two tables, single-digit rows, one index for the one query that needs it. Tuning
  it would be optimising a component that is not in any critical path.
- **The judge.** It runs someone else's code; its duration is set by that code. The design goal was
  never to make judging fast — it was to stop judging from blocking anything else, which is what the
  202-and-poll shape achieves.
- **Compile times.** Genuinely annoying, entirely a development cost, invisible to readers.

Each of those is a place where effort would produce a number that improves and an experience that
does not.

## Check yourself

```quiz
{"prompt": "Why does this chapter insist on naming the vantage point and date for every latency figure?", "options": ["To comply with benchmarking standards", "Because a latency number without a measurement location is not reproducible or meaningful — one client in one region is not a global profile", "Because latency changes every day", "Because the CDN rotates edge nodes"], "answer": "Because a latency number without a measurement location is not reproducible or meaningful — one client in one region is not a global profile"}
```

```quiz
{"prompt": "Timing a GET and then reading `cf-cache-status` from a follow-up request to the same URL reports HIT. Why is that wrong?", "options": ["Because HEAD requests are not cached", "Because the first request populated the cache, so the second observes a state the first one created — timing and headers must come from the same request", "Because cf-cache-status is only set on HTTPS", "Because the CDN rate-limits repeated requests"], "answer": "Because the first request populated the cache, so the second observes a state the first one created — timing and headers must come from the same request"}
```

```quiz
{"prompt": "Diagrams rendered during markdown parsing made whole pages blank for seconds. Why would optimising the diagram layout engine have been the wrong fix?", "options": ["Because the layout engine is third-party code", "Because the problem was dependency ordering, not speed — prose was waiting on diagrams it did not depend on, so making layout faster would only make a blank page appear slightly sooner", "Because diagrams are cached anyway", "Because most pages have no diagrams"], "answer": "Because the problem was dependency ordering, not speed — prose was waiting on diagrams it did not depend on, so making layout faster would only make a blank page appear slightly sooner"}
```

<details>
<summary>The origin idles at 6 Mi and answers in ~14 ms. So why does the site ever feel slow?</summary>

Because origin speed is a small part of what a reader experiences, and the parts that dominate are
mostly not the server.

Decompose the 208 ms of an origin-served request from here: a few milliseconds of application work,
and ~190 ms of network — TLS, the trip to the edge, the edge to a home connection, and back. The
application is roughly **7%** of its own slowest path. Making it twice as fast would move 208 ms to
about 201 ms.

Then there is everything after the response arrives: parsing, instantiating 600 KiB of WebAssembly,
mounting the application, and — on a heavy page — fetching a diagram engine and laying out diagrams.
That client-side work can easily exceed the request that triggered it.

So the levers that actually matter here are, in order: **serve from the edge** (208 ms → 48 ms, the
single biggest win and already done), **ship less to the critical path** (why the budget is a gate
and why the editor is lazy), and **do not let one slow thing gate everything else** (the prose-first
fix). Optimising the server appears nowhere on that list, which is exactly why it is not being
optimised.

The general habit: measure the *whole* path a user waits on before optimising the part you find most
interesting. Server code is usually the most interesting part and rarely the dominant one.

</details>
