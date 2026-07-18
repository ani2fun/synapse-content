---
title: "The client: three layers, signals, and the island boundary"
summary: "A reactive SPA compiled to WebAssembly, layered so the interesting logic is testable without a browser — and a deliberate seam where Rust hands off to TypeScript."
essential: true
---

# The client: three layers, signals, and the island boundary

> **You'll be able to:** split UI code so its logic is testable without a browser; model two
> independent concerns as orthogonal state rather than a combinatorial enum; and use an opaque
> token type to make stale async results impossible to apply.

## Three layers, where they are earned

Each client feature can have three layers:

```
client/src/<feature>/
  logic/     pure functions and state machines — no leptos, no web-sys, no DOM
  state/     signals; the reactive graph
  view/      components that render state
```

The honest picture of who actually has them:

| Split | Features |
|---|---|
| Full `logic` + `state` + `view` | `catalog`, `execution`, `search` |
| `state` + `view` only | `blog`, `identity` |
| Flat | `api`, `islands`, `quiz`, `router`, `shell`, `tutoring`, `viz` |

Three of twelve. That is not backlog — it is the same proportionality rule the server uses. A
`logic/` layer earns its place when there is something to test without a browser: catalog has path
resolution and tree walking, execution has a state machine, search has ranking. `quiz` renders a
question and compares an answer to a string; giving it three directories would be filing, not design.

What makes the boundary real rather than aspirational is that it is CI-enforced, the same way the
server's domain purity is:

```
→ client logic purity (no leptos/web-sys/wasm-bindgen/js-sys/gloo under logic/)
  ok
```

The payoff is concrete: everything under `logic/` compiles and tests **natively**. No browser, no
WASM toolchain, no headless driver — `cargo test` runs the state machine in milliseconds. Testing UI
logic is usually painful because it is entangled with the DOM; here that entanglement is a build
failure.

## Signals, not a virtual DOM

The framework is fine-grained reactive. There is no VDOM and no re-render pass: a signal knows
exactly which DOM nodes depend on it, and updating it touches only those.

| Primitive | Role |
|---|---|
| `RwSignal<T>` | mutable reactive state |
| `Memo<T>` | derived value, recomputed only when inputs change |
| `Effect` | runs on change — the escape hatch to imperative APIs |
| `StoredValue<T>` | non-reactive storage that survives across reactive scopes |
| `NodeRef` | a handle to a real DOM element, for handing to an island |

The practical consequence is that "what updates when" is a property of the data flow rather than of a
diffing heuristic. The cost is that reactivity is **ownership-scoped**: every signal belongs to a
reactive owner, and when that owner is disposed the signal goes inert — it still exists, updates
silently do nothing, and nothing warns you.

That failure mode is not hypothetical. An application-wide store created under a *page's* owner keeps
working until the reader navigates away, at which point the page is disposed and the store silently
stops updating. The fix is structural: application-level stores are created under the application's
owner and passed down through context, never conjured wherever they are first used. Lifetime is part
of the design, not an implementation detail.

## Two independent concerns, modelled independently

The runnable code block tracks whether code is executing **and** whether the editor is editable.
These are genuinely orthogonal — you can edit while a run is in flight — so they are two types.

Run this to see why that matters. The last two lines are the whole argument:

```rust run
// Two orthogonal concerns. A runnable block tracks whether code is EXECUTING and
// whether the editor is EDITABLE — independently, since you can edit mid-run.
// Modelled separately they compose; fused into one enum they multiply.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum RunState {
    Idle,
    Running,
    Done,
}

/// Orthogonal to `RunState`. Whether the reader MAY edit is the caller's policy,
/// not the machine's business — which is why authentication does not appear here.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum EditMode {
    ReadOnly,
    Editing,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Block {
    run: RunState,
    edit: EditMode,
}

fn main() {
    let runs = [RunState::Idle, RunState::Running, RunState::Done];
    let edits = [EditMode::ReadOnly, EditMode::Editing];

    println!("every reachable combination:");
    let mut n = 0;
    for r in runs {
        for e in edits {
            println!("  {:?}", Block { run: r, edit: e });
            n += 1;
        }
    }

    println!();
    println!("composed: {} + {} variants across two types", runs.len(), edits.len());
    println!("fused:    {} variants in one enum, every one hand-written and matched", n);
    println!();
    println!("Add a third concern with 2 values:");
    println!("  composed -> {} + 2 = {}", runs.len() + edits.len(), runs.len() + edits.len() + 2);
    println!("  fused    -> {} x 2 = {}", n, n * 2);
    println!("\nOne grows by addition. The other grows by multiplication.");
}
```

