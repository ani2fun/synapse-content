---
title: "Making it scale, and keeping it maintainable"
summary: "What the platform can actually serve today, measured under load — then the arithmetic from requests to readers, where it genuinely breaks first, and the trigger-gated path to millions."
essential: true
---

# Making it scale, and keeping it maintainable

> **You'll be able to:** turn a throughput measurement into a defensible user-capacity number;
> tell which component a load test actually saturated; and stage a scaling plan by trigger rather
> than by ambition.

## What it can serve today, measured

Assertions about headroom are cheap, so here is the platform under real load. Measured
**2026-07-18** against the production deployment, one replica, driven from another node inside the
cluster so the CDN and the home uplink are out of the picture — this is the origin's own ceiling.

| Endpoint | Response size | Peak req/s | p50 | p99 | App CPU |
|---|---|---|---|---|---|
| `/api/health` | ~50 B | **15,440** | 12 ms | 46 ms | 0.74 cores |
| `/api/synapse/index` | ~33 KB | **1,690** | 102 ms | 583 ms | 0.67 cores |
| a lesson read | ~9 KB | 1,453 | 29 ms | 78 ms | — |

Memory under sustained load: **~36 MiB**, against a 256 MiB limit. The application never came close
to its memory cap, and never used one of the node's eight cores.

### The saturation curve

Throughput is only meaningful next to the latency it costs. Driving `/api/synapse/index` harder:

| Connections | req/s | p50 | p99 |
|---|---|---|---|
| 50 | 1,317 | 34 ms | 98 ms |
| 100 | 1,540 | 60 ms | 118 ms |
| 200 | **1,690** | 102 ms | 583 ms |
| 400 | 1,433 | 243 ms | 983 ms + timeouts |

The knee is around 200 connections. Past it, throughput *falls* while latency climbs — the classic
signature of a saturated system spending its time on queueing rather than work. **1,690 req/s is the
number; anything beyond it is worse in both dimensions.**

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **My first two runs measured the wrong thing, and both looked authoritative.**

The first used 50 connections against a 34 ms endpoint. 50 ÷ 0.034 ≈ 1,470 req/s — so the "result"
of 1,317 was arithmetic about *my load generator*, not a property of the server. A closed-loop load
test with too few connections measures its own concurrency limit.

The second was subtler. At 1,690 req/s with 33 KB responses the server was pushing **~56 MB/s**,
which is roughly what the WireGuard mesh between two home machines will carry. So the content
ceiling was **bandwidth**, not the application. The tell was that CPU sat at 0.67 of 8 cores while
throughput refused to rise.

The `/api/health` row is the control that settles it: same server, tiny response,
**15,440 req/s on 0.74 cores.** The application is roughly *ten times* faster than the pipe it is
speaking through.

</div>

## From requests per second to readers

A req/s figure is not a capacity answer until it is joined to a model of what a reader does. Mine,
stated so you can substitute your own:

- An actively reading person issues about **1 content request every 30 seconds** — navigating to a
  lesson, opening a section. Assets are immutable-cached, so they are free after first load.
- A reader has about **4 sessions a month**, roughly **20 content requests** each.
- Traffic is not uniform, so peak ≈ **10× average**.

### Concurrent readers

At 1,690 req/s, with **every single request missing the cache**:

```
1,690 req/s ÷ (1 request / 30 s per reader) ≈ 50,000 concurrent active readers
```

### Monthly readers

```
1,000,000 monthly readers × 4 sessions × 20 requests = 80,000,000 requests/month
80,000,000 ÷ 2,592,000 seconds                       ≈ 31 req/s average
× 10 peak factor                                     ≈ 310 req/s peak
```

So **one million monthly readers is about 310 req/s at peak** — against a measured origin ceiling of
1,690 req/s **with the cache switched off entirely**. That is roughly **5.5 million monthly readers
on a single replica with no CDN at all.**

Turn the cache back on and the read path stops being a question. At the ~99% cache-eligibility this
content has, the origin sees about 3 req/s per million monthly readers, and the arithmetic runs off
into numbers not worth printing.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **The interesting output of this arithmetic is not the big number — it is that the read path was
never the thing to worry about.** Time spent making it faster would have bought nothing. The
constraints that actually bind are availability, the judge, and the pipe out of the house.

</div>

### Where the cache hit rate starts to matter

