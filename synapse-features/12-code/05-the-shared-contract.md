---
title: "The shared contract"
summary: "C4 level 4 for the seam between the browser and the origin: one Rust crate of wire types, an OpenAPI document generated from the handlers, TypeScript types generated from that, and three tests that keep all of it honest."
essential: false
---

# The shared contract

> **You'll be able to:** trace a field from a Rust struct to the TypeScript that decodes it; name the
> three mechanical checks that stop the two sides drifting; and say what was given up when the client
> stopped being Rust.

The origin is Rust and the web tier is TypeScript. Every request crosses that line, so the shape of
each request and response has to be agreed somewhere — and agreed in a way a build can check.

```d2
direction: right

classes: {
  svc:  { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data: { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  gate: { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
}

shared: "shared/src/*.rs\n[DTOs · serde only]" { class: data }
handlers: "server handlers\n[#[utoipa::path]]" { class: svc }
apidoc: "ApiDoc\n[OpenAPI, rendered at build]" { class: data }
oracle: "api/openapi.oracle.yaml\n[committed reference]" { class: data }
gen: "web/src/lib/api/schema.gen.ts\n[generated]" { class: data }
web: "web tier\n[TypeScript]" { class: svc }

lock: "contract_it.rs\n[contract lock]" { class: gate }
fresh: "CI: regenerate + git diff\n[freshness]" { class: gate }

shared -> handlers: "used by"
handlers -> apidoc: "utoipa"
apidoc -> gen: "dump_openapi → openapi-typescript"
gen -> web: "imported by"
lock -> apidoc: "covers every path in"
lock -> oracle
fresh -> gen
```

## The kernel crate

`shared/` is the smallest crate in the workspace, and its only dependency is `serde`. It holds the
wire types both sides need — one module per context (`catalog`, `execution`, `submission`, `notes`,
`canvas`, `tutor`, `authoring`, …) — plus a few pure models, such as the judge's verdict rules.

It compiles both natively, for the server and for fast tests, and to `wasm32`. The visualisation
engine used to live here too and moved out to its own `viz-wasm` crate: the server never references
it, so it had no business in the contract kernel.

## From Rust struct to TypeScript type

The chain has four links:

1. A DTO is a Rust struct in `shared/` — for example `synapse_shared::notes::NoteDto`.
2. Each handler is annotated for **utoipa**, and `lib.rs` collects every path and schema into
   `ApiDoc`. The OpenAPI document is **code-first**: the handlers are the specification.
3. `dev-tools/gen-api-types.sh` builds the `dump_openapi` binary, runs it to print the document, and
   feeds that to `openapi-typescript`, which writes `web/src/lib/api/schema.gen.ts`.
4. The web tier imports its request and response types from that generated file.

A renamed field therefore breaks the TypeScript build, not a reader's page.

## Three checks keep it honest

| Check | Where | Catches |
| --- | --- | --- |
| **Contract lock** | `server/tests/contract_it.rs` | the rendered OpenAPI document must cover every path and method in `api/openapi.oracle.yaml`, and agree with it on property names and required fields |
| **Freshness** | the CI job that runs `gen-api-types.sh` and then `git diff --exit-code` on `schema.gen.ts` | a server change that was not regenerated into the web tier |
| **Twin test** | `shared/test-vectors/judge-vectors.json`, run by both `shared/src/execution/tests/judge_vectors.rs` and `web/src/lib/execution/judge.test.ts` | the TypeScript port of the judge (verdicts, `stdin_for`) disagreeing with the Rust original |

The oracle file is the API's **record of what it promised**, separate from what it currently compiles
to. It grows in lock-step as endpoints are added, so removing or renaming a promised field is a red
test rather than a production surprise.

The twin test exists because one piece of logic genuinely runs on both sides: the workbench judges
sample cases in the browser for instant feedback, and the server judges the hidden ones. The two
implementations are checked against the same JSON vectors, so drift is caught mechanically on either
side of the port.

One quirk is worth knowing. `BookDto` and `ChapterDto` are self-referential trees, marked
`schema(no_recursion)`, which stops utoipa from walking into them — so `lib.rs` lists `BookEntryDto`
and `ChapterDto` explicitly, or the document would ship a dangling `$ref`. `openapi-typescript` is a
stricter reader than the server's own tests, and it is what found that.

<details>
<summary>What was given up when the client stopped being Rust?</summary>

A one-step guarantee became a two-step one. With a Rust client, both sides were checked against the
same type definitions by the same compiler in the same build; there was no artifact in between that
could be stale. Now there is — `schema.gen.ts` — and its freshness is enforced by a CI job. A CI job
is a good mechanism, but it is a mechanism; the old property needed none.

What came back is a **published** contract. Anything can read the OpenAPI document, not just Rust,
and the oracle gives the API a record of its promises that the shared crate never had.
[The web tier](/synapse/synapse-features/containers/the-web-tier) tells the rest of that story.

</details>
