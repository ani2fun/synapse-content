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

The latency and origin figures were measured against the live deployment on **2026-07-18** from a
single client in **Western Europe**, twelve samples per figure, reporting median with min and max.

That last part is the important caveat: **one vantage point is not a global latency profile.** A
reader in Sydney will see different numbers, dominated by physics I cannot measure from here. Where
this chapter says "48 ms", it means "48 ms from one place, on one day" — not a service-level
objective.

The page-weight figures come from a different instrument on a later date: the CI budget gate, run
against a production-shaped serve. Where a number's provenance differs from the rest of the chapter,
this text says so next to the number rather than in a footnote — because a table that mixes two
measurement methods without labelling them is how a plausible chapter becomes a wrong one.

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

## What the browser downloads

This is the figure that changed most, and the way it changed is more interesting than the number.

The measurement above was taken while the reader was a WebAssembly application: a **~630 KiB critical
path**, 96% of it one wasm module, against a 700 KiB budget. Every page paid all of it, and paid it
*before* rendering any prose — measured at 1.25 s to readable content on broadband and **7.2 s on a
mid-range phone over Fast-3G**.

Server rendering does not make that bundle smaller. It removes the question, because there is no
longer one bundle: each page ships only its own assets, and the prose is in the HTML.

Measured against the live deployment before and after — median of three runs, the mobile figures
throttled to Fast-3G with a 4× CPU penalty:

| Measure | Before (WASM client) | After (server-rendered) |
|---|---|---|
| First content — broadband | 1.25 s | **0.52 s** (2.4×) |
| First content — phone, slow 3G | 7.2 s | **1.86 s** (3.9×) |
| Blocking JS before prose | 641 KiB gz | **~47 KiB gz** |
| Prose arrives as | a compiler's output, after boot | HTML in the first response |
| With JavaScript disabled | a blank page | the lesson, readable |

The delivered 2.4× and 3.9× land slightly *under* the 3×/5× the change was modelled to produce, and
that is worth stating rather than rounding up: the model was an upper bound, as models of this kind
usually are. The structural line is the one that matters most anyway — time to content stopped being
a function of how fast a bundle boots, so it is no longer a number that can quietly regress by a
dependency getting heavier.

| Page kind | Eager, gzipped |
|---|---|
| Landing | 42 KiB |
| Prose lesson | 47 KiB |
| Problem page | 48 KiB |
| Blog index | 11 KiB |
| **Budget, per page kind** | **250 KiB** |
| Visualisation bundle (lazy, capped) | 288 KiB / 350 KiB |

Two things about that table are worth more than the numbers.

**The measurement method had to change with the architecture.** "Sum the entry chunk" is meaningless
now. The gate fetches each page kind from a production-shaped serve, collects every script and
stylesheet its HTML references, and gzip-sums them — so it measures *what a reader waits for*, which
is what the old number was a proxy for.

**The lazy half is absent by construction.** Monaco, keycloak-js, mermaid, d2, the tracers and the
visualiser are dynamic imports, so they cannot appear in a page's HTML and cannot land in the sum. No
exclusion list has to be maintained, and no future dependency can sneak into the critical path by
being forgotten in a glob.

The budget is a **CI gate**, and its headroom is deliberate — about five times the heaviest page. It
is not sized to be tight; it is sized so that approaching it means something structural regressed, in
which case the fix is to find the island that went eager rather than to raise the number.

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **The 42/47/48/11 figures are measured against fixture content**, because that is what the gate
runs against in CI — small, stable pages with a known shape. Real lessons carry more HTML, and a
lesson with many diagrams carries more still. They are honest as a measure of *what the page loads
eagerly*, which is what the budget is about; they are not a claim about the total weight of a page of
this book.

</div>

## The origin is nearly idle

| Metric | Value |
|---|---|
| Memory limit | 256 Mi |
| Actual usage at idle | **~6 Mi RSS** |
| Actual usage under sustained load | ~36 Mi |
| Replicas | 1 |
| In-cluster response time | ~14 ms |
| Sustained throughput, one replica | **15,440 req/s** on 0.74 of 8 cores |

That last row is measured, not estimated — the load test and the capacity arithmetic it supports are
in [Scaling and maintainability](/synapse/synapse-app-from-scratch/running-it/scaling-and-maintainability).
The short version: the application is about ten times faster than the network it speaks through, so
the origin's throughput has never been the thing worth optimising.

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

- **The database.** Six small tables, one index per query that needs one, and no query that is not
  either a primary-key lookup or a two-column index scan. Tuning it would be optimising a component
  that is not in any critical path.
- **The judge.** It runs someone else's code; its duration is set by that code. The design goal was
  never to make judging fast — it was to stop judging from blocking anything else, which is what the
  202-and-poll shape achieves.
- **Compile times.** Genuinely annoying, entirely a development cost, invisible to readers.

Each of those is a place where effort would produce a number that improves and an experience that
does not.

<details>
<summary>The origin idles at 6 Mi and answers in ~14 ms. So why does the site ever feel slow?</summary>

Because origin speed is a small part of what a reader experiences, and the parts that dominate are
mostly not the server.

Decompose the 208 ms of an origin-served request from here: a few milliseconds of application work,
and ~190 ms of network — TLS, the trip to the edge, the edge to a home connection, and back. The
application is roughly **7%** of its own slowest path. Making it twice as fast would move 208 ms to
about 201 ms.

Then there is everything after the response arrives. This used to be the dominant term by a distance:
parsing and instantiating 600 KiB of WebAssembly, then mounting an application, before a single word
appeared. Server rendering deleted that term — the prose is in the response — and what remains is
per-page hydration of whatever islands the page actually has, plus, on a heavy page, fetching a
diagram engine and laying out diagrams.

So the levers that actually matter here are, in order: **serve from the edge** (208 ms → 48 ms, the
single biggest win and already done), **do not make the reader wait for the application** (the
largest client-side win, and the one that ended the previous architecture), **ship less eagerly**
(why the budget is a gate and why the editor is lazy), and **do not let one slow thing gate
everything else** (the prose-first diagram fix). Optimising the server appears nowhere on that list,
which is exactly why it is not being optimised.

The general habit: measure the *whole* path a user waits on before optimising the part you find most
interesting. Server code is usually the most interesting part and rarely the dominant one.

</details>
