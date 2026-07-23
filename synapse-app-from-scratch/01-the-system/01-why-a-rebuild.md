---
title: "Why a rebuild"
summary: "Two rewrites, six days apart: Scala to Rust on the server, and a Rust client that was deleted almost as soon as it shipped. What each measurably bought, and what one of them proved wrong."
essential: true
---

# Why a rebuild

> **You'll be able to:** judge a rewrite by what it measurably bought rather than by how it felt;
> explain what a "reference oracle" rebuild is and why it beats working from a specification;
> recognise the specific conditions that made this one survivable; and tell the difference between a
> decision that was justified and one that merely followed another.

## Same product, different implementation

This platform ran on Scala 3 — ZIO on the server, Laminar in the browser. It was rebuilt in Rust:
axum on the server, Leptos compiled to WebAssembly in the browser. Same product, same content, same
URLs; a different implementation underneath.

| | Scala | Rust |
|---|---|---|
| Server | ZIO + tapir + zio-http | tokio + axum + utoipa |
| Client | Scala.js + Laminar | WebAssembly + Leptos |
| Effects | `IO[DomainError, A]` | `async fn → Result<A, DomainError>` |
| Ports | traits + `ZLayer` wiring | traits + constructor injection in `main` |
| Database | JDBC + Liquibase | sqlx + embedded migrations |
| Shared code | `crossProject(JS, JVM)` | one crate, native + `wasm32` |
| Build | `sbt` + `npm` | `cargo` + `npm` |

The architecture barely moved. Ports and adapters, bounded contexts, the three-layer client split,
even most module names survived — because those were *design* decisions, and the rebuild was not a
redesign. What changed is the machinery underneath them.

Then, six days after the Rust client first rendered a page, it was deleted and replaced with
server-rendered Astro. That second rewrite is the more useful story, and it is told at the end of
this chapter rather than the start, because it only makes sense once you have the first one's
reasoning in view.

## The method: a reference oracle

The word **oracle** appears throughout this codebase and it does not mean the database company. It
is borrowed from testing, where an *oracle* is the authority that tells you whether an output is
correct. The Scala implementation played that role: its behaviour was the specification, its test
suites were the acceptance criteria, and its live deployment was the parity target.

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **A naming collision worth knowing about.** The file `api/openapi.oracle.yaml` in the repository
is a frozen copy of the *Scala implementation's* API contract, kept so the Rust build can diff
against it. It has nothing to do with Oracle Cloud — which this project also uses, for unrelated
virtual machines. The [glossary](/synapse/synapse-app-from-scratch/appendices/glossary) opens with
this term for exactly that reason.

</div>

Working against an oracle changes the character of a rewrite. There is no requirements-gathering
phase and no ambiguity about correctness: the answer already exists and runs. That turns a design
problem into a *re-derivation* problem — and re-derivation is where the learning is, because you
must understand why each decision was made before you can restate it in a different language.

The rule adopted here was: **cherry-pick from the oracle, never copy a decision you do not
understand.** Where the Scala choice was sound it was ported deliberately. Where it was a shortcut,
the rebuild fixed it — and the chapters say which was which.

## What it bought, measured

Only one motive was measurable, so it is the one the book can hold to account: **footprint.** The
homelab is four small machines, and a JVM's memory floor is a real cost on a node that also runs a
database and a code sandbox.

The Scala deployment requested **256 MiB** of memory and was capped at **1 GiB** — sized for a JVM
heap. The Rust process that replaced it, doing the same work on the same node, idles at:

```
NAME                       CPU(cores)   MEMORY(bytes)
synapse-78948bcbf4-7brqm   1m           6Mi
```

Six mebibytes against a 256 MiB floor — roughly a **40× reduction** in resident memory, on a
cluster where memory is the scarce resource. That is not a micro-optimisation; it is the difference
between the database node having headroom and not.

Two secondary effects fell out of it. Startup went from a JVM-plus-migration budget of 150 seconds
to a probe budget of 60 — and most of that 60 is tolerance for a slow database, not for the
process. And the container image carries no runtime: a single static-ish binary plus the compiled
web assets, rather than a JVM.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **The comparison is honest but narrow.** It measures *idle* memory for a personal-scale
workload. A JVM's memory floor buys things this system does not need at four users — a mature GC,
a JIT that improves under sustained load, and an enormous library ecosystem. At a hundred thousand
users the comparison would need re-running, and might come out differently.

</div>

## What Scala was better at

A comparison that only runs one way is advocacy, not analysis. Scala won on several axes that
matter day to day:

- **Compile times.** `sbt` with a warm incremental compiler beat `cargo` on a full rebuild, and the
  gap is felt on every change.
- **Ecosystem depth.** For web and data work the JVM's libraries are broader and more mature. A few
  things that would have been a dependency are hand-written here.
- **The effect system.** ZIO's typed errors and structured concurrency are a genuinely elegant model.
  `async` Rust reaches similar places with more ceremony and sharper edges.
- **One language, both ends — already.** Scala.js gave shared types across client and server before
  the rebuild. That was not a Rust *gain*; it was a property preserved.
- **The client's UI half.** Laminar's `Var`/`Signal` model is the same fine-grained reactivity Leptos
  offers, and the bundles are the same size — measured, 624 KiB against 636 KiB gzipped. Scala.js
  also emits JavaScript that touches the DOM directly, where WebAssembly must cross into JS glue and
  marshal every string it passes.

The client is worth stating carefully, because it is the part most likely to be assumed the wrong way
in either direction. Rust does win one half of it: the visualisation engine is thousands of lines of
pure logic running in the browser, including a 320-tick O(n²) force simulation over flat float arrays
— the workload WebAssembly is genuinely better at, and one a reader app is not expected to have.
Scala wins the other half, the DOM-facing UI work.

