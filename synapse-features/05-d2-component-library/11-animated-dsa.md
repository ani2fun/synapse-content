---
title: "Animated DSA"
summary: "Four algorithms as sequences — a sliding window, a binary search halving its range, a BFS frontier, and a DP table filling one cell at a time."
---

# Animated DSA

The [DSA blocks](/synapse/synapse-features/d2-component-library/dsa-arrays-and-windows) draw states,
and the two-panel transition draws one change. These draw the whole run — press ▶ on any of them,
or step a frame at a time.

All four are grid-based, which makes them the easy case: a grid cell has a pinned width, so the
strip cannot shift and a frame can safely write a value into a cell. The rules and the gate are in
[Animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram).

## Sliding window

The window grows on the right and shrinks on the left, and neither pointer ever moves backwards.
Six frames over `[2, 1, 5, 1, 3, 2]`, finding the longest subarray with sum ≤ 8.

```bash
# sliding-window.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · SLIDING WINDOW ───────────────────────────────────────────
# animation-mode: highlight
# lesson: animated-dsa
# caption: A sliding window growing and shrinking
# The canonical animated DSA figure: a window that grows on the right and shrinks on the
# left, over a fixed strip. Problem: the longest subarray with sum ≤ 8.
#
# A GRID makes this the easy case. Every cell has a pinned width, so unlike a free layout
# a frame can safely change a cell's LABEL — the column cannot resize, the strip cannot
# shift. That is why the pointer row works: `L` and `R` move by relabelling ticks, and
# nothing else on the page notices.
#
# Three rows, all six columns wide:
#   values    the array. Frames recolour these — `active` inside the window. Declared
#             `[cell; idle]`, never `cell`: d2 refuses to override a scalar `class:` with a
#             list, and a bare `class: active` override would drop `cell` and its pinned
#             width. Same form in, same form out.
#   index     never changes.
#   pointers  `·` by default; a frame writes L and R into two of them.
#
# Knobs: the values, the constraint in the title, and the number of frames.

...@../../lib/theme

title: "sliding window · longest subarray with sum ≤ 8" { near: top-center; shape: text; width: 620; style: { font-size: 19; bold: true } }

strip: "" { class: board
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 2 { class: [cell; idle] }
  v1: 1 { class: [cell; idle] }
  v2: 5 { class: [cell; idle] }
  v3: 1 { class: [cell; idle] }
  v4: 3 { class: [cell; idle] }
  v5: 2 { class: [cell; idle] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  # The pointer row. `·` is a placeholder that reserves the row's height, so a frame that
  # writes L or R into a tick changes a glyph and nothing else.
  p0: "·" { class: tick }
  p1: "·" { class: tick }
  p2: "·" { class: tick }
  p3: "·" { class: tick }
  p4: "·" { class: tick }
  p5: "·" { class: tick }
}

# ── 01-open.d2 ─────────────────────────────────
# Frame 1 — one element. The window is [0,0], the sum is 2, and there is nothing to do
# but grow it.
...@./base
title: "1 · window [0,0] · sum 2 ≤ 8 · grow right"
strip.v0.class: [cell; active]
strip.p0: "L R"

# ── 02-grow.d2 ─────────────────────────────────
# Frame 2 — still under the limit, so R keeps moving. A sliding window only ever shrinks
# when it has to.
...@./base
title: "2 · window [0,2] · sum 8 ≤ 8 · length 3, the best so far"
strip.v0.class: [cell; active]
strip.v1.class: [cell; active]
strip.v2.class: [cell; active]
strip.p0: "L"
strip.p2: "R"

# ── 03-violate.d2 ─────────────────────────────────
# Frame 3 — R took one step too many. This frame is the whole reason the technique
# exists: the window is invalid, and the fix is local.
...@./base
title: "3 · window [0,3] · sum 9 > 8 — invalid, shrink from the LEFT"
strip.v0.class: [cell; pruned]
strip.v1.class: [cell; active]
strip.v2.class: [cell; active]
strip.v3.class: [cell; active]
strip.p0: "L"
strip.p3: "R"

# ── 04-shrink.d2 ─────────────────────────────────
# Frame 4 — dropping index 0 makes it legal again. Note what did NOT happen: nothing was
# recomputed from scratch. Each element enters once and leaves once, which is the O(n).
...@./base
title: "4 · L moves to 1 · sum 7 ≤ 8 · valid again, length 3"
strip.v0.class: [cell; visited]
strip.v1.class: [cell; active]
strip.v2.class: [cell; active]
strip.v3.class: [cell; active]
strip.p1: "L"
strip.p3: "R"

# ── 05-again.d2 ─────────────────────────────────
# Frame 5 — grow, break the constraint, shrink again. The loop is always these two moves.
...@./base
title: "5 · window [1,4] · sum 10 > 8 — shrink again"
strip.v0.class: [cell; visited]
strip.v1.class: [cell; pruned]
strip.v2.class: [cell; active]
strip.v3.class: [cell; active]
strip.v4.class: [cell; active]
strip.p1: "L"
strip.p4: "R"

# ── 06-answer.d2 ─────────────────────────────────
# Frame 6 — the answer. Both pointers only ever moved right, so the whole scan is one
# pass: O(n) time, O(1) space.
...@./base
title: "6 · best = 3 · both pointers only moved right — O(n), one pass"
strip.v0.class: [cell; visited]
strip.v1.class: [cell; visited]
strip.v2.class: [cell; visited]
strip.v3.class: [cell; active]
strip.v4.class: [cell; active]
strip.v5.class: [cell; active]
strip.p3: "L"
strip.p5: "R"
```

