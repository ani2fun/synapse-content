---
title: "Animating a diagram"
summary: "Four ways to show a sequence in a lesson — a stepper, a player, a self-looping SVG, and a walkthrough — and the rules that stop an animation jumping under the reader."
---

# Animating a diagram

Some things a still picture is simply bad at. A cache filling. A leader dying and a new one being
elected. A window sliding. A DP table filling in. In every one of those the *change* is the
lesson, and a single frame can only show a moment.

Synapse can show all four of them, four different ways. This page draws **the same cache-aside read
path** with each transport in turn, so the difference is visible rather than described.

| Transport | Author writes | Reader gets | What it costs |
| --- | --- | --- | --- |
| **Stepper** | consecutive ` ```d2 ` fences | ‹ 3/5 › | the d2 engine, in the reader's browser |
| **Player** | a run of images, alt `— frame i of N` | ▶ ⏸ scrubber, arrow keys | a handful of URLs |
| **Auto-loop** | one `steps:` file, compiled with `--animate-interval` | plays by itself, forever | one file |
| **Walkthrough** | ` ```d2 boards ` with `layers:` | click to drill, ⌂ ☰, shareable | one sidecar directory |

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **A stepper's later slides are compiled in the reader's browser.** Content CI draws every
ordinary ` ```d2 ` fence ahead of time, but a slideshow ships its slides as *source* and only the
first one arrives drawn — so pressing › pulls the ~6 MB d2 engine and compiles the rest on the
spot. Fine for one three-frame build-up in the middle of a lesson; not fine for four six-frame
animations on one page.

That is why the [system-design](/synapse/synapse-features/d2-component-library/animated-system-design)
and [DSA](/synapse/synapse-features/d2-component-library/animated-dsa) animations are **players**
instead: the same frames, drawn once at authoring time, served as cached files. The stepper below
is here to show you the transport, and because it is the only one where what you copy off the page
is the source that drew it.

</div>

## The sources

An animation is a directory, not a file:

```bash
system-design/animated/cache-aside.anim/
  base.d2        # the whole diagram, dimmed — frame zero
  01-lookup.d2   # ...@./base  +  three lines
  02-miss.d2
  03-read.d2
  04-fill.d2
  05-hit.d2
```

`base.d2` holds every node, every edge and every label the sequence will ever show. Each frame
spreads it in and overrides three or four lines. That is the whole trick, and it is what makes the
next section possible.

## Transport 1 — the stepper

A run of **consecutive** ` ```d2 ` fences becomes one figure with a ‹ i/n › transport. The
`bash` block below is the authoring form — the base plus each frame's delta, as they sit on disk.
The five figures after it are what those files compile to.

```bash
# cache-aside.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · CACHE-ASIDE READ PATH ────────────────────────────────────
# animation-mode: highlight
# The whole diagram with nothing happening yet. Frame zero, and the file every frame
# spreads in with `...@./base`.
#
# FOUR RULES, and this file enforces all four. Break one and the animation stops being
# watchable, because the picture jumps between frames instead of changing.
#
#   1. DECLARE EVERYTHING HERE — every node, every edge, every label the sequence will
#      ever show. A frame that adds a node makes ELK re-run and the layout move.
#   2. FRAMES RECOLOUR, THEY DO NOT RELABEL. An edge label is measured by the layout
#      engine; changing one moves everything around it.
#   3. PIN THE TITLE'S WIDTH. The per-frame caption is the one thing that does differ,
#      and a `near: top-center` text shape widens the whole diagram to fit itself. With
#      `width` pinned, a long caption and a short one produce the same bounding box.
#   4. KEEP THE EDGE COUNT DOWN. Every edge is drawn in every frame, so seven of them is
#      a spaghetti diagram N times over. Three carry this whole sequence.
#
# The dim edges are already `stroke-width: 2`, the weight `step` uses, so lighting one up
# changes its colour and not its geometry.
#
# Knobs: the boxes, and how many steps you split the sequence into.

...@../../../lib/theme

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

# ── 01-lookup.d2 ─────────────────────────────────
# Frame 1 — the application asks the cache FIRST. The cache never talks to the database
# and knows nothing about it; that is what "aside" means.
...@./base
title: "1 · ask the cache first"
app.class: [svc; current]
cache.class: [data; current]
(app -> cache)[0].class: step

# ── 02-miss.d2 ─────────────────────────────────
# Frame 2 — a miss. Every interesting question about this pattern lives in the frames
# after this one, never in the hit path.
...@./base
title: "2 · MISS — the key is not there"
app.class: [svc; current]
cache.class: [data; cold]
(cache -> app)[0].class: step

# ── 03-read.d2 ─────────────────────────────────
# Frame 3 — the APPLICATION goes to the database, not the cache. Nothing here is
# read-through, which is why the application is the only box that knows both stores.
...@./base
title: "3 · read through to the store"
app.class: [svc; current]
cache.class: [data; cold]
db.class: [data; current]
(app <-> db)[0].class: step

# ── 04-fill.d2 ─────────────────────────────────
# Frame 4 — the fill. The TTL set here IS the consistency story: until it expires, a
# write that lands in the database is invisible to this cache.
...@./base
title: "4 · fill the cache · the TTL starts now"
app.class: [svc; current]
cache.class: [data; hot]
(app -> cache)[0].class: step

# ── 05-hit.d2 ─────────────────────────────────
# Frame 5 — the next reader of user:42 stops here, and the database stays untouched for
# five minutes or until someone invalidates the key.
...@./base
title: "5 · the next read is a HIT — the store is never touched"
app.class: [svc; active]
cache.class: [data; hot]
(app -> cache)[0].class: hint
(cache -> app)[0].class: step
```

