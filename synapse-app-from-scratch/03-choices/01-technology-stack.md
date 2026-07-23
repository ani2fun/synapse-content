---
title: "The technology stack"
summary: "What was chosen, what was rejected, and what each choice actually cost — including the one measured 40× win and the places the stack is genuinely worse than the alternative."
essential: true
---

# The technology stack

> **You'll be able to:** justify a stack choice with a measured number rather than a preference;
> name the real costs of the choices made here; and recognise when a rewrite is and is not a
> defensible use of time.

## The stack, and the honest reason for each

| Layer | Choice | Chosen because | Costs |
|---|---|---|---|
| Server | Rust + axum + tokio | tiny footprint, no GC pauses, exhaustive matching | slow compiles; a real learning curve |
| Database access | sqlx | compile-time-checked SQL, no ORM indirection | queries are hand-written; no lazy loading |
| Web tier | Astro SSR + TypeScript islands | the workload is documents, not an application: prose is HTML in the response | a second runtime in the image; no compile-time type sharing with the server |
| UI components | Preact, only where state is real | small, familiar, and confined to the four surfaces that need it | a second idiom next to vanilla TS islands |
| Visualisation | Rust → WASM, lazy | genuine compute; thousands of pure lines with goldens already passing | a third toolchain in the build |
| Config | figment | env-first, layered, typed | precedence needs care (see below) |
| Errors | thiserror per context | typed, exhaustive, no stringly errors | more code than `anyhow` everywhere |
| Sandbox | go-judge | purpose-built, resource-capped, isolated | an extra service to run |
| Identity | Keycloak | standards-compliant OIDC; not my problem to invent | heavyweight for one user |
| Content forge | GitHub REST, no `git` binary | stateless calls; a failure leaves nothing to clean up | one more credential to scope and rotate |
| Diagrams | LikeC4, mermaid, d2 | diagrams-as-code, versioned with the prose | three engines to load |

Two of those deserve real defence, because they are the ones a reviewer would push on.

## Rust, measured rather than asserted

This platform previously ran on the JVM. The rewrite is therefore not a claim — it is a
**before-and-after on the same workload, on the same hardware**:

| | JVM implementation | Rust implementation |
|---|---|---|
| Memory limit needed | 1 GiB | 256 Mi |
| Actual idle usage | ~256 Mi floor | **~6 Mi RSS** |
| Startup | seconds (JIT + migrations) | sub-second |
| Container image | JRE + app | one binary on debian-slim |

Roughly **40× less memory at idle**, on a homelab where memory is the binding constraint. That is not
a micro-benchmark; it is the number that decides how many things fit on a four-node cluster.

The honest counterweight: this only matters *because* of the constraint. On a cloud instance where
1 GiB costs pennies, a 40× memory win is a rounding error and the JVM's faster compiles and deeper
ecosystem might well win. The choice is right **for this deployment**, and the reasoning does not
transfer unexamined.

The genuine costs, stated plainly:

- **Compile times.** A full rebuild is minutes, not seconds. This is the single biggest day-to-day
  tax and no amount of enthusiasm makes it disappear.
- **The learning curve is real and front-loaded.** Ownership, lifetimes and async interact in ways
  that are genuinely hard at first.
- **Ecosystem depth.** For web work the libraries are good but thinner than the JVM's. Some things
  that would be a dependency elsewhere are written here.

## What the type system actually bought

The strongest argument for Rust in this codebase is not performance — it is that several classes of
bug are **unrepresentable**, and each is visible in earlier chapters:

- Exhaustive matching means adding a state or an error variant fails the build until every site
  handles it. There are no wildcard arms in the mappings that matter.
- `#[must_use]` on state transitions makes "advanced the state, forgot to save" a compiler warning.
- A biconditional check constraint restates the domain ADT in SQL, so the flattened row cannot hold a
  shape the type never could.
- `forbid(unsafe_code)` is workspace law, and `unwrap`/`expect`/`panic` are denied by the linter —
  so "it cannot fail here" has to be written as a `Result`, not asserted.

Each is a bug I would otherwise have written, found in production, and fixed with a comment saying
"remember to…". The value is that the compiler remembers instead.

Worth noting which of these survived the web tier's move to TypeScript, because it is a fair test of
how much was language and how much was design. The state machines ported intact; their *guarantees*
did not, uniformly. The run-handle token that Rust made unforgeable with a private field is a branded
type in TypeScript — it cannot be confused, but `42 as RunHandle` compiles. That degradation is
documented at the definition rather than discovered later, which is the most a weaker type system
lets you do.

## The type-sharing argument, and how it ended

The strongest case for a Rust client was that wire types could be defined **once** in a shared crate
compiling both natively and to WebAssembly. Rename a field, both ends fail to build.

It is worth knowing what happened to that argument, because it is a good example of a real benefit
that lost to a different real benefit.

First, the caveat that was always true: the Scala implementation **already had it**. Scala.js
compiles from the same source tree as the JVM server, so shared wire types were a property the Rust
rebuild *preserved*, not one it introduced.

Second, the measurement that ended it. The download-size objection to WebAssembly turned out to be
a non-issue — both implementations measured within 2% of each other on the critical path, because the
dominant term is the application rather than the language. But that cuts the other way too: an
application is the wrong thing to ship when the workload is documents. The Leptos client made content
readable at 1.25 s on broadband and **7.2 s on a mid-range phone over Fast-3G**, and that number is
what the web tier now answers to.

So the shared crate is gone, and its replacement is code generation: the server's OpenAPI document is
rendered from the handlers themselves, the web tier's TypeScript types are generated from it, and CI
fails if the checked-in generated file is not what the current server produces.