// Interactive Diagram (6 frames): A sliding window growing and shrinking

![A sliding window growing and shrinking — frame 1 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-1.svg)

![A sliding window growing and shrinking — frame 2 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-2.svg)

![A sliding window growing and shrinking — frame 3 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-3.svg)

![A sliding window growing and shrinking — frame 4 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-4.svg)

![A sliding window growing and shrinking — frame 5 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-5.svg)

![A sliding window growing and shrinking — frame 6 of 6](/media/synapse-features/animated-dsa/sliding-window/frame-6.svg)

Frame 3 is the one that matters: the window is invalid, and the fix is *local* — drop from the
left, do not start again. Because both pointers only ever move right, each element enters the
window once and leaves once, and the whole scan is one pass. That is the O(n), and it is visible in
the pointer row rather than asserted in prose.

The `L` and `R` markers move by relabelling ticks. That works here only because the ticks sit in a
grid with a pinned column width — in a free layout the same edit would resize a column and shift
the strip.

## Binary search

Five frames, nine elements, target 23. What a still picture shows is one comparison; the idea is
what happens to the *other half*, and only a sequence shows that.

```bash
# binary-search.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · BINARY SEARCH ────────────────────────────────────────────
# animation-mode: highlight
# lesson: animated-dsa
# caption: Binary search halving its range
# The search space halving, frame by frame. A static picture of binary search shows one
# comparison; the whole idea is what happens to the OTHER half, and only a sequence shows
# that.
#
# Sorted array, target 23. Three rows, nine columns:
#   values    `active` while still in range, `pruned` once discarded, `current` at mid
#   index     never changes
#   pointers  lo / mid / hi, written into the ticks
#
# Every value cell is declared `[cell; idle]` rather than `cell`, because a frame can only
# override a class list with another class list. See lib/theme.d2.
#
# Knobs: the values, the target in the title, and how many halvings you show.

...@../../lib/theme

title: "binary search · target 23" { near: top-center; shape: text; width: 900; style: { font-size: 19; bold: true } }

strip: "" { class: board
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  v0: 3 { class: [cell; idle] }
  v1: 7 { class: [cell; idle] }
  v2: 11 { class: [cell; idle] }
  v3: 15 { class: [cell; idle] }
  v4: 19 { class: [cell; idle] }
  v5: 23 { class: [cell; idle] }
  v6: 27 { class: [cell; idle] }
  v7: 31 { class: [cell; idle] }
  v8: 35 { class: [cell; idle] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0: "·" { class: tick }
  p1: "·" { class: tick }
  p2: "·" { class: tick }
  p3: "·" { class: tick }
  p4: "·" { class: tick }
  p5: "·" { class: tick }
  p6: "·" { class: tick }
  p7: "·" { class: tick }
  p8: "·" { class: tick }
}

# ── 01-whole.d2 ─────────────────────────────────
# Frame 1 — the whole array is in range. mid = (0 + 8) / 2 = 4.
...@./base
title: "1 · lo=0 hi=8 · mid=4 → 19"
strip.v0.class: [cell; active]
strip.v1.class: [cell; active]
strip.v2.class: [cell; active]
strip.v3.class: [cell; active]
strip.v4.class: [cell; current]
strip.v5.class: [cell; active]
strip.v6.class: [cell; active]
strip.v7.class: [cell; active]
strip.v8.class: [cell; active]
strip.p0: "lo"
strip.p4: "mid"
strip.p8: "hi"

# ── 02-drop-left.d2 ─────────────────────────────────
# Frame 2 — 19 < 23, so the target cannot be at index 4 or below. Five cells are gone in
# one comparison, and this is the only frame where that is worth saying out loud.
...@./base
title: "2 · 19 < 23 → the whole left half is impossible"
strip.v0.class: [cell; pruned]
strip.v1.class: [cell; pruned]
strip.v2.class: [cell; pruned]
strip.v3.class: [cell; pruned]
strip.v4.class: [cell; pruned]
strip.v5.class: [cell; active]
strip.v6.class: [cell; active]
strip.v7.class: [cell; active]
strip.v8.class: [cell; active]
strip.p5: "lo"
strip.p8: "hi"

# ── 03-halve.d2 ─────────────────────────────────
# Frame 3 — four candidates left. mid = (5 + 8) / 2 = 6.
...@./base
title: "3 · lo=5 hi=8 · mid=6 → 27"
strip.v0.class: [cell; pruned]
strip.v1.class: [cell; pruned]
strip.v2.class: [cell; pruned]
strip.v3.class: [cell; pruned]
strip.v4.class: [cell; pruned]
strip.v5.class: [cell; active]
strip.v6.class: [cell; current]
strip.v7.class: [cell; active]
strip.v8.class: [cell; active]
strip.p5: "lo"
strip.p6: "mid"
strip.p8: "hi"

# ── 04-drop-right.d2 ─────────────────────────────────
# Frame 4 — 27 > 23, so everything from index 6 up is impossible. One candidate remains.
...@./base
title: "4 · 27 > 23 → the right half goes too · one candidate left"
strip.v0.class: [cell; pruned]
strip.v1.class: [cell; pruned]
strip.v2.class: [cell; pruned]
strip.v3.class: [cell; pruned]
strip.v4.class: [cell; pruned]
strip.v5.class: [cell; active]
strip.v6.class: [cell; pruned]
strip.v7.class: [cell; pruned]
strip.v8.class: [cell; pruned]
strip.p5: "lo hi"

# ── 05-found.d2 ─────────────────────────────────
# Frame 5 — found, in three comparisons over nine elements. log₂(9) ≈ 3.2, and that is
# not a coincidence: each frame halved what was left.
...@./base
title: "5 · found at index 5 · three comparisons, nine elements — log₂ n"
strip.v0.class: [cell; pruned]
strip.v1.class: [cell; pruned]
strip.v2.class: [cell; pruned]
strip.v3.class: [cell; pruned]
strip.v4.class: [cell; pruned]
strip.v5.class: [cell; current]
strip.v6.class: [cell; pruned]
strip.v7.class: [cell; pruned]
strip.v8.class: [cell; pruned]
strip.p5: "found"
```

