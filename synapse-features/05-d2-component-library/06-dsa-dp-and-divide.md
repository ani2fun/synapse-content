---
title: "DSA blocks — DP and divide-and-conquer"
summary: "Copy-and-adapt D2 templates for 1-D and 2-D DP tables with their dependency cells, recursion trees with memo hits, binary search, the quicksort partition invariant, the merge step and grid traversal."
---

# DSA blocks — DP and divide-and-conquer

Tables that get filled and ranges that get halved. Files live under
`synapse-features/_d2-blocks/dsa/`.

## Dynamic programming

Show the dependencies. A DP table drawn without them is just an array, and the recurrence is the
thing the reader came for.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

dp: "fib · dp[i] = dp[i−1] + dp[i−2]" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: already computed.
  v0: 0 { class: [cell; visited] }
  v1: 1 { class: [cell; visited] }
  v2: 1 { class: [cell; visited] }
  v3: 2 { class: [cell; visited] }
  # TODO: the two the recurrence reads.
  v4: 3 { class: [cell; active] }
  v5: 5 { class: [cell; active] }
  # TODO: the one being written now.
  v6: 8 { class: [cell; current] }
  # TODO: not reached.
  v7: "·" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ i−2" { class: tick; style.font-color: "#16a34a" }
  p5: "▲ i−1" { class: tick; style.font-color: "#16a34a" }
  p6: "▲ i" { class: tick; style.font-color: "#ca8a04" }
  p7 { class: ghost }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

dp: "fib · dp[i] = dp[i−1] + dp[i−2]" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: already computed.
  v0: 0 { class: [cell; visited] }
  v1: 1 { class: [cell; visited] }
  v2: 1 { class: [cell; visited] }
  v3: 2 { class: [cell; visited] }
  # TODO: the two the recurrence reads.
  v4: 3 { class: [cell; active] }
  v5: 5 { class: [cell; active] }
  # TODO: the one being written now.
  v6: 8 { class: [cell; current] }
  # TODO: not reached.
  v7: "·" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ i−2" { class: tick; style.font-color: "#16a34a" }
  p5: "▲ i−1" { class: tick; style.font-color: "#16a34a" }
  p6: "▲ i" { class: tick; style.font-color: "#ca8a04" }
  p7 { class: ghost }
}
```

### A 2-D grid

Up, left and diagonal — the three cells that determine the fill order. The diagonal is the one that
decides whether you can drop to a single row of memory later, so draw it even when the recurrence
happens not to use it.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

lcs: "LCS · match ⇒ diag+1, else max(up, left)" { class: panel
  grid-rows: 5
  grid-columns: 6
  grid-gap: 0

  h_: ""  { class: idx; height: 44 }
  h0: "∅" { class: idx; height: 44 }
  hA: A   { class: idx; height: 44 }
  hB: B   { class: idx; height: 44 }
  hC: C   { class: idx; height: 44 }
  hD: D   { class: idx; height: 44 }

  r0: "∅" { class: idx; height: 52 }
  c00: 0 { class: [cell; visited]; height: 52 }
  c01: 0 { class: [cell; visited]; height: 52 }
  c02: 0 { class: [cell; visited]; height: 52 }
  c03: 0 { class: [cell; visited]; height: 52 }
  c04: 0 { class: [cell; visited]; height: 52 }

  rA: A { class: idx; height: 52 }
  c10: 0 { class: [cell; visited]; height: 52 }
  c11: 1 { class: [cell; visited]; height: 52 }
  c12: 1 { class: [cell; visited]; height: 52 }
  c13: 1 { class: [cell; visited]; height: 52 }
  c14: 1 { class: [cell; visited]; height: 52 }

  rC: C { class: idx; height: 52 }
  c20: 0 { class: [cell; visited]; height: 52 }
  c21: 1 { class: [cell; visited]; height: 52 }
  # TODO: the three neighbours the recurrence reads — diag, up, left.
  c22: 1 { class: [cell; active]; height: 52 }
  c23: 1 { class: [cell; active]; height: 52 }
  c24: "·" { class: [cell; cold]; height: 52 }

  rD: D { class: idx; height: 52 }
  c30: 0 { class: [cell; visited]; height: 52 }
  c31: 1 { class: [cell; visited]; height: 52 }
  c32: 1 { class: [cell; active]; height: 52 }
  # TODO: the cell being written.
  c33: 2 { class: [cell; current]; height: 52 }
  c34: "·" { class: [cell; cold]; height: 52 }
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
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

lcs: "LCS · match ⇒ diag+1, else max(up, left)" { class: panel
  grid-rows: 5
  grid-columns: 6
  grid-gap: 0

  h_: ""  { class: idx; height: 44 }
  h0: "∅" { class: idx; height: 44 }
  hA: A   { class: idx; height: 44 }
  hB: B   { class: idx; height: 44 }
  hC: C   { class: idx; height: 44 }
  hD: D   { class: idx; height: 44 }

  r0: "∅" { class: idx; height: 52 }
  c00: 0 { class: [cell; visited]; height: 52 }
  c01: 0 { class: [cell; visited]; height: 52 }
  c02: 0 { class: [cell; visited]; height: 52 }
  c03: 0 { class: [cell; visited]; height: 52 }
  c04: 0 { class: [cell; visited]; height: 52 }

  rA: A { class: idx; height: 52 }
  c10: 0 { class: [cell; visited]; height: 52 }
  c11: 1 { class: [cell; visited]; height: 52 }
  c12: 1 { class: [cell; visited]; height: 52 }
  c13: 1 { class: [cell; visited]; height: 52 }
  c14: 1 { class: [cell; visited]; height: 52 }

  rC: C { class: idx; height: 52 }
  c20: 0 { class: [cell; visited]; height: 52 }
  c21: 1 { class: [cell; visited]; height: 52 }
  # TODO: the three neighbours the recurrence reads — diag, up, left.
  c22: 1 { class: [cell; active]; height: 52 }
  c23: 1 { class: [cell; active]; height: 52 }
  c24: "·" { class: [cell; cold]; height: 52 }

  rD: D { class: idx; height: 52 }
  c30: 0 { class: [cell; visited]; height: 52 }
  c31: 1 { class: [cell; visited]; height: 52 }
  c32: 1 { class: [cell; active]; height: 52 }
  # TODO: the cell being written.
  c33: 2 { class: [cell; current]; height: 52 }
  c34: "·" { class: [cell; cold]; height: 52 }
}
```

