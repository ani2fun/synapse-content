---
title: "Execution and submission"
summary: "C4 level 3 for the run path: the three gates every run passes, the go-judge adapter, how a trace is just a run with a harness around it, and how submission judges by borrowing execution rather than duplicating it."
essential: true
---

# Execution and submission

> **You'll be able to:** list the three gates a run passes and say why they are in that order; explain
> what an anonymous run gets that a signed-in one does not; and describe how the visualiser traces a
> program without any tracing endpoint on the server.

Two contexts share the run path. `execution` runs one program in the sandbox and returns what it
printed. `submission` judges a solution against a problem's hidden test suite, and does it by calling
`execution` — never a second runner.

## The components

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

browser: "Workbench / tracer\n[browser]" { class: client }

origin: "Origin server" {
  run: "POST /api/run" { class: edge }
  admission: "Admission\n[6 total · 2 per caller]" { class: edge }
  limiter: "RateLimiter\n[per IP · per subject]" { class: edge }
  exec: "RunCodeService\n[language · recipe · tier]" { class: svc }
  submit: "POST /api/submissions" { class: edge }
  judge: "SubmitSolution\n[202, judge in background]" { class: svc }
  tests: "FsProblemTests\n[hidden suite via catalog port]" { class: svc }
  runner: "GoJudgeRunner\n[CodeRunner adapter]" { class: svc }
}

sandbox: "go-judge" { class: svc }
db: "Postgres\n[submissions, submission_allowlist]" { class: data; shape: cylinder }

browser -> origin.run
origin.run -> origin.admission -> origin.limiter -> origin.exec
origin.exec -> origin.runner -> sandbox: "/run"
browser -> origin.submit
origin.submit -> origin.judge
origin.judge -> origin.tests: "suite_for(lesson)"
origin.judge -> origin.exec: "one case at a time"
origin.judge -> db
```

| Component | File | Job |
| --- | --- | --- |
| run handler | `execution/http/mod.rs` | `POST /api/run`; applies the three gates |
| `Admission` | `platform/admission.rs` | bounds runs in flight, per caller and in total |
| `RateLimiter` | `platform/rate_limiter.rs` | bounds runs per time window |
| language model | `execution/domain/language.rs` | the 11 languages, their fence aliases and labels |
| recipe | `execution/infrastructure/recipe.rs` | compile and run commands, limits, and the anonymous share |
| `GoJudgeRunner` | `execution/infrastructure/runner.rs` | the `CodeRunner` adapter: HTTP to go-judge |
| Java rewriter | `execution/infrastructure/java_rewriter.rs` | renames the entry class to `Main` |
| `SubmitSolution` | `submission/application/mod.rs` | accepts, judges in a background task, records the verdict |
| `FsProblemTests` | `submission/infrastructure/problem_suite.rs` | reads the hidden suite through the catalog's port |

## Three gates, cheapest first

Every `POST /api/run` passes three gates, in this order, because each one is cheaper to fail than the
next one is to pass:

1. **Admission.** Is there room in the sandbox? At most **6** runs may be in flight in total and **2**
   per caller. Past either limit the run is refused in a millisecond — `SandboxBusy` (503) or `CallerBusy` (429)
   — rather than queued. go-judge runs one program at a time, so a queue would only mean a request
   that waits two minutes and then times out. The limit per caller is 2, not 1, because Cancel in the
   workbench only abandons the response: the run it started still finishes, and pressing Run again
   must not be refused.
2. **Rate budget.** Has this caller spent its budget? An anonymous caller is metered per IP address
   (10 runs per 60 s by default), a signed-in caller per account (100 per hour), and all anonymous
   callers together share a ceiling of 120 per window — the circuit breaker that per-IP budgets cannot
   be, since a hundred addresses get a hundred budgets. A bad token is a 401, never a silent fallback
   to anonymous.
3. **The run, at the caller's tier.** A signed-in run gets each language's full limits; an anonymous
   run gets **50 %** of the CPU and wall-clock time (`SYNAPSE_RUN_ANON_TIME_PERCENT`).

A `Ticket` holds the admission place and gives it back on drop, so every way out of a run — success,
error, panic — releases it.

The defaults per run are 15 s of CPU, 30 s of wall clock, 512 MiB of memory and 256 processes. A
program that misbehaves is still a `200` with a non-`Accepted` status: the error channel is kept for
the *caller's* mistakes (422, 413), the backend's failures (502, 503), the budget (429) and a full
sandbox (503).

## Languages

Eleven: Python, Java, Scala, C, C++, Go, Rust, Kotlin, TypeScript, JavaScript and SQL. A fence's
language tag is an alias (`py`, `cpp`, `rs`, …) resolved on the server, and every alias is globally
unique — a test checks that.

Java has one adjustment. The sandbox writes `Main.java` and runs `java Main`, but lessons write
`class Solution`. The rewriter renames the first top-level class to `Main` unless a `Main` already
exists, or the source is a tracer harness, which carries the sentinel `// __SYNAPSE_TRACER__`.

## A trace is a run

The visualiser steps through a program line by line, and the server has no tracing endpoint. The
browser wraps the program in a **harness** — for Python, `web/src/lib/islands/tracer/python-harness.py`
— that prints a JSON event before every line, with the frames, the objects and the output so far. The
wrapped program goes through `POST /api/run` like any other, passing the same three gates, and the
`viz-wasm` engine decodes the events and draws them.

When the program calls `input()` with nothing left to read, the harness raises `_SynAwaitInput` and
stops. The page asks the reader for a line, then runs the whole program again from the top with the
inputs collected so far. Re-running is simpler than pausing a sandboxed process, and the programs are
small.

## Submission borrows execution

`submission` holds `execution`'s own `RunCodeService` — a customer–supplier relationship, with the
dependency pointing one way. It never duplicates the runner, so a fix to languages, limits or the Java
rewrite reaches judging for free.

A submission is accepted with **202** and judged in a background task, one case at a time, in the
order the suite was written. Authorisation runs before anything is stored, so a rejected submission
never creates a row: in production the caller must be signed in **and** on the submit allowlist
(`SUBMISSION_ALLOWLIST_ENFORCED=true`). An accepted verdict marks the problem solved through the
`SolvedRecorder` port, which `progress` implements.

The detail — the state machine, the poll, and what happens to a judge that dies with the process — is
at the code level: [The submission lifecycle](/synapse/synapse-features/code/the-submission-lifecycle).

<details>
<summary>Why refuse a run when the sandbox is full, instead of queueing it?</summary>

Because the queue would not be free. A run that waits still holds an HTTP connection and counts
against the edge's two-minute timeout. With go-judge running one program at a time, a handful of
callers sending slow programs would fill the queue, and everyone behind them would wait out the
timeout and get an error anyway — two minutes later. Refusing at once with "the sandbox is busy, try
again" gives the same outcome in a millisecond and lets the reader decide. A bounded queue is only
worth having when the wait is short compared to the timeout, and here it is not.

</details>