The origin's egress rides a domestic uplink, so a falling hit rate is felt as bandwidth long before
it is felt as CPU. At one million monthly readers and 33 KB responses:

| Cache hit rate | Origin egress at peak |
|---|---|
| 99% | ~0.8 Mbps |
| 90% | ~8 Mbps |
| 50% | ~41 Mbps |
| 0% | ~82 Mbps |

Which is why "cache hit rate falling" is a trigger below, and why it is a more urgent signal than
CPU on this deployment specifically.

## The judge is the real ceiling

Reads scale by not being answered. **Runs cannot be cached** — they execute untrusted code — so this
is where CPU genuinely goes.

Measured through the production sandbox, a small Python program reports:

```json
{"status":"Accepted","stdout":"4950\n","timeSeconds":0.012044,"memoryKb":3584}
```

**12 ms of CPU and 3.5 MB** per trivial run. The adapter caps in-flight runs at a semaphore of **8**,
deliberately, so the sandbox cannot be swamped:

| Mean run duration | Sustained runs/s (8 in flight) |
|---|---|
| 12 ms (trivial) | ~660 |
| 200 ms (realistic mix) | ~40 |
| 1 s (heavy or timing out) | 8 |

At a realistic 200 ms mean, ~40 runs/s. If runs are ~1% of traffic, that supports roughly 4,000 req/s
overall — **about 13 million monthly readers** on the same model as above.

The semaphore is a *chosen* limit, not a hardware one: the sandbox node has 18 cores, so raising it
is a config change once there is evidence to justify it. The right time to raise it is when queueing
delay appears, not before — the cap exists so that a burst degrades into waiting rather than into
thrashing.

## What breaks first, in order

Given the above, an honest ranking of what actually limits this platform today:

| # | Constraint | Evidence |
|---|---|---|
| 1 | **Availability** — one database, one node | 92 minutes of downtime, measured, today |
| 2 | **Single replica** — required by per-process rate-limiter state | a restart is a total outage |
| 3 | **Judge concurrency** — semaphore of 8 | ~40 runs/s at a realistic mix |
| 4 | **Home uplink** — if the cache hit rate falls | 41 Mbps at 50% miss, 1M readers |
| 5 | **Origin CPU** | 0.74 of 8 cores at 15,000 req/s |

Origin CPU — the thing most capacity planning starts with — is *last*, by a wide margin. Everything
above it is a structural or operational limit, not a throughput one.

## The staged plan, gated by triggers

Each stage names the **observation** that justifies the work. Until the trigger fires, the work is
speculative — and given the numbers above, most of it is a long way off.

### Today → tens of thousands of monthly readers

*No capacity work.* The measured headroom covers this by two orders of magnitude. The work that is
justified is **availability**, which the numbers say is the binding constraint:

| Change | Why |
|---|---|
| Anti-affinity: database, sandbox and app on different nodes | one reboot currently takes out two of the three |
| Monitoring and alerting | today's outage was detected by me noticing |
| A bounded startup retry before fail-fast | absorbs a seconds-long database blip without a restart loop |

### Thousands to tens of thousands — *trigger: cache hit rate falling, or origin CPU sustained above 50%*

| Change | Why |
|---|---|
| Move rate-limiter state out of process | the one thing blocking multiple replicas |
| Add a second replica | removes the single-process outage window |
| Make the submission reconciler periodic, not boot-time | with N replicas, a crash is no longer a restart |
| Database replica with a manual failover | the top-ranked constraint, once downtime costs more than embarrassment |

The ordering matters. Replicas are **not** first: two replicas would silently double the effective
rate limit and leave abandoned submissions unswept until some instance happened to boot. The
prerequisites *are* the work; the replica count is a one-line change afterwards.

### Hundreds of thousands — *trigger: judge queueing delay appears, or write latency rises*

| Change | Why |
|---|---|
| Raise the judge semaphore, then add sandbox nodes | the measured ceiling, and the first genuine one |
| Extract execution into its own service | CPU-bound, hostile input, resource profile unlike the rest |
| Read replica for the database | submission reads start to matter |
| Move the origin off a domestic uplink | bandwidth, not compute, is what a home connection runs out of |

Extracting execution is cheap by construction: its port is already a trait, its adapter already
speaks HTTP to a separate process, and it already runs on its own node. It is a wiring change, not a
rewrite — which is the whole return on having drawn that boundary early.

### Millions and beyond — *trigger: a single database no longer absorbs the write rate*