// Interactive Diagram (5 frames): Binary search halving its range

![Binary search halving its range — frame 1 of 5](/media/synapse-features/animated-dsa/binary-search/frame-1.svg)

![Binary search halving its range — frame 2 of 5](/media/synapse-features/animated-dsa/binary-search/frame-2.svg)

![Binary search halving its range — frame 3 of 5](/media/synapse-features/animated-dsa/binary-search/frame-3.svg)

![Binary search halving its range — frame 4 of 5](/media/synapse-features/animated-dsa/binary-search/frame-4.svg)

![Binary search halving its range — frame 5 of 5](/media/synapse-features/animated-dsa/binary-search/frame-5.svg)

Frame 2 discards five cells on one comparison. Three comparisons finish the array, and log₂(9) ≈ 3.2
— not a coincidence, because each frame halved what was left.

The `pruned` class does the teaching: a discarded cell is not merely unvisited, it has been *proven
impossible*, and the dashed red says so.

## BFS frontier

Breadth-first search is a wave, and a wave is what a still picture is worst at. Five frames of the
frontier expanding one hop at a time.

```bash
# bfs-frontier.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · BFS FRONTIER ─────────────────────────────────────────────
# animation-mode: highlight
# lesson: animated-dsa
# caption: A BFS frontier expanding one hop at a time
# Breadth-first search is a wave, and a wave is the thing a still picture is worst at.
# Five frames show the frontier expanding one hop at a time — which IS the proof that
# BFS finds shortest paths: a node is reached in the first frame it could possibly be
# reached in.
#
# Free layout, not a grid, so the stability rule is the strict one: every node and edge
# is declared here and frames only recolour. The `node` class pins 56×56, so even the
# heavier `current` border cannot resize a circle.
#
#   idle     not reached yet
#   current  the frontier — the level the queue is chewing through now
#   visited  dequeued and done
#
# Knobs: the graph. Keep it shallow — four levels is already a long animation.

...@../../lib/theme

direction: down

title: "BFS · the frontier expands one hop at a time" { near: top-center; shape: text; width: 640; style: { font-size: 19; bold: true } }

a: A { class: [node; idle]; shape: circle }
b: B { class: [node; idle]; shape: circle }
c: C { class: [node; idle]; shape: circle }
d: D { class: [node; idle]; shape: circle }
e: E { class: [node; idle]; shape: circle }
f: F { class: [node; idle]; shape: circle }
g: G { class: [node; idle]; shape: circle }

a -> b: "" { class: dim; style.stroke-width: 2 }
a -> c: "" { class: dim; style.stroke-width: 2 }
b -> d: "" { class: dim; style.stroke-width: 2 }
b -> e: "" { class: dim; style.stroke-width: 2 }
c -> e: "" { class: dim; style.stroke-width: 2 }
c -> f: "" { class: dim; style.stroke-width: 2 }
e -> g: "" { class: dim; style.stroke-width: 2 }

# ── 01-start.d2 ─────────────────────────────────
# Frame 1 — the source, and nothing else. queue = [A]
...@./base
title: "1 · start at A · queue [A] · distance 0"
a.class: [node; current]

# ── 02-level1.d2 ─────────────────────────────────
# Frame 2 — every neighbour of A, all at once. This is the "breadth" — the whole level
# is enqueued before any of it is explored.
...@./base
title: "2 · level 1 · queue [B, C] · distance 1"
a.class: [node; visited]
b.class: [node; current]
c.class: [node; current]
(a -> b)[0].class: step
(a -> c)[0].class: step

# ── 03-level2.d2 ─────────────────────────────────
# Frame 3 — E is reachable from both B and C, and is reached exactly once: the first
# visit wins, and because levels are finished in order, the first visit is the shortest.
...@./base
title: "3 · level 2 · queue [D, E, F] · E is reached once, not twice"
a.class: [node; visited]
b.class: [node; visited]
c.class: [node; visited]
d.class: [node; current]
e.class: [node; current]
f.class: [node; current]
(b -> d)[0].class: step
(b -> e)[0].class: step
(c -> e)[0].class: hint
(c -> f)[0].class: step

# ── 04-level3.d2 ─────────────────────────────────
# Frame 4 — the last hop. G could not have been found earlier, because level 3 does not
# start until level 2 is empty.
...@./base
title: "4 · level 3 · queue [G] · distance 3"
a.class: [node; visited]
b.class: [node; visited]
c.class: [node; visited]
d.class: [node; visited]
e.class: [node; visited]
f.class: [node; visited]
g.class: [node; current]
(e -> g)[0].class: step

# ── 05-done.d2 ─────────────────────────────────
# Frame 5 — done. Every node carries the distance it was first reached at, and every one
# of those is the shortest — on an UNWEIGHTED graph. Add weights and this argument
# collapses; that is where Dijkstra starts.
...@./base
title: "5 · queue empty · every distance is a shortest distance (unweighted only)"
a.class: [node; visited]
b.class: [node; visited]
c.class: [node; visited]
d.class: [node; visited]
e.class: [node; visited]
f.class: [node; visited]
g.class: [node; visited]
```

