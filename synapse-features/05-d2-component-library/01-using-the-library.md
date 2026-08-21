---
title: "Using the component library"
summary: "Copy-and-adapt D2 templates for DSA and system design — the theme, the state classes, the two-panel transition, and the four layout rules that decide whether a figure lands."
---

# Using the component library

The [snippets lesson](/synapse/synapse-features/reading-a-lesson/d2-diagrams-snippets) teaches the D2 language one keyword at a time. This
chapter is the other half: **finished figures to start from**. An array strip with its indices, a
sliding window mid-shrink, a cache-aside read path — drawn, tuned, and ready to be edited into
whatever you actually need.

Nothing here is a screenshot. Every figure is drawn from the `d2` fence printed above it, and every
fence is generated from a real file on disk.

## Where the sources live

```bash
synapse-features/_d2-blocks/
  lib/theme.d2        # every colour and size, in one place
  lib/icons.d2        # verified icon URLs for the system-design blocks
  demo/               # the three figures on this page
  dsa/                # data structures and algorithms
  system-design/      # primitives, native shapes, boundaries, patterns
  render.sh           # the gate: compile everything, twice, two engines
  README.md           # the index — every block, with a preview
```

The directory starts with `_`, which keeps the content walker out of it. Without the underscore its
`README.md` would render as a lesson of its own.

## Two vocabularies

Every block is written in two kinds of class. **Structure** says what a thing is — `cell`, `idx`,
`node`, `panel`. **State** says what is happening to it. Layer them with the list form and
recolouring becomes a one-word edit:

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

sw: "layer a state over a structure:  { class: [cell; current] }" { class: panel
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0

  s0: "—" { class: cell }
  s1: "" { class: [cell; active] }
  s2: "" { class: [cell; current] }
  s3: "" { class: [cell; visited] }
  s4: "" { class: [cell; pruned] }
  s5: "" { class: [cell; hot] }
  s6: "" { class: [cell; cold] }

  n0: "(none)" { class: idx }
  n1: active   { class: idx }
  n2: current  { class: idx }
  n3: visited  { class: idx }
  n4: pruned   { class: idx }
  n5: hot      { class: idx }
  n6: cold     { class: idx }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

sw: "layer a state over a structure:  { class: [cell; current] }" { class: panel
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0

  s0: "—" { class: cell }
  s1: "" { class: [cell; active] }
  s2: "" { class: [cell; current] }
  s3: "" { class: [cell; visited] }
  s4: "" { class: [cell; pruned] }
  s5: "" { class: [cell; hot] }
  s6: "" { class: [cell; cold] }

  n0: "(none)" { class: idx }
  n1: active   { class: idx }
  n2: current  { class: idx }
  n3: visited  { class: idx }
  n4: pruned   { class: idx }
  n5: hot      { class: idx }
  n6: cold     { class: idx }
}
```

Six states, and they are enough for everything in this chapter. `active` is in play, `current` is
being touched right now, `visited` is done with, `pruned` was cut off, `hot` and `cold` are frequent
and rare. If you find yourself reaching for a seventh, check whether one of these already means it —
a consistent palette is worth more than a precise one.

## The transition

This is the block to learn. Two panels — the state before a step and the state after it — joined by
an arrow that names the step:

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · writing index 3" { class: panel
  grid-rows: 2
  grid-columns: 6
  grid-gap: 0

  v0: 2 { class: [cell; visited] }
  v1: 7 { class: [cell; visited] }
  v2: 9 { class: [cell; visited] }
  # TODO: the cell about to change.
  v3: "·" { class: [cell; current] }
  v4: "·" { class: cell }
  v5: "·" { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
}

after: "after · index 3 written" { class: panel
  grid-rows: 2
  grid-columns: 6
  grid-gap: 0

  v0: 2 { class: [cell; visited] }
  v1: 7 { class: [cell; visited] }
  v2: 9 { class: [cell; visited] }
  v3: 4 { class: [cell; visited] }
  # TODO: and the one that becomes current next.
  v4: "·" { class: [cell; current] }
  v5: "·" { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
}

# Keep this label SHORT. ELK routes the edge straight through its text, so a long one
# ends up struck through by its own arrow. Two or three words, or a `\n` break.
before -> after: "write 4\nadvance" { class: step }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · writing index 3" { class: panel
  grid-rows: 2
  grid-columns: 6
  grid-gap: 0

  v0: 2 { class: [cell; visited] }
  v1: 7 { class: [cell; visited] }
  v2: 9 { class: [cell; visited] }
  # TODO: the cell about to change.
  v3: "·" { class: [cell; current] }
  v4: "·" { class: cell }
  v5: "·" { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
}

after: "after · index 3 written" { class: panel
  grid-rows: 2
  grid-columns: 6
  grid-gap: 0

  v0: 2 { class: [cell; visited] }
  v1: 7 { class: [cell; visited] }
  v2: 9 { class: [cell; visited] }
  v3: 4 { class: [cell; visited] }
  # TODO: and the one that becomes current next.
  v4: "·" { class: [cell; current] }
  v5: "·" { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
}

# Keep this label SHORT. ELK routes the edge straight through its text, so a long one
# ends up struck through by its own arrow. Two or three words, or a `\n` break.
before -> after: "write 4\nadvance" { class: step }
```

A single picture cannot show a change. Two can, and the arrow between them is where the *reason*
goes. Nearly every `-step` file in this library is that skeleton with different cells inside:

```bash
direction: right
before: "before · <state>" { class: panel   <the figure> }
after:  "after · <state>"  { class: panel   <the figure> }
before -> after: "<the step>" { class: step }
```

Put the invariant in the panel titles — a running sum, a candidate count, a bound. The titles are
what turn two pictures into an argument.

## Copying one

The fence above is **not** byte-for-byte what is in `dsa/array-strip-step.d2`. The file starts with

```bash
...@../lib/theme
```

and a `d2` fence has no filesystem, so that import would resolve to nothing. `./render.sh fence`
inlines the classes a block actually uses and prints the pair you see above:

```bash
./render.sh fence dsa/array-strip-step.d2
```

Copy either the fence off this page or the file off disk — the file if you want the theme, the fence
if you want something self-contained.

## Four rules that decide whether a figure lands

**Set `grid-rows` *and* `grid-columns`.** Not one of them. With only `grid-columns`, D2 fills
column-major and re-flows the cells to fit, overriding the widths and heights you set:

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
}