| | Shared crate | Generated types |
|---|---|---|
| A renamed field | fails to compile | fails CI |
| Enforced by | one compiler, one build | a generator plus a check |
| Guarantee | no intermediate artifact to be stale | an artifact whose freshness is checked |
| Reach | clients written in Rust | anything that can read OpenAPI |

That is a compile-time guarantee traded for a build-time one. Weaker, and worth saying so plainly —
but the thing that forced the trade was never type safety.

The visualisation engine kept the Rust argument that *did* survive: it is genuine compute — a
320-tick O(n²) force simulation over flat float arrays, thousands of pure lines with recorded goldens
— so it stayed, as a lazy 288 KiB gzipped module that only pages with widgets ever fetch.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **A budget is a decision that keeps being made.** Measuring once tells you today's number. Failing
the build over it is what makes every future dependency argue for its own weight. When the
architecture changed, the budget changed shape with it: a single 700 KiB bundle cap became a 250 KiB
cap **per page kind**, because "the bundle" stopped being a thing that exists.

</div>

## Keeping the TypeScript

Long before the web tier was TypeScript, the *islands* were. A full-Rust rewrite would have meant
reimplementing a markdown pipeline, a code editor, two diagram layout engines and two language
tracers. Those are mature libraries with stable interfaces; rewriting them would take months and
produce something worse for years.

So the rule was: **rewrite what is mine, keep what is solved.** A markdown renderer is not bespoke
and benefits from nothing.

**Provenance matters here.** Several islands — the markdown renderer, the diagram bridges, the editor
integration and both tracer harnesses — have now been carried across three implementations of this
same platform, which I wrote each time. They are not third-party code, but they are also not new:
they are the parts that were already right, and the fact that they survived two rewrites unchanged is
the strongest evidence that the seam around them was drawn in the right place.

The one that reads oddest is worth keeping: the visualisation crate's generated bindings still import
the editor and tracer islands by the module specifiers the deleted Rust client defined. The seam
outlived the code on the other side of it, which is what a well-chosen boundary looks like from the
outside.

## Configuration, and a precedence trap

Configuration is env-first and layered. The layering has a subtlety worth publishing, because it
nearly caused a silent production failure:

`SYNAPSE_`-prefixed variables are merged **before** the unprefixed ones, so a bare `DATABASE_URL`
**wins** over `SYNAPSE_DATABASE_URL`. Setting only the prefixed name, while an unprefixed one existed
in the environment, would have connected the application to the wrong database — with no error,
because both are valid.

The related trap is that Kubernetes injects service-discovery variables named after services. A
service called `synapse` produces `SYNAPSE_PORT=tcp://10.43.11.10:80`, which collides with the
application's own `SYNAPSE_PORT`. The fix is one line — disable service links — and the lesson is
that a configuration namespace is only as private as the environment it shares.

Both were caught by rehearsing the deployment in the real namespace rather than reasoning about it.

## What was rejected

| Rejected | Why |
|---|---|
| An ORM | the queries are simple and few; compile-checked SQL is more honest than a query DSL |
| Microservices | ten contexts, one team, no independent scaling need — see the architecture chapter |
| A managed cloud database | the whole point was to run it myself and know what that costs |
| Kubernetes operators for everything | the cluster is four nodes; the operational surface should match |
| Rewriting the TS islands | months of work to reproduce working behaviour |
| A working-copy clone for content edits | a pod that restarts mid-push leaves one in an unknown state; stateless REST has no such failure mode |
| A WYSIWYG content editor | it would fight the authored fence vocabulary the whole pipeline depends on |

The one I would revisit first is the managed database — not because self-hosting failed, but because
the case study measures exactly what it costs in availability, and that number is the largest
single risk in the system.

### One entry moved to the other table

An earlier version of this chapter listed **server-side rendering** as rejected, with the reason:
*"the client is an application, not a document; the read path is cached anyway."*

Both halves were wrong in an instructive way. The read path *is* cached — but the cache was serving a
641 KiB application shell quickly, which does not help a reader waiting for a page to boot before it
shows them a paragraph. And "the client is an application" was a description of the code, not of the
workload: 99% of traffic reads prose. I had classified the system by what I had built rather than by
what it did.

Leaving the mistake visible is more useful than quietly editing the table, because the reasoning
error is the transferable part. **A rejected option deserves re-examination when the sentence
justifying it contains an assumption about your users rather than a measurement of them.**

<details>
<summary>Rewriting a working platform in a new language is usually a bad idea. What made it defensible here — and when would it not be?</summary>

It was defensible because of what was actually being optimised for, and it is worth being honest that
"the old one was too slow" was **not** the reason. The previous implementation worked.

Four things made it reasonable:

1. **The rewrite had a measurable target.** Memory on a constrained cluster, with a before number and
   an after number. Not "cleaner" or "more modern".
2. **The specification already existed** — a working implementation, its test suites and its golden
   files. That is the cheapest possible spec, and it turns "did I break it?" into a test run.
3. **Learning was an explicit goal, not a rationalisation.** The purpose included becoming fluent in
   the stack. Rewrites justified by learning are honest as long as you say so out loud.
4. **The blast radius was bounded.** One person, one deployment, no customer contract, and the old
   version stayed deployable throughout — the rollback was a tag.

It would **not** be defensible with a team that has to keep shipping features during the rewrite, or
where the old system's behaviour is undocumented and only partly understood — then you are
reimplementing a specification nobody has, and the rewrite discovers requirements by breaking them in
production. Nor where the motivation is aesthetic: "the old stack is ugly" predicts nothing about
whether the new one will still look good once it has carried real load for a couple of years.

The test I would apply: *can you state the win as a number, and do you have an executable
specification?* Here it was 256 Mi → 6 Mi, and 400-odd ported tests. Without both, a rewrite is
usually a very expensive way to reorganise code.

</details>
