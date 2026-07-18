---
title: "Making it scale, and keeping it maintainable"
summary: "What changes at each order of magnitude, which trigger justifies each change, and the small set of automated gates that keep a one-person codebase from decaying."
essential: true
---

# Making it scale, and keeping it maintainable

> **You'll be able to:** stage a scaling plan by trigger rather than by timeline; identify which
> constraint actually binds at each order of magnitude; and choose automated gates that catch the
> decay a code review will not.

## Scale by trigger, not by timeline

The temptation with a scaling plan is to build for the largest number you can imagine. That spends
today's effort on tomorrow's hypothetical, and usually buys the wrong thing — because the constraint
that eventually binds is rarely the one you guessed.

So each stage below names a **trigger**: the observation that justifies the work. Until the trigger
fires, the work is speculative.

### Today — hundreds of readers

Nothing to do. Measured utilisation is single-digit percent CPU and roughly a third of memory on the
busiest node, and ~99% of requests are edge-cacheable. The origin's job is mostly *not answering*.

The binding constraint at this scale is **availability, not capacity** — one node holds the database,
and losing it is a total outage.

### Thousands — *trigger: origin CPU sustained above ~50%, or cache hit rate falling*

| Change | Why |
|---|---|
| Move the rate limiter's state out of process | unlocks multiple replicas — the current blocker |
| Add a second application replica | removes the single-process outage window |
| Make the submission reconciler periodic, not boot-time | with N replicas, a crash is no longer a restart |
| Anti-affinity for database and sandbox | stop one node reboot taking out both |

Notice the ordering. Adding replicas is not first, because two replicas would silently double the
rate limit and leave abandoned submissions unswept. **The prerequisites are the work**; the replica
count is a one-line change afterwards.

### Tens of thousands — *trigger: judging queue depth growing, or write latency rising*

| Change | Why |
|---|---|
| Extract the execution context into its own service | CPU-bound, hostile input, resource profile unlike everything else |
| Horizontal sandbox pool with a queue | judging becomes the first genuine bottleneck |
| Read replica for the database | reads on submissions start to matter |
| Real monitoring and alerting | "I noticed" stops being an acceptable detection mechanism |

The execution extraction is designed for and cheap: its port is a trait, its adapter already speaks
HTTP to a separate process, and it already runs on its own node. It is a wiring change.

### Millions — *trigger: a single database no longer absorbs the write rate*

| Change | Why |
|---|---|
| Partition submissions by time | the only unbounded table; recency is the only access pattern |
| Multi-region origins | physics — 200 ms from one continent is not fixable by faster code |
| Object storage for source blobs | rows get large; blobs do not belong in a relational store |
| Async pipeline for judging | fan-out beyond what request-scoped tasks handle |

Even here, sharding is not on the list. Submissions arrive at well under one per second at a million
monthly readers, and time-partitioning solves the growth problem long before key-sharding is needed.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **Run the arithmetic before designing for scale.** A million monthly readers submitting a few
solutions each is a handful of writes per minute. Most "we need to shard" conversations end when
someone divides the expected volume by the number of seconds in a month.

</div>

## What stays the same at every stage

The read path. It is edge-cached, derived from a content commit, and reconstructable from a git
repository — so it scales by *not being answered*. Ten times the readers means ten times the cache
hits, and roughly the same origin load.

That is the highest-leverage property in the system, and it came from one architectural decision made
at the start: content is derived data, not database rows.

## Maintainability is automated or it does not exist

A one-person codebase decays quietly, because there is no reviewer to notice. Four gates run in CI,
and each catches a specific kind of drift:

| Gate | Catches |
|---|---|
| Domain/logic purity greps | a framework import creeping into pure code |
| File-size caps (500 server / 800 client) | a file quietly becoming two responsibilities |
| Bundle budget (700 KiB critical path) | dependency weight arriving one library at a time |
| Formatting + linting, warnings as errors | style drift and known-bad patterns |

They share a property worth copying: **each fails the build on a measurable threshold**, not on
judgement. "Keep files focused" is advice nobody can enforce. "This file is 512 lines and the limit is
500" is a build failure with an obvious next action.