direction: down

wrong: "✗ grid-columns: 4 only" { class: panel
  grid-columns: 4
  grid-gap: 0
  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: cell }
  v3: 4 { class: cell }
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
}

right: "✓ grid-rows: 2 AND grid-columns: 4" { class: panel
  grid-rows: 2
  grid-columns: 4
  grid-gap: 0
  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: cell }
  v3: 4 { class: cell }
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
}

direction: down

wrong: "✗ grid-columns: 4 only" { class: panel
  grid-columns: 4
  grid-gap: 0
  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: cell }
  v3: 4 { class: cell }
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
}

right: "✓ grid-rows: 2 AND grid-columns: 4" { class: panel
  grid-rows: 2
  grid-columns: 4
  grid-gap: 0
  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: cell }
  v3: 4 { class: cell }
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
}
```

That is the same eight cells in both panels. `grid-gap: 0` is the other half — it is what makes cells
read as one continuous strip instead of eight boxes.

**Connections do not route into a grid.** You cannot draw an arrow to cell 3. Use a spacer row
instead: one invisible cell per column, and the caption goes in the column you mean.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

t: "pointing at column 2" { class: panel
  grid-rows: 3
  grid-columns: 5
  grid-gap: 0

  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: [cell; current] }
  v3: 4 { class: cell }
  v4: 1 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }

  # TODO: move the caption to whichever column you mean.
  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ here" { class: tick; style.font-color: "#ca8a04" }
  p3 { class: ghost }
  p4 { class: ghost }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

t: "pointing at column 2" { class: panel
  grid-rows: 3
  grid-columns: 5
  grid-gap: 0

  v0: 2 { class: cell }
  v1: 7 { class: cell }
  v2: 9 { class: [cell; current] }
  v3: 4 { class: cell }
  v4: 1 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }

  # TODO: move the caption to whichever column you mean.
  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ here" { class: tick; style.font-color: "#ca8a04" }
  p3 { class: ghost }
  p4 { class: ghost }
}
```

`ghost` is blank padding; `tick` is the one that shows its label. Both are transparent and both pin
their width to the cell width, so a long caption overhangs rather than knocking the columns out of
line.

**A nested container ignores `direction`.** Set `direction: down` inside a panel and ELK will ignore
it — every container lays out in the **root's** direction. So a two-panel figure holding trees needs
`direction: down` at the root, and its panels stack vertically. That is why
`dsa/bst-step.d2` is the one transition in this chapter drawn top-to-bottom.

**Siblings with no edge between them lay out *perpendicular* to the direction.** `direction: right`
stacks two unconnected panels; `direction: down` puts them in a row. Connect them with an edge and
they line up along the direction instead. Counterintuitive, but consistent — and it is the knob to
reach for when two panels land the wrong way round.

## The gate

```bash
./render.sh all
```

Four things, in order: every icon URL answers 200, every `lib/` file parses, every block compiles
**and** its flattened form compiles, and every fence in these lessons compiles again under the WASM
d2 the app actually ships.

That last one is not paranoia. The app pins d2 v0.7.0 and renders with **ELK** at `pad: 20`; your CLI
is probably v0.8.1 and defaults to dagre at `pad: 100`. Gate with the defaults and you are eyeballing
a picture no reader ever sees. `./render.sh sheet` puts a whole directory on one page so a collapsed
cell has nowhere to hide.

## Where next

| | |
| --- | --- |
| [Arrays, windows and pointers](/synapse/synapse-features/d2-component-library/dsa-arrays-and-windows) | the strip, sliding windows, pointer pairs, prefix and difference arrays |
| [Stacks, lists and hashing](/synapse/synapse-features/d2-component-library/dsa-stacks-lists-hashing) | stacks, queues, deques, ring buffers, linked lists, hash tables, intervals |
| [Trees, heaps and range structures](/synapse/synapse-features/d2-component-library/dsa-trees-and-heaps) | binary trees, BSTs, heaps, tries, segment and Fenwick trees |
| [Graphs and traversal](/synapse/synapse-features/d2-component-library/dsa-graphs) | three representations, BFS, DFS, topological order, union-find |
| [DP and divide-and-conquer](/synapse/synapse-features/d2-component-library/dsa-dp-and-divide) | DP tables, recursion trees, binary search, partition, merge, grids |