// Interactive Diagram (5 frames): A BFS frontier expanding one hop at a time

![A BFS frontier expanding one hop at a time — frame 1 of 5](/media/synapse-features/animated-dsa/bfs-frontier/frame-1.svg)

![A BFS frontier expanding one hop at a time — frame 2 of 5](/media/synapse-features/animated-dsa/bfs-frontier/frame-2.svg)

![A BFS frontier expanding one hop at a time — frame 3 of 5](/media/synapse-features/animated-dsa/bfs-frontier/frame-3.svg)

![A BFS frontier expanding one hop at a time — frame 4 of 5](/media/synapse-features/animated-dsa/bfs-frontier/frame-4.svg)

![A BFS frontier expanding one hop at a time — frame 5 of 5](/media/synapse-features/animated-dsa/bfs-frontier/frame-5.svg)

This is the proof that BFS finds shortest paths, drawn rather than argued: a node is reached in the
first frame it *could* be reached in, because a level does not start until the one before it is
empty. Frame 3 makes the point twice — E is reachable from both B and C, and is reached exactly
once.

The argument holds only on an **unweighted** graph. Add weights and it collapses, which is where
Dijkstra starts.

## A DP table filling in

Counting paths across a 4×4 grid, moving only right or down. Every cell is the sum of the one above
it and the one to its left.