```mermaid
stateDiagram-v2
    direction LR
    state "RunState" as RS {
        [*] --> Idle
        Idle --> Running: run()
        Running --> Done: completed(handle)
        Running --> Done: failed(handle)
        Done --> Running: run() again
        Done --> Idle: clear_outcome()
    }
    state "EditMode" as EM {
        [*] --> ReadOnly
        ReadOnly --> Editing: toggle (auth-gated by caller)
        Editing --> ReadOnly: toggle
    }
```

The two regions are independent, which is exactly what the program above counts: the fused
alternative — `IdleReadOnly`, `IdleEditing`, `RunningReadOnly`, … — needs every combination written
out and matched, and a third concern doubles that list rather than adding to it.

The comment on `EditMode` is doing deliberate design work too. The FSM does **not** know about
authentication. Whether a reader may edit is a policy decision belonging to the caller; baking it in
would give the state machine a dependency on identity and make it untestable in isolation. The
machine tracks *what mode the editor is in*, not *who is allowed to change it*.

## Making stale results unrepresentable

Every run is asynchronous, so a reply can arrive after the reader has already started a new run.
Applying it would show the previous run's output as if it were current.

The guard is a token type — an opaque, monotonic `RunHandle` that cannot be fabricated outside its
module, so a stored handle can only have come from `started()`.

Starting a run mints a new handle. Completion carries the handle it belongs to, and the transition
compares it to the current one — a mismatch is a **no-op**, not an error.

Here is the whole mechanism as a program you can run. Press ▶, then try breaking it: delete the
`if handle != self.run_id` guard and watch run 1's output overwrite run 2's.

```rust run
// The runnable-block state machine, cut down to the part that matters: a run in
// flight, a restart, and a reply from the run that no longer matters.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum RunState {
    Idle,
    Running,
    Done,
}

/// Opaque and monotonic. The field is PRIVATE, so nothing outside this module can
/// fabricate one — a handle you hold provably came from `started()`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct RunHandle(u64);

#[derive(Debug, Clone, PartialEq, Eq)]
struct Executor {
    state: RunState,
    run_id: RunHandle,
    output: Option<String>,
}

impl Executor {
    fn new() -> Self {
        Executor { state: RunState::Idle, run_id: RunHandle(0), output: None }
    }

    /// Mint a fresh handle: starting a run invalidates whatever was in flight.
    #[must_use]
    fn started(&self) -> Self {
        Executor { state: RunState::Running, run_id: RunHandle(self.run_id.0 + 1), output: None }
    }

    /// Apply a reply ONLY if it belongs to the run currently in flight.
    #[must_use]
    fn completed(&self, handle: RunHandle, out: &str) -> Self {
        if handle != self.run_id {
            return self.clone(); // stale — a no-op, not an error
        }
        Executor { state: RunState::Done, run_id: self.run_id, output: Some(out.to_owned()) }
    }
}

fn main() {
    let first = Executor::new().started();
    let stale_ticket = first.run_id;
    println!("run 1 started   -> {:?}", first.state);

    let second = first.started(); // the reader hits Run again
    println!("run 2 started   -> {:?}  (run 1's ticket is now stale)", second.state);

    let after_stale = second.completed(stale_ticket, "output of run 1");
    println!("run 1 replies   -> changed anything? {}", after_stale != second);
    println!("                   output = {:?}", after_stale.output);

    let done = second.completed(second.run_id, "output of run 2");
    println!("run 2 replies   -> output = {:?}", done.output);
}
```

Two details make this sturdier than a boolean flag. The field is **private**, so no other module can
construct a `RunHandle` — a handle in hand provably came from `started()`. And the transitions are
pure functions on state, so the guard is verified by a native unit test rather than by racing a real
browser, which is why the program above needs no async machinery to demonstrate an async bug.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **A stale async reply is a correctness bug, not a UI glitch.** Any interface that can start an
operation twice needs an identity on each attempt and a rule for what to do with the loser. Silently
discarding is usually right; silently *applying* is the bug that shows a stale verdict next to fresh
code.

</div>

## The island boundary

Some work has excellent JavaScript implementations and no reason to be rewritten: a code editor, a
markdown pipeline, diagram layout engines, language tracers. These stay TypeScript, behind five
declared seams:

| `#[wasm_bindgen(module = …)]` | What it brings in |
|---|---|
| `@markdown/loader` | markdown → HTML, syntax highlighting |
| `@editor/loader` | the code editor |
| `@diagram/loader` | mermaid + d2 rendering |
| `@tracer/loader` | language tracers |
| `@auth/loader` | OIDC/PKCE |