The file-size cap has earned its place — a client file reached 889 lines and the cap forced the split
into `logic`, `state` and `view` that it should have had from the start. The gate did not just detect
a problem; it named the fix.

### A gate that does not work

Honesty requires naming one that fails. A test diffs the generated API description against a
committed snapshot, so contract drift should be a red test. In practice **the snapshot documents one
endpoint out of roughly twenty**, so it has never caught anything.

That is worse than having no gate, because it appears in the list above and produces confidence
without coverage. A gate that cannot fail is decoration. It should be regenerated in full or deleted
— and writing this chapter is what made that impossible to keep ignoring.

## The documentation that stays true

Two mechanisms keep the docs from rotting, and both work by removing the option to drift.

**The architecture model lives in the content repository** and is compiled by the same push that
publishes this prose. The chapter and its diagrams cannot disagree, because they are the same commit.

**The build book is immutable.** Each chapter documents one step and is not retrofitted; later
changes are documented forward. That sounds like a recipe for stale docs, and it is the opposite: a
chapter that claims to describe a moment in time is *accurate* about that moment, whereas a
continuously-edited document claims to be current and quietly stops being so.

The failure mode this avoids is the one every project has: a `README` that was true two years ago,
with no way to tell which sentences still hold.

## Check yourself

```quiz
{"prompt": "Why is 'add a second replica' not the first item in the thousands-of-readers stage?", "options": ["Because two replicas cost too much memory", "Because the rate limiter's per-process state must move first, and the submission reconciler must become periodic — otherwise replicas silently double the rate limit and leave abandoned submissions unswept", "Because the database cannot handle two connections pools", "Because the content sidecar cannot be shared between pods"], "answer": "Because the rate limiter's per-process state must move first, and the submission reconciler must become periodic — otherwise replicas silently double the rate limit and leave abandoned submissions unswept"}
```

```quiz
{"prompt": "What makes the four CI gates effective where written conventions are not?", "options": ["They run faster than a human reviewer", "Each fails the build on a measurable threshold rather than on judgement, so drift produces a build failure with an obvious next action", "They are enforced by a linter with AI assistance", "They only run on the main branch"], "answer": "Each fails the build on a measurable threshold rather than on judgement, so drift produces a build failure with an obvious next action"}
```

```quiz
{"prompt": "Why is a contract-snapshot test that covers 1 of ~20 endpoints described as worse than no gate at all?", "options": ["Because it slows down CI", "Because it appears in the list of protections and produces confidence without coverage — a gate that cannot fail is decoration", "Because partial snapshots corrupt the generated API description", "Because it prevents adding new endpoints"], "answer": "Because it appears in the list of protections and produces confidence without coverage — a gate that cannot fail is decoration"}
```

<details>
<summary>Most of this plan is deferred. How do you tell a deliberate deferral from an excuse?</summary>

By whether three things are true, all of which are checkable by someone else.

**The trigger is named and observable.** "Extract execution when judging queue depth grows" is a
deferral you can act on, because someone can look at queue depth. "We'll split it when we need to" is
an excuse, because nothing will ever unambiguously say *now*.

**The cost of deferring is known.** The single database is deferred, and the price is stated: today
that price was ninety minutes of downtime, measured. A deferral with an unquantified cost is a guess
wearing a plan's clothes.

**The design does not foreclose the change.** Execution can be extracted because it depends on a port
whose adapter already speaks HTTP across a process boundary. Replicas are blocked by exactly one
known thing — per-process rate-limiter state — and that thing is written down in the chapter that
owns it. Cheap-to-change-later is what makes deferring rational rather than lucky.

Where this plan is weakest by its own test is monitoring. It sits in the tens-of-thousands stage, but
the trigger has arguably already fired: today's outage was detected by someone noticing the site was
down. The cost of deferring is real and recurring, and the mitigation is not expensive. That is a
deferral that has quietly turned into an excuse, and writing the chapter is what exposed it.

Which is the honest argument for documenting a system this way: the plan is where you find out which
of your decisions have stopped being decisions.

</details>