```bash
# dp-2d-fill.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · A DP TABLE FILLING IN ────────────────────────────────────
# animation-mode: highlight
# lesson: animated-dsa
# caption: A DP table filling in, one cell at a time
# Counting paths across a 4×4 grid, moving only right or down. Every cell is the sum of
# the one above it and the one to its left — and THAT is the thing a static table cannot
# show: which two cells the answer came from.
#
# Each frame lights the cell being computed (`current`) and the cells it reads (`hot`).
# Filled cells go `visited`, the untouched remainder stays `idle`. Read the frames in
# order and you are watching the recurrence, not the result.
#
# Grid cells have a pinned width, so a frame can safely write a NUMBER into one. That is
# the exception to "frames never relabel": inside a grid, a label cannot resize a column.
#
# Knobs: the grid size and the recurrence. The same skeleton draws edit distance, LCS,
# knapsack — anything with a two-dimensional table and a local rule.

...@../../lib/theme

title: "dynamic programming · paths[r][c] = paths[r-1][c] + paths[r][c-1]" { near: top-center; shape: text; width: 700; style: { font-size: 19; bold: true } }

table: "" { class: board
  grid-rows: 4
  grid-columns: 4
  grid-gap: 0

  r0c0: 1 { class: [cell; idle] }
  r0c1: "·" { class: [cell; idle] }
  r0c2: "·" { class: [cell; idle] }
  r0c3: "·" { class: [cell; idle] }

  r1c0: "·" { class: [cell; idle] }
  r1c1: "·" { class: [cell; idle] }
  r1c2: "·" { class: [cell; idle] }
  r1c3: "·" { class: [cell; idle] }

  r2c0: "·" { class: [cell; idle] }
  r2c1: "·" { class: [cell; idle] }
  r2c2: "·" { class: [cell; idle] }
  r2c3: "·" { class: [cell; idle] }

  r3c0: "·" { class: [cell; idle] }
  r3c1: "·" { class: [cell; idle] }
  r3c2: "·" { class: [cell; idle] }
  r3c3: "·" { class: [cell; idle] }
}

# ── 01-base-cases.d2 ─────────────────────────────────
# Frame 1 — the base cases, and they are base cases for a reason: along the top edge and
# the left edge there is exactly one path, because there is only one legal move.
...@./base
title: "1 · base cases · one path along each edge"
table.r0c0.class: [cell; visited]
table.r0c1: 1 { class: [cell; visited] }
table.r0c2: 1 { class: [cell; visited] }
table.r0c3: 1 { class: [cell; visited] }
table.r1c0: 1 { class: [cell; visited] }
table.r2c0: 1 { class: [cell; visited] }
table.r3c0: 1 { class: [cell; visited] }

# ── 02-first-cell.d2 ─────────────────────────────────
# Frame 2 — the first real cell. The two lit neighbours are the entire recurrence: this
# frame is the one to pause on.
...@./base
title: "2 · [1][1] = 1 above + 1 left = 2"
table.r0c0.class: [cell; visited]
table.r0c1: 1 { class: [cell; hot] }
table.r0c2: 1 { class: [cell; visited] }
table.r0c3: 1 { class: [cell; visited] }
table.r1c0: 1 { class: [cell; hot] }
table.r1c1: 2 { class: [cell; current] }
table.r2c0: 1 { class: [cell; visited] }
table.r3c0: 1 { class: [cell; visited] }

# ── 03-finish-row.d2 ─────────────────────────────────
# Frame 3 — the same rule, one step right. The cell it read a moment ago is now one of
# the inputs, which is why the table is filled in this order and no other.
...@./base
title: "3 · [1][2] = 1 above + 2 left = 3 · yesterday's answer is today's input"
table.r0c0.class: [cell; visited]
table.r0c1: 1 { class: [cell; visited] }
table.r0c2: 1 { class: [cell; hot] }
table.r0c3: 1 { class: [cell; visited] }
table.r1c0: 1 { class: [cell; visited] }
table.r1c1: 2 { class: [cell; hot] }
table.r1c2: 3 { class: [cell; current] }
table.r2c0: 1 { class: [cell; visited] }
table.r3c0: 1 { class: [cell; visited] }

# ── 04-row-two.d2 ─────────────────────────────────
# Frame 4 — row 1 is complete and row 2 is under way. Nothing new is happening, and that
# is the point: one rule, applied 9 times.
...@./base
title: "4 · row 1 done · [2][1] = 2 above + 1 left = 3"
table.r0c0.class: [cell; visited]
table.r0c1: 1 { class: [cell; visited] }
table.r0c2: 1 { class: [cell; visited] }
table.r0c3: 1 { class: [cell; visited] }
table.r1c0: 1 { class: [cell; visited] }
table.r1c1: 2 { class: [cell; hot] }
table.r1c2: 3 { class: [cell; visited] }
table.r1c3: 4 { class: [cell; visited] }
table.r2c0: 1 { class: [cell; hot] }
table.r2c1: 3 { class: [cell; current] }
table.r3c0: 1 { class: [cell; visited] }

# ── 05-answer.d2 ─────────────────────────────────
# Frame 5 — the answer sits in the corner: 20 paths. Sixteen cells were computed, each
# once, each in constant time — O(rows × cols), and no path was ever enumerated.
...@./base
title: "5 · 20 paths · every cell computed exactly once — O(r × c)"
table.r0c0.class: [cell; visited]
table.r0c1: 1 { class: [cell; visited] }
table.r0c2: 1 { class: [cell; visited] }
table.r0c3: 1 { class: [cell; visited] }
table.r1c0: 1 { class: [cell; visited] }
table.r1c1: 2 { class: [cell; visited] }
table.r1c2: 3 { class: [cell; visited] }
table.r1c3: 4 { class: [cell; visited] }
table.r2c0: 1 { class: [cell; visited] }
table.r2c1: 3 { class: [cell; visited] }
table.r2c2: 6 { class: [cell; visited] }
table.r2c3: 10 { class: [cell; visited] }
table.r3c0: 1 { class: [cell; visited] }
table.r3c1: 4 { class: [cell; visited] }
table.r3c2: 10 { class: [cell; visited] }
table.r3c3: 20 { class: [cell; current] }
```