Five modules, each a **loader** rather than the library itself. That indirection is what makes the
heavy dependencies lazy: the editor is hundreds of kilobytes and a diagram engine is multiple
megabytes of WebAssembly, and a reader who never opens either should download neither. The loader
dynamically imports on first use, so cost is paid on demand.

The rule for what crosses the boundary: **strings and handles, not object graphs.** Send markdown,
receive HTML. Send diagram source, receive SVG. Every value crossing pays a serialisation cost, so a
chatty interface would be slower than either side alone.

### Lifetimes across a foreign boundary

The hardest part is not calling TypeScript — it is cleaning up after it. A mounted editor holds
JavaScript closures that keep Rust values alive; drop the Rust side carelessly and you get a leak, or
a callback firing into a disposed owner.

The answer is to make the editor handle own its closures and dispose them on `Drop`. Rust's
destructor timing is deterministic, so when the component goes away the handle drops, the closures
are released, and the editor is torn down — in that order, without a manual cleanup call anyone can
forget. This is one place where Rust's ownership model is a genuine advantage at an FFI boundary
rather than a tax.

## The WebAssembly boundary, precisely

There is a second boundary, and unlike the island seam it was not designed — it is imposed by the
platform. **WebAssembly cannot touch the DOM.** It has linear memory, a flat byte array, and no
access to JS objects. Every DOM operation therefore crosses into JavaScript glue.

This is where the comparison with the previous implementation gets interesting, because Scala.js
compiles *to JavaScript*. `document.createElement("div")` in Laminar emitted literally that: native
JS strings, DOM nodes held directly, zero marginal cost per operation. Rust cannot do this, so it is
worth knowing exactly what it pays instead — and the answer has changed recently enough that most
descriptions of it are out of date.

Reading the generated glue in this repository (wasm-bindgen 0.2.126), the module declares **251
import shims**. The next two blocks are **quoted from that generated file** rather than written for
this chapter — they are evidence you can go and check, not programs to run. A representative shim:

```js
__wbg_closest_d889c758da4bb13b: function (arg0, arg1, arg2) {
    const ret = arg0.closest(getStringFromWasm0(arg1, arg2));
    return isLikeNone(ret) ? 0 : addToExternrefTable0(ret);
}
```

Three things are visible there, and they are not equally expensive.

**Object references are cheap now.** `arg0` is the DOM element itself — a real reference, passed
straight through. Older wasm-bindgen kept a JavaScript array as a handle table and passed integer
indices into it; this build uses **reference types**, so the element is an `externref` the WASM module
holds directly. Returned objects go into a WASM-side table:

```js
function addToExternrefTable0(obj) {
    const idx = wasm.__externref_table_alloc();
    wasm.__wbindgen_externrefs.set(idx, obj);
    return idx;
}
```

That is a table allocation, not a JS-array scan, and it participates in the host GC. The "every DOM
reference costs a lookup in a side table" objection is largely a description of the old model.

**Strings are still marshalled, and this is the real cost.** `getStringFromWasm0(arg1, arg2)` takes a
pointer and a length into linear memory and runs a UTF-8 → UTF-16 decode —
`cachedTextDecoder.decode(getUint8ArrayMemory0().subarray(ptr, ptr + len))`.

**56 of the 251 shims decode a string that way.** And strings are pervasive in DOM work — tag names,
class names, attribute names and values, event names. Scala.js pays none of this, because its strings
are already JS strings.

**The call itself** is an import crossing. Modern engines inline much of it; it is the smallest of
the three terms.

### Put a number on it

That is the mechanism. Rather than leave it there, here is the string half modelled as something you
can run — UTF-8 bytes in a flat array, decoded per call, against a string that is simply already a
string:

```javascript run
// What a string costs when it has to cross out of WebAssembly's linear memory.
//
// This does NOT measure the real boundary — it models the one part you can reproduce
// in a plain runtime: WASM holds UTF-8 bytes, JS wants a UTF-16 string, so every
// string argument is decoded on the way through. Scala.js, compiling to JavaScript,
// hands over something that already IS a JS string.

const N = 200000;
const encoder = new TextEncoder();
const decoder = new TextDecoder("utf-8");

// The kind of strings DOM work actually passes.
const words = ["div", "span", "class", "data-source", "click", "reader-sidebar"];

// Pretend linear memory: those strings, already UTF-8, in one flat byte array.
const parts = words.map((w) => encoder.encode(w));
const total = parts.reduce((n, p) => n + p.length, 0);
const memory = new Uint8Array(total);
const spans = [];
let at = 0;
for (const p of parts) {
  memory.set(p, at);
  spans.push([at, p.length]);
  at += p.length;
}

// (a) Scala.js shape: it is already a JS string. Just use it.
let sink = 0;
let t0 = process.hrtime.bigint();
for (let i = 0; i < N; i++) {
  sink += words[i % words.length].length;
}
const native = Number(process.hrtime.bigint() - t0) / 1e6;

// (b) WASM shape: (ptr, len) into linear memory, decoded per call.
sink = 0;
t0 = process.hrtime.bigint();
for (let i = 0; i < N; i++) {
  const [ptr, len] = spans[i % spans.length];
  sink += decoder.decode(memory.subarray(ptr, ptr + len)).length;
}
const marshalled = Number(process.hrtime.bigint() - t0) / 1e6;

console.log(`${N} string arguments`);
console.log(`  already a JS string : ${native.toFixed(1)} ms`);
console.log(`  decoded from bytes  : ${marshalled.toFixed(1)} ms`);
console.log(`  per call            : ${(((marshalled - native) * 1e6) / N).toFixed(0)} ns extra`);
```

It reports somewhere around **90–110 ns per string argument** — the figure moves run to run, which is
itself worth noticing about microbenchmarks. Now put it next to the operation it rides along with: appending an element and letting the browser recalculate style and layout costs
**microseconds**. So the marshalling is real, measurable, and still an order of magnitude below the
thing it is attached to.

That is the shape of the whole trade-off. Not "WASM is slow at the DOM" — rather, a genuine per-call
tax on the cheap part of an expensive operation.

Two properties of this application shrink it further. Fine-grained reactivity means an update touches
only the nodes that actually changed — there is no VDOM diff issuing speculative writes. And the
genuinely DOM-heavy work (the editor, the diagram engines) lives in **TypeScript islands**, which
manipulate the DOM natively and never cross the boundary at all.

## Where WebAssembly wins instead

The boundary is a cost on DOM work. The compensation is that WASM is genuinely faster at *compute* —
and this client has real compute in it, which is easy to miss in a reader app.

The visualisation engine is **3,300 lines of pure logic that runs in the browser**, and the graph
family's layout is a force simulation — 320 iterations of an O(n²) float loop over flat `Vec<f64>`
arrays, every time a graph is drawn. Run it and watch the shape of the work:

```rust run
// The graph family's layout, reduced to its hot loop: 320 ticks of O(n²) many-body
// repulsion over flat f64 arrays. This is the shape of the work the visualisation
// engine does in your browser every time a graph is drawn.

use std::time::Instant;

const TICKS: u32 = 320;
const MANY_BODY: f64 = -520.0;
const VELOCITY_DECAY: f64 = 0.6;

fn layout(n: usize) -> (Vec<f64>, Vec<f64>) {
    // Start on a circle so the run is deterministic.
    let mut x: Vec<f64> = (0..n).map(|i| 10.0 * (i as f64).cos()).collect();
    let mut y: Vec<f64> = (0..n).map(|i| 10.0 * (i as f64).sin()).collect();
    let mut vx = vec![0.0_f64; n];
    let mut vy = vec![0.0_f64; n];

    for _tick in 0..TICKS {
        for i in 0..n {
            for j in 0..n {
                if i == j {
                    continue;
                }
                let dx = x[j] - x[i];
                let dy = y[j] - y[i];
                let mut l = dx * dx + dy * dy;
                if l == 0.0 {
                    l = 1e-6; // the real engine jiggles instead
                }
                let w = MANY_BODY / l;
                vx[i] += dx * w;
                vy[i] += dy * w;
            }
        }
        for i in 0..n {
            vx[i] *= VELOCITY_DECAY;
            vy[i] *= VELOCITY_DECAY;
            x[i] += vx[i];
            y[i] += vy[i];
        }
    }
    (x, y)
}

fn main() {
    println!("{:>5} {:>14} {:>12}", "nodes", "inner steps", "time");
    for n in [10_usize, 20, 40, 80] {
        let start = Instant::now();
        let (x, _y) = layout(n);
        println!(
            "{:>5} {:>14} {:>12?}   (x[0] = {:.3})",
            n,
            TICKS as usize * n * n,
            start.elapsed(),
            x[0]
        );
    }
    println!("\nDouble the nodes, quadruple the work — that is the O(n²) in the inner loop.");
}
```

Doubling the node count quadruples the inner steps and, near enough, the time — the quadratic term is
visible in the output rather than merely claimed. Ignore the first row: it absorbs process warm-up,
and on some runs `n = 10` reports *slower* than `n = 20`. That is a microbenchmark telling you the
truth about itself, and the reason the interesting comparison is between the last two rows. Change
`TICKS` or add a larger `n` to push it further.