### Recursion tree with memo hits

The one figure that explains memoisation, because the saving is visible as area: every `✓ memo` node
is a subtree that never got expanded.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
}

direction: down

f5: "fib(5)" { class: [node; current]; width: 76 }
f4: "fib(4)" { class: node; width: 76 }
f3: "fib(3)" { class: node; width: 76 }
f3b: "fib(3)\n✓ memo" { class: [node; hot]; width: 76; height: 62 }
f2: "fib(2)" { class: node; width: 76 }
f2b: "fib(2)\n✓ memo" { class: [node; hot]; width: 76; height: 62 }
f1: "fib(1)" { class: [node; visited]; width: 76 }
f0: "fib(0)" { class: [node; visited]; width: 76 }

f5 -> f4
f5 -> f3b
f4 -> f3
f4 -> f2b
f3 -> f2
f3 -> f1
f2 -> f1
f2 -> f0

note: "every ✓ memo node is a subtree that was never expanded" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#ea580c" }
}
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
}

direction: down

f5: "fib(5)" { class: [node; current]; width: 76 }
f4: "fib(4)" { class: node; width: 76 }
f3: "fib(3)" { class: node; width: 76 }
f3b: "fib(3)\n✓ memo" { class: [node; hot]; width: 76; height: 62 }
f2: "fib(2)" { class: node; width: 76 }
f2b: "fib(2)\n✓ memo" { class: [node; hot]; width: 76; height: 62 }
f1: "fib(1)" { class: [node; visited]; width: 76 }
f0: "fib(0)" { class: [node; visited]; width: 76 }