// Interactive Diagram (5 frames): A DP table filling in, one cell at a time

![A DP table filling in, one cell at a time — frame 1 of 5](/media/synapse-features/animated-dsa/dp-2d-fill/frame-1.svg)

![A DP table filling in, one cell at a time — frame 2 of 5](/media/synapse-features/animated-dsa/dp-2d-fill/frame-2.svg)

![A DP table filling in, one cell at a time — frame 3 of 5](/media/synapse-features/animated-dsa/dp-2d-fill/frame-3.svg)

![A DP table filling in, one cell at a time — frame 4 of 5](/media/synapse-features/animated-dsa/dp-2d-fill/frame-4.svg)

![A DP table filling in, one cell at a time — frame 5 of 5](/media/synapse-features/animated-dsa/dp-2d-fill/frame-5.svg)

Each frame lights the cell being computed and the two cells it reads. That is the thing a finished
table cannot show: not the answer, but where the answer came from — and therefore why the table is
filled in this order and no other. Yesterday's answer is today's input.

Sixteen cells, each computed once, each in constant time. No path is ever enumerated, which is the
whole difference between the DP and the recursion it replaces.

The same skeleton draws edit distance, LCS and knapsack — any two-dimensional table with a local
rule. Change the values, the title and the recurrence in the header, and the frames still work.

## Next

- [Animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram) — the four transports and the rules behind these figures.
- [Arrays and windows](/synapse/synapse-features/d2-component-library/dsa-arrays-and-windows) — the static blocks these animate.