What is *not* true is that Rust brought shared types to the client: Scala.js already had them. So
**the client rewrite was not independently justified — it followed the server.** Once the server
became Rust, a Scala.js client could no longer share a type with it, and that decided it. Had the
server stayed on the JVM, the case would have rested on the viz engine's compute alone: a real
argument, but not one that justifies rewriting a client that worked.

Hold on to that sentence. It gets tested below.

What Rust won was the memory floor, no GC pauses, and a compiler that makes several bug classes
unrepresentable — exhaustive matching, `#[must_use]` transitions, ownership that makes teardown
deterministic. Those are examined where they appear in later chapters rather than asserted here.
Note that all four are *server-side* arguments, which is consistent with where the measurable win
was.

## What it cost

A rewrite costs the things every rewrite costs, and this one is not exempt:

- **Bugs the original had already found.** The clearest example: sign-in worked in every test and
  failed in production because the HTTP client had no TLS backend compiled in. In development every
  outbound call is plain HTTP, so the only HTTPS caller in the whole system is the production
  identity fetch — a gap that existed precisely where no test looked. The Scala implementation had
  no such class of bug because the JVM ships trust roots by default.
- **A second corpus of documentation** that immediately began to drift from the first.
- **Dual-stack knowledge** for as long as both existed, mitigated only by archiving the old one.

## When this is a bad idea

The conditions that made this survivable are specific, and worth stating plainly because they are
usually absent:

- **The product was frozen.** No feature work competed with the rebuild.
- **There was exactly one user.** A production incident cost embarrassment, not revenue.
- **The oracle was complete and running**, so parity was checkable at every step rather than
  guessed at the end.
- **Content and code were already separate**, so no data migration was needed for the part that
  matters most — the writing.

Remove any one of those and the calculus changes. With paying users and a live roadmap, the honest
advice is the boring one: profile the JVM, tune the heap, and spend the time on something a user
would notice.

## The second rewrite, and the prediction it settled

The section above says the client rewrite was not independently justified. Six days after the Rust
client first rendered a page, it was deleted.

What settled it was one measurement. The Leptos client was **641 KiB gzipped** that had to arrive,
instantiate and mount before any prose appeared. Measured against production, content became
readable at **1.25 s** on broadband and **7.2 s on a mid-range phone over Fast-3G** — for lessons
whose content is around two kilobytes gzipped.

Nothing about that number is a language problem. A Scala.js client of the same design would have
been in the same place — the bullet above measures the two implementations' critical paths within 2%
of each other, which is exactly the point. **The dominant term was the application, not the language
it compiled to** — and this platform's traffic is 99% reads of public prose, which does not need an
application at all.

(The two figures are measurements of different things on different days: 624 against 636 KiB is the
critical path — script, stylesheet and wasm — measured for the stack comparison; 641 KiB is the wasm
module alone, measured later, when the client had grown. Neither is wrong, and quoting one where the
other belongs would be.)

So the web tier became server-rendered Astro with per-feature TypeScript islands: prose is HTML in
the response, and interactivity hydrates only where a page has any. The full design is in
[the web tier chapter](/synapse/synapse-app-from-scratch/low-level-design/the-client); what belongs
here is what it says about the *first* rewrite.

Measured on production afterwards — median of three runs, mobile throttled to Fast-3G with a 4× CPU
penalty — first content fell from 1.25 s to **0.52 s** on broadband and from 7.2 s to **1.86 s** on
the phone. Both land under the 3×/5× the change was modelled to give, which is the usual fate of a
model, and both are large enough that the direction was never in doubt.

| | Server: Scala → Rust | Client: Scala.js → Leptos → Astro |
|---|---|---|
| Motive | a measured memory floor on a constrained cluster | followed the server; then a measured first paint |
| Result | 256 Mi → ~6 Mi, still true | rewritten, then rewritten again in six days |
| Verdict | the target was real and it was hit | the intermediate step bought nothing a reader could see |

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **A decision that "follows" another decision has no evidence of its own.** The client moved to
Rust because the server had, and that reasoning is coherent — a Rust server and a Scala.js client
cannot share a wire type. But coherent is not the same as justified. Nobody had measured what the
client's users were waiting for, so the rewrite optimised a property (shared types) that no reader
experiences, and left untouched the one (time to first word) that every reader does.

</div>

The salvage is worth stating too, because "it was all wasted" would be as sloppy as the original
claim. The visualisation engine stayed Rust and is now a lazy 288 KiB module loaded only by pages
that draw something — the one part of that client whose workload genuinely favoured WebAssembly, and
the part the earlier section correctly identified. The pure logic ported to vitest test-for-test.
The TypeScript islands were reused verbatim for the third time. What was thrown away was the
application shell, which is precisely the part the evidence never supported.

The general lesson is not "don't rewrite clients". It is that **a rewrite needs its own number**, and
inheriting a justification from an adjacent decision is how you end up with a defensible-sounding
project that no measurement was ever run against. The server rewrite had a number before it started.
The client rewrite got its number afterwards, and the number ended it.

<details>
<summary>The TLS bug passed every test and still broke production. What does that failure have in common with the argument for rebuilding against an oracle?</summary>

Both are about **where the truth lives**. An oracle rebuild works because correctness is defined by
something that actually runs, not by a document describing what should run.

The TLS bug is the same principle failing in the other direction. The tests defined correctness,
and they all passed — but they exercised a development environment where every outbound call is
plain HTTP. The single HTTPS call in the system existed only in production, so the test suite's
notion of "correct" was quietly narrower than reality.

The lesson is not "write more tests". It is that a test suite is itself a model, and models have
edges. The way this bug was eventually caught — and the way the whole rebuild was validated — was
by comparing against something real: the running system, in the place it actually runs.

</details>