f5 -> f4
f5 -> f3b
f4 -> f3
f4 -> f2b
f3 -> f2
f3 -> f1
f2 -> f1
f2 -> f0

note: "every ✓ memo node is a subtree that was never expanded" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#ea580c" }
}
```

## Divide and conquer

The grey half is the algorithm. Each comparison throws away half the remaining range, and that is
where the log *n* comes from.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
}

bs: "search 11 · a[mid]=8 < 11 ⇒ the left half is gone" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  # TODO: the half just discarded.
  v0: 1  { class: [cell; pruned] }
  v1: 3  { class: [cell; pruned] }
  v2: 5  { class: [cell; pruned] }
  v3: 8  { class: [cell; pruned] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; active] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3: "▲ mid" { class: tick; style.font-color: "#dc2626" }
  p4: "▲ new lo" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6 { class: ghost }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
}

bs: "search 11 · a[mid]=8 < 11 ⇒ the left half is gone" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  # TODO: the half just discarded.
  v0: 1  { class: [cell; pruned] }
  v1: 3  { class: [cell; pruned] }
  v2: 5  { class: [cell; pruned] }
  v3: 8  { class: [cell; pruned] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; active] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3: "▲ mid" { class: tick; style.font-color: "#dc2626" }
  p4: "▲ new lo" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6 { class: ghost }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}
```

### One halving

Put the range *size* in both titles. 9 → 4 → 2 → 1 is the sequence a reader should leave with, and it
does not survive being described in words.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · 9 candidates" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  v0: 1  { class: [cell; active] }
  v1: 3  { class: [cell; active] }
  v2: 5  { class: [cell; active] }
  v3: 8  { class: [cell; current] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; active] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0: "▲ lo" { class: tick; style.font-color: "#16a34a" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3: "▲ mid" { class: tick; style.font-color: "#ca8a04" }
  p4 { class: ghost }
  p5 { class: ghost }
  p6 { class: ghost }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}

after: "after · 4 candidates" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  v0: 1  { class: [cell; pruned] }
  v1: 3  { class: [cell; pruned] }
  v2: 5  { class: [cell; pruned] }
  v3: 8  { class: [cell; pruned] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; current] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ lo" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6: "▲ mid" { class: tick; style.font-color: "#ca8a04" }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}

before -> after: "8 < 11\nlo = mid+1" { class: step }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · 9 candidates" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  v0: 1  { class: [cell; active] }
  v1: 3  { class: [cell; active] }
  v2: 5  { class: [cell; active] }
  v3: 8  { class: [cell; current] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; active] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0: "▲ lo" { class: tick; style.font-color: "#16a34a" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3: "▲ mid" { class: tick; style.font-color: "#ca8a04" }
  p4 { class: ghost }
  p5 { class: ghost }
  p6 { class: ghost }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}

after: "after · 4 candidates" { class: panel
  grid-rows: 3
  grid-columns: 9
  grid-gap: 0

  v0: 1  { class: [cell; pruned] }
  v1: 3  { class: [cell; pruned] }
  v2: 5  { class: [cell; pruned] }
  v3: 8  { class: [cell; pruned] }
  v4: 11 { class: [cell; active] }
  v5: 14 { class: [cell; active] }
  v6: 19 { class: [cell; current] }
  v7: 23 { class: [cell; active] }
  v8: 27 { class: [cell; active] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }
  i8: 8 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ lo" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6: "▲ mid" { class: tick; style.font-color: "#ca8a04" }
  p7 { class: ghost }
  p8: "▲ hi" { class: tick; style.font-color: "#16a34a" }
}