```d2
classes: {
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  dim:     { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-color: "#94a3b8" } }   # this frame is not about it
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

title: "1 · ask the cache first"
app.class: [svc; current]
cache.class: [data; current]
(app -> cache)[0].class: step
```

```d2
classes: {
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  dim:     { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-color: "#94a3b8" } }   # this frame is not about it
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

title: "2 · MISS — the key is not there"
app.class: [svc; current]
cache.class: [data; cold]
(cache -> app)[0].class: step
```

```d2
classes: {
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  dim:     { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-color: "#94a3b8" } }   # this frame is not about it
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

title: "3 · read through to the store"
app.class: [svc; current]
cache.class: [data; cold]
db.class: [data; current]
(app <-> db)[0].class: step
```

```d2
classes: {
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  dim:     { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-color: "#94a3b8" } }   # this frame is not about it
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

title: "4 · fill the cache · the TTL starts now"
app.class: [svc; current]
cache.class: [data; hot]
(app -> cache)[0].class: step
```

```d2
classes: {
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  dim:     { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-color: "#94a3b8" } }   # this frame is not about it
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

# TODO: pin this to a little more than your widest frame. Too narrow and long captions
# wrap; too wide and every frame carries dead margin.
title: "cache-aside · the read path" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }

app: "Application\nowns the cache logic" { class: [svc; dim] }
cache: "Cache · TTL 5m\nkey: user:42" { class: [data; dim] }
db: "Database" { class: [data; dim]; shape: cylinder }

# The labels name every step up front — `1. GET · 4. SET` is one arrow doing two jobs at
# two different moments, and saying so is what lets the frames leave it alone.
app -> cache: "1. GET user:42   ·   4. SET user:42 EX 300" { class: dim; style.stroke-width: 2 }
cache -> app: "2. HIT / MISS" { class: dim; style.stroke-width: 2 }
app <-> db: "3. SELECT … WHERE id=42  →  row" { class: dim; style.stroke-width: 2 }

title: "5 · the next read is a HIT — the store is never touched"
app.class: [svc; active]
cache.class: [data; hot]
(app -> cache)[0].class: hint
(cache -> app)[0].class: step
```

Step through it. The boxes never move; only the colour does, and the caption above changes to name
the step. That stillness is engineered, and the next section is how.

Consecutive is load-bearing. A ` ```bash ` fence between two ` ```d2 ` fences splits the run into
two separate figures — which is exactly how every other page in this chapter shows one diagram at
a time.

## The four rules

An animation that jumps is worse than four separate pictures, because the reader's eye tracks the
jump instead of the change. Four rules, all enforced in `base.d2`:

**1. Declare everything in the base.** Every node, every edge, every label. A frame that adds a
node makes ELK re-run the layout, and the picture moves.

**2. Frames recolour; they do not relabel.** An edge label is measured by the layout engine, so
changing one moves everything around it. Anything that differs per step goes in the title.

**3. Pin the title's width.** A `near: top-center` text shape widens the whole diagram to fit
itself, so a long caption and a short one produce different bounding boxes. With `width` pinned,
they produce the same one:

```bash
title: "…" { near: top-center; shape: text; width: 900; style: { font-size: 20; bold: true } }
```

