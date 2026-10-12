---
title: "Local development and testing"
summary: "A runbook: start the whole platform on one machine, sign in, see a content change, and run the same gates CI runs — with the ports, the commands and the traps that cost time."
essential: false
---

# Local development and testing

> **You'll be able to:** run Synapse on your own machine with the real database, sandbox and identity
> provider; preview a content repository you are editing before you push it; and run the test suites
> and gates locally before CI does.

Everything below runs from the app repository, `ani2fun/synapse`, cloned next to the content
repositories (the dev script expects `../synapse-content-github/…`).

## Prerequisites

| Tool | Why |
| --- | --- |
| Docker | Postgres, Keycloak and go-judge run from `docker-compose.yml` |
| Rust (pinned by `rust-toolchain.toml`) | the origin server |
| Node 22 and npm | the Astro web tier and the e2e suite |
| Go | the d2-render sidecar, built by the dev script |
| `d2` CLI (optional) | compiling diagrams while writing content |

## Start the stack

```bash
docker compose up -d
```

That starts the three backing services:

| Service | Image | Port on your machine |
| --- | --- | --- |
| `db` | `postgres:17-alpine` | 5532 |
| `keycloak` | `quay.io/keycloak/keycloak:26.0`, dev realm imported from `dev-tools/keycloak/` | 8181 |
| `go-judge` | built from `runner/go-judge/` (privileged) | 5150, bound to 127.0.0.1 |

Then the application:

```bash
./dev-tools/dev
```

It checks that Postgres answers before it spends 30 seconds compiling, builds and starts d2-render on
**8390**, starts the origin on **8280**, and runs the Astro dev server on **5373** in the foreground
with hot reload. Open `http://localhost:5373`. Ctrl-C stops all three.

| Port | What |
| --- | --- |
| 5373 | Astro dev server — open this one |
| 8280 | origin API (`/api/health` answers when it is up) |
| 8390 | d2-render |

⚠️ Do not move the web port. **5373 is on the Keycloak dev realm's allowed-origin list**, and a
different port makes the silent sign-in iframe fail with a 403 that looks like a Keycloak bug.

## Sign in

The dev realm ships a test user, `tester`. It is also the default `ADMIN_USERS` and is seeded into the
submit and content-editor allowlists by the migrations, so signing in as `tester` exercises every
gated feature: submissions, Suggest an edit, `/admin`, and the private-book gate. Edits run in
`CONTENT_FORGE=dry-run` by default — the whole flow, minus the final pull request.

The coach stays off unless you run Ollama locally and set `TUTOR_ENABLED=true` (default model
`llama3.1`, `TUTOR_URL=http://localhost:11434`).

## See a content change

The dev server reads the primary content repository from `../synapse-content-github/synapse-content`
and **mounts the satellite repositories straight off disk** through `SYNAPSE_LOCAL_SOURCES`, so a
guide you are editing shows up without a push, a registry row or a fetch. The dev script's default
list mounts the guides that sit next to it, including one private guide readable only by `tester` and
named readers.

Save a lesson, refresh the page. There is no build step for content; the catalog re-reads it on the
next request.

Before pushing a content repository, run the server's own checks over it:

```bash
cargo run --bin validate_book -- ../synapse-content-github/python-guide
```

It uses the same walker as the server, so what it reports is what the site will do. For diagrams,
compile each D2 fence with `d2 --layout elk --pad 20`, which matches the engine the reader gets.

## Run the tests

| Suite | Command | Needs |
| --- | --- | --- |
| Conventions gate (purity, caps, test placement) | `dev-tools/check-conventions.sh` | nothing — `grep`, `find`, `wc` |
| Rust unit and integration tests | `cargo test` | Postgres for the database ITs |
| Coverage floor | `dev-tools/coverage.sh --check` | Postgres |
| Web unit tests | `cd web && npm test` (vitest) | nothing |
| Generated API types | `dev-tools/gen-api-types.sh`, then `git diff` | Rust |
| End-to-end smoke + page budget | `dev-tools/e2e` | `docker compose up -d db` |

`dev-tools/e2e` is the one to run before a pull request. It builds a **production-shaped** serve — the
origin fronting the Node server, the same two processes as the production image — against fixture
content, runs the Playwright specs, then the per-page budget on the same stack. It uses fixtures, not
the real content, so an unrelated edit in a content repository cannot turn the app's suite red; point
`SYNAPSE_ROOT` at the real tree to spot-check against it.

CI runs all of these on every push, plus two checks that cannot be faked locally: the go-judge
integration tests against the **real** sandbox, and a "prove it ran" step after each suite, because a
suite that silently skips reports green.

## Traps that cost time

- **Postgres is not optional.** The origin applies migrations at boot and refuses to start without a
  database. The dev script checks first and tells you to run `docker compose up -d`.
- **Keycloak down means 503, not 401.** Signed-in features answer "cannot check" while reading and
  running keep working. If sign-in fails, check `http://localhost:8181` before the app.
- **A malformed `SYNAPSE_LOCAL_SOURCES` stops the boot.** Half a library served as if it were whole is
  the worse outcome, so the server refuses instead.
- **The dev server sends no production headers.** Vite does not emit the CSP, so a CSP breakage only
  shows on the production-shaped serve — another reason to run `dev-tools/e2e`.