before -> after: "8 < 11\nlo = mid+1" { class: step }
```

### Quicksort partition

Three regions plus the pivot. The regions are the invariant: everything left of `i` is ≤ pivot,
everything between `i` and `j` is greater, everything right of `j` is unexamined.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
}

qs: "pivot = 7 · a[..i] ≤ 7 · a[i..j] > 7 · a[j..] unseen" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: the ≤ pivot region.
  v0: 3 { class: [cell; active] }
  v1: 5 { class: [cell; active] }
  # TODO: the > pivot region.
  v2: 9  { class: [cell; hot] }
  v3: 12 { class: [cell; hot] }
  # TODO: the cell being examined now.
  v4: 4 { class: [cell; current] }
  # TODO: not yet seen.
  v5: 11 { class: cell }
  v6: 2  { class: cell }
  # TODO: the pivot, parked at the end until the swap-back.
  v7: 7 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ i" { class: tick; style.font-color: "#16a34a" }
  p3 { class: ghost }
  p4: "▲ j" { class: tick; style.font-color: "#ca8a04" }
  p5 { class: ghost }
  p6 { class: ghost }
  p7: "▲ pivot" { class: tick }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
}

qs: "pivot = 7 · a[..i] ≤ 7 · a[i..j] > 7 · a[j..] unseen" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: the ≤ pivot region.
  v0: 3 { class: [cell; active] }
  v1: 5 { class: [cell; active] }
  # TODO: the > pivot region.
  v2: 9  { class: [cell; hot] }
  v3: 12 { class: [cell; hot] }
  # TODO: the cell being examined now.
  v4: 4 { class: [cell; current] }
  # TODO: not yet seen.
  v5: 11 { class: cell }
  v6: 2  { class: cell }
  # TODO: the pivot, parked at the end until the swap-back.
  v7: 7 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ i" { class: tick; style.font-color: "#16a34a" }
  p3 { class: ghost }
  p4: "▲ j" { class: tick; style.font-color: "#ca8a04" }
  p5 { class: ghost }
  p6 { class: ghost }
  p7: "▲ pivot" { class: tick }
}
```

### Merge step

Two sorted runs and the output being built from them. The reason merge sort needs O(n) extra space is
right there in the picture: a third strip, as long as the other two together.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: down

runs: "two sorted runs · compare the heads" { class: panel
  grid-rows: 4
  grid-columns: 5
  grid-gap: 0

  la: L { class: tick; width: 40 }
  # TODO: L's head — the smaller of the two heads wins.
  l0: 3 { class: [cell; visited] }
  l1: 8 { class: [cell; current] }
  l2: 14 { class: cell }
  l3: 21 { class: cell }

  la2 { class: ghost; width: 40 }
  il0: 0 { class: idx }
  il1: 1 { class: idx }
  il2: 2 { class: idx }
  il3: 3 { class: idx }

  lb: R { class: tick; width: 40 }
  r0: 5 { class: [cell; visited] }
  r1: 6 { class: [cell; current] }
  r2: 17 { class: cell }
  r3: 30 { class: cell }

  lb2 { class: ghost; width: 40 }
  ir0: 0 { class: idx }
  ir1: 1 { class: idx }
  ir2: 2 { class: idx }
  ir3: 3 { class: idx }
}

out: "output · 6 < 8, so 6 is written next" { class: panel
  grid-rows: 2
  grid-columns: 8
  grid-gap: 0

  o0: 3 { class: [cell; visited] }
  o1: 5 { class: [cell; visited] }
  # TODO: the cell about to be written.
  o2: 6 { class: [cell; current] }
  o3: "·" { class: [cell; cold] }
  o4: "·" { class: [cell; cold] }
  o5: "·" { class: [cell; cold] }
  o6: "·" { class: [cell; cold] }
  o7: "·" { class: [cell; cold] }

  j0: 0 { class: idx }
  j1: 1 { class: idx }
  j2: 2 { class: idx }
  j3: 3 { class: idx }
  j4: 4 { class: idx }
  j5: 5 { class: idx }
  j6: 6 { class: idx }
  j7: 7 { class: idx }
}

runs -> out: "min(8, 6) = 6\nadvance R" { class: step }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: down