**4. Keep the edge count down.** Every edge is drawn in every frame, so seven of them is a
spaghetti diagram five times over. Three edges carry the whole cache-aside sequence, because a
label can name two steps at once — `1. GET · 4. SET` is one arrow doing two jobs at two moments.

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Same form in, same form out.** D2 will not override a scalar `class: cell` with a list, and it
says nothing when it declines — the frame renders, uncoloured. Overriding it with a bare
`class: active` *does* apply, and drops `cell` along with its pinned width. So anything a frame
will recolour is declared two-class from the start:

```bash
v0: 2 { class: [cell; idle] }     # in the base
strip.v0.class: [cell; active]    # in the frame
```

`idle` exists for exactly this: it looks like an unstyled cell, and what it buys is the slot.

</div>

**The exception to rule 2:** inside a **grid**, a cell's width is pinned, so a frame can safely
write a number into one — a column cannot resize. That is what makes the
[DP table](/synapse/synapse-features/d2-component-library/animated-dsa) animation possible.

### The gate

Layout stability is the one property nothing else would catch, so it has its own check:

```bash
./render.sh stable
```

It renders every frame, reads the `viewBox` off each SVG, and fails a highlight-mode animation
whose frames differ by more than 2%. A little drift is real — a heavier stroke on a highlighted
node genuinely moves the bounding box by a pixel — and failing on that would be noise.

```bash
  ✓  dsa/binary-search.anim                     942x223–942x223  drift 0.0%
  ✓  system-design/animated/cache-aside.anim    942x308–942x309  drift 0.3%
  ·  system-design/animated/scaling-story.anim  build — exempt
```

Every `base.d2` declares which mode it is in, on its second line:

```bash
# animation-mode: highlight
```

## Two modes

**Highlight mode** freezes the layout and moves colour through it. Everything above is highlight
mode, and it is right whenever the subject is a *sequence of events*.

**Build mode** lets the diagram grow: each frame adds boxes, and the layout deliberately jumps.
Reach for it when the subject is a system *evolving* — the growth is the story. Its frames chain
their imports rather than all pointing at the base:

```bash
02-scale-out.d2   ...@./01-split
03-cache.d2       ...@./02-scale-out
04-replicas.d2    ...@./03-cache
```

Each file holds only what its step added, and each still compiles alone. Build mode is exempt from
the stability gate, and it comes with one limitation: a chain can **add**, never remove. When a
step retires something — users stop talking to the app directly once a load balancer arrives —
blank the edge's label and set its opacity to zero *through its index*:

```bash
(users -> app)[0].label: ""
(users -> app)[0].style.opacity: 0
```

Writing `users -> app: ""` instead would declare a **second** connection and leave the first one
drawn. There is a [worked build-mode animation](/synapse/synapse-features/d2-component-library/animated-system-design)
in the next lesson.

## Transport 2 — the player

The same five frames, rendered to files and referenced as images. A run of consecutive images
whose alt text ends `— frame i of N` collapses into one figure with a **play button**, a scrubber
and the arrow keys.

// Interactive Diagram (5 frames): Cache-aside, one step at a time

![Cache-aside, one step at a time — frame 1 of 5](/media/synapse-features/animating-a-diagram/cache-aside/frame-1.svg)

![Cache-aside, one step at a time — frame 2 of 5](/media/synapse-features/animating-a-diagram/cache-aside/frame-2.svg)

![Cache-aside, one step at a time — frame 3 of 5](/media/synapse-features/animating-a-diagram/cache-aside/frame-3.svg)

![Cache-aside, one step at a time — frame 4 of 5](/media/synapse-features/animating-a-diagram/cache-aside/frame-4.svg)

![Cache-aside, one step at a time — frame 5 of 5](/media/synapse-features/animating-a-diagram/cache-aside/frame-5.svg)

Press play. Same frames, same files, better transport — and because the frames are URLs rather
than inlined source, a fifteen-frame animation costs the page about as much as a link.

What it costs instead is the copy-and-paste property: the reader can no longer lift the source off
the page, and the SVGs have to be committed. `./render.sh media` draws them:

```bash
./render.sh media
#   ../../_media/synapse-features/animating-a-diagram/cache-aside/frame-1..5.svg
```

Use the player as the default for anything longer than a few frames. It is the only transport
that stays cheap as the animation grows: fifteen frames cost fifteen URLs, and the browser caches
them. `./render.sh media` draws every animation in the library in one pass, reading the
destination and the caption out of each `base.d2`:

```bash
# animation-mode: highlight
# lesson: animated-dsa
# caption: A sliding window growing and shrinking
```

The caption has to be byte-identical in the marker line and in every alt, because the alt text is
the *only* thing that groups a run into one figure — which is why both are generated from that
header rather than typed.

## Transport 3 — the auto-loop