| Change | Why |
|---|---|
| Partition `submissions` by time | the only unbounded table; recency is the only access pattern |
| Object storage for source blobs | rows get large; blobs do not belong in a relational store |
| Multi-region origins | physics — 200 ms from another continent is not fixable by faster code |
| Queue-backed judging | fan-out beyond what request-scoped tasks handle |
| Shard by user | **only** if partitioning demonstrably stops being enough |

Sharding is last and hedged on purpose. At a million monthly readers, submissions arrive at well
under one per second; time-partitioning solves the growth problem long before key-sharding is
needed, and sharding buys a distributed-systems problem that is very hard to give back.

## What stays the same at every stage

The read path. It is edge-cached, derived from a content commit, and reconstructable from a git
repository — so it scales by *not being answered*. Ten times the readers is ten times the cache
hits and roughly the same origin load.

That is the highest-leverage property in the system, and it came from one decision made at the
start: content is derived data, not database rows. Every capacity number in this chapter is
comfortable because of it.

## Maintainability is automated or it does not exist

A one-person codebase decays quietly, because there is no reviewer to notice. Four gates run in CI,
each catching a specific kind of drift:

| Gate | Catches |
|---|---|
| Domain/logic purity greps | a framework import creeping into pure code |
| File-size caps (500 server / 800 client) | a file quietly becoming two responsibilities |
| Bundle budget (700 KiB critical path) | dependency weight arriving one library at a time |
| Formatting + linting, warnings as errors | style drift and known-bad patterns |

They share the property worth copying: **each fails the build on a measurable threshold**, not on
judgement. "Keep files focused" is advice nobody can enforce. "This file is 512 lines and the limit
is 500" is a build failure with an obvious next action.

The file-size cap has earned its keep — a client file reached 889 lines and the cap forced the split
into `logic`, `state` and `view` it should have had from the start. The gate did not just detect a
problem; it named the fix.

### A gate that does not work

Honesty requires naming one that fails. A test diffs the generated API description against a
committed snapshot, so contract drift should be a red test. In practice **that snapshot documents
one endpoint out of roughly twenty**, so it has never caught anything.

That is worse than no gate, because it appears in the list above and produces confidence without
coverage. A gate that cannot fail is decoration. It should be regenerated in full or deleted —
leaving it as ornament is the one option that should be off the table.

## The documentation that stays true

Two mechanisms keep the docs from rotting, and both work by removing the option to drift.

**The architecture model lives in the content repository** and is compiled by the same push that
publishes this prose. The chapter and its diagrams cannot disagree, because they are the same commit.

**The build book is immutable.** Each chapter documents one step and is not retrofitted; later
changes are documented forward. That sounds like a recipe for stale docs and is the opposite: a
chapter that claims to describe a moment in time is *accurate* about that moment, whereas a
continuously-edited document claims to be current and quietly stops being so.

The failure mode this avoids is the one every project has: a `README` that was true two years ago,
with no way to tell which sentences still hold.

<details>
<summary>Most of this plan is deferred. How do you tell a deliberate deferral from an excuse?</summary>

By whether three things are true, all checkable by someone else.

**The trigger is named and observable.** "Raise the judge semaphore when queueing delay appears" is
a deferral you can act on, because someone can watch for queueing delay. "We'll split it when we
need to" is an excuse, because nothing will ever unambiguously say *now*.

**The cost of deferring is known.** The single database is deferred and the price is stated: today
that price was ninety-two minutes of downtime, measured. A deferral with an unquantified cost is a
guess wearing a plan's clothes.

**The design does not foreclose the change.** Execution can be extracted because it depends on a
port whose adapter already crosses a process boundary. Replicas are blocked by exactly one known
thing — per-process rate-limiter state — and that thing is written down in the chapter that owns it.
Cheap-to-change-later is what makes deferring rational rather than lucky.

Where this plan was weakest by its own test was **capacity itself**. Until these measurements
existed, "there is plenty of headroom" was an assertion with no number behind it — precisely the
kind of claim this book is supposed to refuse. Running the load test turned it into 1,690 req/s,
15,440 req/s, and a ranked list of what breaks first. It also overturned the assumption I would
have written down: the content ceiling is the network between two machines in my house, not the
application, and I would have blamed the application.

That is the argument for measuring things you are confident about. The plan did not change much —
but the *reasons* did, and reasons are what a future reader has to act on.

</details>