runs: "two sorted runs · compare the heads" { class: panel
  grid-rows: 4
  grid-columns: 5
  grid-gap: 0

  la: L { class: tick; width: 40 }
  # TODO: L's head — the smaller of the two heads wins.
  l0: 3 { class: [cell; visited] }
  l1: 8 { class: [cell; current] }
  l2: 14 { class: cell }
  l3: 21 { class: cell }

  la2 { class: ghost; width: 40 }
  il0: 0 { class: idx }
  il1: 1 { class: idx }
  il2: 2 { class: idx }
  il3: 3 { class: idx }

  lb: R { class: tick; width: 40 }
  r0: 5 { class: [cell; visited] }
  r1: 6 { class: [cell; current] }
  r2: 17 { class: cell }
  r3: 30 { class: cell }

  lb2 { class: ghost; width: 40 }
  ir0: 0 { class: idx }
  ir1: 1 { class: idx }
  ir2: 2 { class: idx }
  ir3: 3 { class: idx }
}

out: "output · 6 < 8, so 6 is written next" { class: panel
  grid-rows: 2
  grid-columns: 8
  grid-gap: 0

  o0: 3 { class: [cell; visited] }
  o1: 5 { class: [cell; visited] }
  # TODO: the cell about to be written.
  o2: 6 { class: [cell; current] }
  o3: "·" { class: [cell; cold] }
  o4: "·" { class: [cell; cold] }
  o5: "·" { class: [cell; cold] }
  o6: "·" { class: [cell; cold] }
  o7: "·" { class: [cell; cold] }

  j0: 0 { class: idx }
  j1: 1 { class: idx }
  j2: 2 { class: idx }
  j3: 3 { class: idx }
  j4: 4 { class: idx }
  j5: 5 { class: idx }
  j6: 6 { class: idx }
  j7: 7 { class: idx }
}

runs -> out: "min(8, 6) = 6\nadvance R" { class: step }
```

## Grids

Every grid problem is a graph problem where the edges are implicit. This figure is the translation —
and drawing the walls is what stops a reader treating the grid as a full mesh.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
}

g: "shortest path S → G · ▓ is a wall" { class: panel
  grid-rows: 4
  grid-columns: 6
  grid-gap: 0

  # TODO: the start.
  a0: S { class: [cell; current] }
  a1: "·" { class: [cell; visited] }
  a2: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  a3: "·" { class: cell }
  a4: "·" { class: cell }
  a5: "·" { class: cell }

  b0: "·" { class: [cell; visited] }
  b1: "·" { class: [cell; visited] }
  b2: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  b3: "·" { class: cell }
  b4: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  b5: "·" { class: cell }

  c0: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  # TODO: the path.
  c1: "·" { class: [cell; active] }
  c2: "·" { class: [cell; active] }
  c3: "·" { class: [cell; active] }
  c4: "·" { class: cell }
  c5: "·" { class: cell }

  d0: "·" { class: cell }
  d1: "·" { class: cell }
  d2: "·" { class: cell }
  d3: "·" { class: [cell; active] }
  # TODO: the goal.
  d4: G { class: [cell; current] }
  d5: "·" { class: cell }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
}

g: "shortest path S → G · ▓ is a wall" { class: panel
  grid-rows: 4
  grid-columns: 6
  grid-gap: 0

  # TODO: the start.
  a0: S { class: [cell; current] }
  a1: "·" { class: [cell; visited] }
  a2: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  a3: "·" { class: cell }
  a4: "·" { class: cell }
  a5: "·" { class: cell }

  b0: "·" { class: [cell; visited] }
  b1: "·" { class: [cell; visited] }
  b2: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  b3: "·" { class: cell }
  b4: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  b5: "·" { class: cell }

  c0: "▓" { class: [cell; pruned]; style.stroke-dash: 0 }
  # TODO: the path.
  c1: "·" { class: [cell; active] }
  c2: "·" { class: [cell; active] }
  c3: "·" { class: [cell; active] }
  c4: "·" { class: cell }
  c5: "·" { class: cell }

  d0: "·" { class: cell }
  d1: "·" { class: cell }
  d2: "·" { class: cell }
  d3: "·" { class: [cell; active] }
  # TODO: the goal.
  d4: G { class: [cell; current] }
  d5: "·" { class: cell }
}
```