D2 can package several boards into **one** SVG that transitions between them on a timer. The
result is a single file carrying CSS keyframes: it plays by itself, with no JavaScript, no
controls, and no way to stop it.

// Diagram: The same read path as one self-animating SVG — no controls, no JavaScript

![Cache-aside as a single self-animating SVG](/media/synapse-features/animating-a-diagram/cache-aside-loop.svg)

The source is `steps:` rather than a directory of frames, which makes it the most compact of the
four — D2 steps inherit from the previous step, so each one says only what changed:

```bash
steps: {
  lookup: { title: "1 · ask the cache first"; app.class: [svc; current] }
  miss:   { title: "2 · MISS — the key is not there"; cache.class: [data; cold] }
  read:   { title: "3 · read through to the store"; db.class: [data; current] }
}
```

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **This is not a fence.** The app's renderer never passes `animateInterval`, so a `steps:` source
inside a ` ```d2 ` fence draws its root board and nothing else — silently. An auto-loop reaches a
reader only as a committed file under `_media/`. Compile it yourself:

```bash
d2 --layout elk --pad 20 --target '*' --animate-interval 1600 cache-aside-loop.d2 out.svg
```

</div>

Nobody can pause it, so keep it short and keep the interval slow — 1600ms reads comfortably, and
below about 1000ms nobody can follow it. Use it for a short loop that plays while the reader reads
the prose beside it, never for anything they need to study.

## Transport 4 — the walkthrough

The one transport that is not a sequence. D2 `layers:` compiles to a **tree** of boards, and a node
carrying `link:` is a door into one of them — overview, then the edge, then the services, then the
data layer.

```d2 boards name="drilldown" root="Overview"
classes: {
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

user: "Reader" { class: client; shape: person }

# TODO: one door per layer. A node with no `link:` is just a box.
edge: "Edge\nCDN · LB · gateway" { class: edge; link: layers.edge }
svc: "Services" { class: svc; link: layers.services }
store: "Data" { class: data; shape: cylinder; link: layers.data }

user -> edge: "HTTPS"
edge -> svc
svc -> store

layers: {
  edge: {
    direction: right
    dns: "DNS\nTTL 60s" { class: edge }
    cdn: "CDN\ncacheable GETs" { class: edge }
    lb: "Load balancer\nTLS terminates here" { class: edge }
    gw: "API gateway\nauthn · quotas" { class: edge }
    # `_` steps up one board: without it this reads as `edge`'s own `services` layer.
    onward: "→ Services" { class: svc; link: _.layers.services }

    dns -> cdn -> lb -> gw -> onward
  }

  services: {
    direction: right
    api: "Public API" { class: svc }
    worker: "Workers" { class: [async; svc] }
    queue: "Queue" { class: async; shape: queue }
    onward: "→ Data" { class: data; shape: cylinder; link: _.layers.data }

    api -> queue -> worker
    api -> onward: "reads"
    worker -> onward: "writes"
  }

  data: {
    direction: right
    cache: "Cache" { class: [data; hot] }
    primary: "Primary" { class: data; shape: cylinder }
    replica: "Replicas ×2" { class: data; shape: cylinder }
    blob: "Object storage" { class: data; shape: stored_data }

    cache -> primary: "on miss" { class: hint }
    primary -> replica: "async" { class: hint }
    primary -> blob: "archive" { class: hint }
  }
}
```

Click a box. ‹ › walk back and forward, ⌂ returns to the top, ☰ jumps to any board, and the board
you are on is written into the page address so you can send someone the level you meant.

The `boards` marker on the fence is required — without it the fence draws the root board only and
every link is dead. The full contract, including the one rule that trips everyone, is in
[D2 walkthroughs](/synapse/synapse-features/reading-a-lesson/d2-walkthroughs).

## Choosing one

- **One short build-up, mid-lesson, that the reader should be able to copy.** Stepper — and
  budget for the engine download the first time they press ›.
- **Anything longer, more than one on a page, or worth watching end to end.** Player. Put the
  source in a ` ```bash ` fence beside it and the reader can still copy it.
- **A short loop that plays beside the prose.** Auto-loop.
- **A structure with levels rather than steps.** Walkthrough.
- **A single change, before and after.** None of them — use the
  [two-panel transition](/synapse/synapse-features/d2-component-library/using-the-library). One
  figure, both states, no controls to operate.

## Next

- [Animated system design](/synapse/synapse-features/d2-component-library/animated-system-design) — failover, growth, and a deploy that rolls back.
- [Animated DSA](/synapse/synapse-features/d2-component-library/animated-dsa) — a sliding window, a binary search, a BFS frontier, and a DP table filling in.