That kernel is WebAssembly's home ground: no boxing, no GC pressure, arrays that *are* linear memory,
and codegen that does not depend on a JIT deciding to specialise. Scala.js optimises numeric code
well, but a tight `f64` loop is exactly where the gap favours WASM — and note the asymmetry with the
section above. The DOM boundary taxes the *cheap* part of an expensive operation; this is the
*expensive* part with no boundary in it at all.

So the client's workload is mixed, and the two halves point in opposite directions:

| Work | Favours | Why |
|---|---|---|
| DOM manipulation | Scala.js | no boundary; strings are already JS strings |
| Layout, adapt pipeline, diffing | WASM | flat float arrays, no GC, predictable codegen |
| Heavy DOM (editor, diagrams) | neither | it is TypeScript in both implementations |
| Playback while stepping | WASM | no GC pauses mid-animation |

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **All of the above is mechanism, not measurement.** The shape of the glue is checkable in this
repository, and the force loop is in the source — but I have not benchmarked Laminar against Leptos
on the same workload, and the Scala client is archived. Every claim here about which is *faster*
should be read as "the mechanism points this way", not "I measured it". Treating a plausible
mechanism as a result is the mistake this book is trying not to make.

</div>

## Rendering that puts prose first

One pipeline decision is worth surfacing because it changed how the page feels. Diagrams were
originally rendered while parsing the markdown — so the *entire page* waited for every diagram's
layout to finish before any prose appeared. A lesson with five diagrams stayed blank, then arrived at
once.

Now the parse emits a placeholder carrying the diagram source, and rendering happens at mount, near
the viewport:

```html
<div class="mermaid-block" data-source="classDiagram%0A%20%20class%20SubmitSolution…">
```

Prose paints immediately; each diagram renders independently and concurrently; a diagram far below
the fold does not render until the reader approaches it. The heavy engines load only if a page
actually has diagrams of that kind.

The trade is a brief empty card before a diagram fills in, which a reserved min-height keeps from
shifting the layout. Paying a small visible delay on one element to remove a total blocking delay on
everything is a good trade — and it is the same principle as the 202 in the submission path:
**do not make the common case wait for the expensive case.**

<details>
<summary>If TypeScript islands work well enough to keep, why compile the client to WebAssembly at all?</summary>

The honest answer is that the islands are where JavaScript is genuinely the right tool, and the
application shell is where it is not — and those are different kinds of code.

The islands are **mature, self-contained libraries** with stable interfaces: a markdown renderer, an
editor, a layout engine. Rewriting them would be months of work to reproduce behaviour that already
works, and the result would be worse for years. There is no principled argument for rewriting a
diagram layout engine, so they stayed.

The shell is the opposite: bespoke application logic — routing, catalog state, the executor machine,
the visualisation contract — that shares types with the server. Compiling it to WebAssembly means the
wire types are defined **once** in a shared crate and both ends are checked against the same
definition at compile time. A field rename that breaks the client is a build failure rather than a
runtime surprise. That, plus exhaustive matching on shared enums, is the actual prize.

The expected cost is download size, and this is where the honest answer diverges from the usual one.
Measured against the Scala.js implementation it replaced — same script, gzipped, critical path — the
WebAssembly client is **636 KiB against 624 KiB**: a 2% difference. The dominant term is the
application, not the language it compiles to. The 700 KiB budget is enforced in CI regardless,
because that number only moves in one direction if nobody watches it.

The costs that *are* structural are the DOM boundary and the string marshalling described above —
paid on UI work, where Scala.js paid nothing. Against them sits a real gain on compute: the
visualisation engine's force layout and adapt pipeline are the workload WebAssembly is good at.
Mixed bag, honestly, and unmeasured either way.

And the framing of the benefit deserves care: shared wire types were **not** a gain over the previous
implementation. Scala.js compiled from the same source tree as the JVM server and already had them.
What compiling this shell to WebAssembly buys is *keeping* that property once the server became Rust
— a Rust server and a Scala.js client cannot share a type between them.

So this is less "WebAssembly beat JavaScript" than "the client followed the server". Had the server
stayed on the JVM, the case for moving the client would have rested on the viz engine's compute
alone — a real argument, but not one that justifies rewriting a working client.

The reason to state it that way rather than claiming a clean win: **an argument you would not have
found persuasive beforehand should not become persuasive afterwards.** The compute advantage is
genuine and was not why the client moved. Both halves of that sentence matter.

</details>
