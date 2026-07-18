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
| Client | Rust + Leptos → WASM | shared types with the server, fine-grained reactivity | bigger download than JS; a small ecosystem |
| Islands | TypeScript, kept | mature libraries not worth rewriting | two languages, one serialisation seam |
| Config | figment | env-first, layered, typed | precedence needs care (see below) |
| Errors | thiserror per context | typed, exhaustive, no stringly errors | more code than `anyhow` everywhere |
| Sandbox | go-judge | purpose-built, resource-capped, isolated | an extra service to run |
| Identity | Keycloak | standards-compliant OIDC; not my problem to invent | heavyweight for one user |
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
| Container image | JRE + app | static binary, distroless |

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
- Private fields on `RunHandle` make a fabricated token impossible, so the staleness guard cannot be
  fooled.
- Ownership across the FFI boundary makes editor teardown deterministic instead of a cleanup call
  someone forgets.

Each is a bug I would otherwise have written, found in production, and fixed with a comment saying
"remember to…". The value is that the compiler remembers instead.

## Sharing types across the wire

Client and server are the same language, so the wire types are defined **once** in a shared crate
that compiles both natively and to WebAssembly. Rename a field and both ends fail to build.

This is the main reason the client is Rust at all. It is worth being clear about what it costs: the
WebAssembly bundle is larger than equivalent JavaScript. Measured from production right now:

| Asset | Transfer size |
|---|---|
| entry JS | 10,329 B |
| CSS | 16,100 B |
| WASM | 619,122 B |
| **Critical path** | **~630 KiB of a 700 KiB budget** |

The budget is a CI gate, because a number like that only moves in one direction unless something
stops it. The editor and the diagram engines are *not* in that figure — they load on demand, which is
what keeps the entry path affordable.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **A budget is a decision that keeps being made.** Measuring the bundle once tells you today's
number. Failing the build at 700 KiB is what makes every future dependency argue for its own weight.

</div>

## Keeping the TypeScript

A full-Rust rewrite would have meant reimplementing a markdown pipeline, a code editor, two diagram
layout engines and two language tracers. Those are mature libraries with stable interfaces; rewriting
them would take months and produce something worse for years.

So the rule became: **rewrite what is mine, keep what is solved.** The application logic — routing,
state, the executor machine, the visualisation contract — is bespoke and benefits from shared types.
A markdown renderer is not bespoke and benefits from nothing.

The price is a two-language codebase with a serialisation seam. That is a real cost, and it is
bounded deliberately: five modules, strings and handles across the boundary, never object graphs.

**Provenance matters here.** Several islands — the markdown renderer, the diagram bridges, the editor
integration and both tracer harnesses — were carried over from the previous implementation of this
same platform, which I also wrote. They are not third-party code, but they are also not new: they are
the parts that were already right.

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
| Microservices | seven contexts, one team, no independent scaling need — see the architecture chapter |
| Server-side rendering | the client is an application, not a document; the read path is cached anyway |
| A managed cloud database | the whole point was to run it myself and know what that costs |
| Kubernetes operators for everything | the cluster is four nodes; the operational surface should match |
| Rewriting the TS islands | months of work to reproduce working behaviour |

The one I would revisit first is the managed database — not because self-hosting failed, but because
the case study measures exactly what it costs in availability, and that number is the largest
single risk in the system.

## Check yourself

```quiz
{"prompt": "The Rust implementation idles at ~6 Mi RSS versus the JVM's ~256 Mi floor. When does that 40× difference actually matter?", "options": ["Always — lower memory usage is universally better", "When memory is the binding constraint, as on a small self-hosted cluster; on a cloud instance where 1 GiB is cheap, it is close to a rounding error", "Only for applications with more than 1000 users", "It matters most for reducing cloud bills"], "answer": "When memory is the binding constraint, as on a small self-hosted cluster; on a cloud instance where 1 GiB is cheap, it is close to a rounding error"}
```

```quiz
{"prompt": "Why does a bare `DATABASE_URL` override `SYNAPSE_DATABASE_URL`, and why is that dangerous?", "options": ["Because unprefixed variables are more specific", "Because prefixed variables are merged first and later layers win — so setting only the prefixed name while an unprefixed one exists silently connects to the wrong database, with no error", "Because the prefix is stripped at startup", "Because Kubernetes strips prefixes from environment variables"], "answer": "Because prefixed variables are merged first and later layers win — so setting only the prefixed name while an unprefixed one exists silently connects to the wrong database, with no error"}
```

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
