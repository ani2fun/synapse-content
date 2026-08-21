---
title: "DSA blocks — arrays, windows and pointers"
summary: "Copy-and-adapt D2 templates for the array strip, sliding windows that expand and shrink, two-pointer and fast/slow pointer walks, and the prefix-sum and difference-array pair."
---

# DSA blocks — arrays, windows and pointers

Templates for the index-carrying half of linear structures. Each is a file under
`synapse-features/_d2-blocks/dsa/`; the fence above each figure is that file with its theme inlined,
so you can copy either.

Read [Using the component library](/synapse/synapse-features/d2-component-library/using-the-library)
first if you have not — the state classes and the two grid rules it covers are assumed here.

## The strip

Everything on this page is built from this. Cells in a row, indices underneath, `grid-gap: 0`
holding them together.

```bash
classes: {
  board: { label: ""; style: { fill: transparent; stroke-width: 0 } }
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
}

arr: { class: board
  # grid-rows AND grid-columns, both of them. With only grid-columns, D2 fills
  # column-major and the index row lands beside the values instead of beneath them.
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0   # what makes the cells read as one strip rather than seven boxes

  # TODO: the values — row 1.
  v0: 2  { class: cell }
  v1: 7  { class: cell }
  v2: 11 { class: cell }
  v3: 15 { class: cell }
  v4: 1  { class: cell }
  v5: 8  { class: cell }
  v6: 4  { class: cell }

  # TODO: the indices — row 2. One per value, or the columns stop lining up.
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
}
```

```d2
classes: {
  board: { label: ""; style: { fill: transparent; stroke-width: 0 } }
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
}

arr: { class: board
  # grid-rows AND grid-columns, both of them. With only grid-columns, D2 fills
  # column-major and the index row lands beside the values instead of beneath them.
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0   # what makes the cells read as one strip rather than seven boxes

  # TODO: the values — row 1.
  v0: 2  { class: cell }
  v1: 7  { class: cell }
  v2: 11 { class: cell }
  v3: 15 { class: cell }
  v4: 1  { class: cell }
  v5: 8  { class: cell }
  v6: 4  { class: cell }

  # TODO: the indices — row 2. One per value, or the columns stop lining up.
  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
}
```

### A highlighted range

The same strip with a slice called out and its bounds captioned on a spacer row.

```bash
classes: {
  board: { label: ""; style: { fill: transparent; stroke-width: 0 } }
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

arr: { class: board
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 2  { class: cell }
  v1: 7  { class: cell }
  # TODO: the range — [2, 5) here.
  v2: 11 { class: [cell; active] }
  v3: 15 { class: [cell; active] }
  v4: 1  { class: [cell; active] }
  v5: 8  { class: cell }
  v6: 4  { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  # A spacer row is how you label ONE column. Connections do not route into a grid, so
  # an arrow pointing at cell 2 is not an option — an invisible cell holding a caption is.
  c0 { class: ghost }
  c1 { class: ghost }
  c2: "▲ lo"   { class: tick; style.font-color: "#16a34a" }
  c3 { class: ghost }
  c4: "▲ hi-1" { class: tick; style.font-color: "#16a34a" }
  c5 { class: ghost }
  c6 { class: ghost }
}
```

```d2
classes: {
  board: { label: ""; style: { fill: transparent; stroke-width: 0 } }
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

arr: { class: board
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 2  { class: cell }
  v1: 7  { class: cell }
  # TODO: the range — [2, 5) here.
  v2: 11 { class: [cell; active] }
  v3: 15 { class: [cell; active] }
  v4: 1  { class: [cell; active] }
  v5: 8  { class: cell }
  v6: 4  { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  # A spacer row is how you label ONE column. Connections do not route into a grid, so
  # an arrow pointing at cell 2 is not an option — an invisible cell holding a caption is.
  c0 { class: ghost }
  c1 { class: ghost }
  c2: "▲ lo"   { class: tick; style.font-color: "#16a34a" }
  c3 { class: ghost }
  c4: "▲ hi-1" { class: tick; style.font-color: "#16a34a" }
  c5 { class: ghost }
  c6 { class: ghost }
}
```

### One write

The transition skeleton at its simplest — a cell fills, the cursor advances.

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

## Sliding window

State the invariant in the title. A window figure without one is just a highlighted range.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

win: "window [1, 4]  ·  sum = 31" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  v0: 4  { class: cell }
  # TODO: the window — the run of `active` cells.
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: [cell; active] }
  v5: 15 { class: cell }
  v6: 6  { class: cell }
  v7: 2  { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  # TODO: move the two ticks to the window's columns.
  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6 { class: ghost }
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
}

win: "window [1, 4]  ·  sum = 31" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  v0: 4  { class: cell }
  # TODO: the window — the run of `active` cells.
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: [cell; active] }
  v5: 15 { class: cell }
  v6: 6  { class: cell }
  v7: 2  { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  # TODO: move the two ticks to the window's columns.
  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
  p6 { class: ghost }
  p7 { class: ghost }
}
```

### Expanding

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · sum = 19" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: cell }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5 { class: ghost }
}

after: "after · sum = 28" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  # TODO: the cell that just entered the window.
  v3: 9  { class: [cell; current] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2 { class: ghost }
  p3: "▲ r" { class: tick; style.font-color: "#ca8a04" }
  p4 { class: ghost }
  p5 { class: ghost }
}

before -> after: "r++\n+ a[3]" { class: step }
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
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · sum = 19" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: cell }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5 { class: ghost }
}

after: "after · sum = 28" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; active] }
  v2: 7  { class: [cell; active] }
  # TODO: the cell that just entered the window.
  v3: 9  { class: [cell; current] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p2 { class: ghost }
  p3: "▲ r" { class: tick; style.font-color: "#ca8a04" }
  p4 { class: ghost }
  p5 { class: ghost }
}

before -> after: "r++\n+ a[3]" { class: step }
```

### Shrinking

The mirror image, and the half people forget to draw. Pair the two and the technique's whole
two-phase shape is on the page.

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
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · sum = 28 > 25 ✗" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  # TODO: the cell about to leave the window.
  v1: 12 { class: [cell; current] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
}

after: "after · sum = 16 ≤ 25 ✓" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; visited] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p3: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
}

before -> after: "l++\n− a[1]" { class: step }
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
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · sum = 28 > 25 ✗" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  # TODO: the cell about to leave the window.
  v1: 12 { class: [cell; current] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1: "▲ l" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
}

after: "after · sum = 16 ≤ 25 ✓" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: 4  { class: cell }
  v1: 12 { class: [cell; visited] }
  v2: 7  { class: [cell; active] }
  v3: 9  { class: [cell; active] }
  v4: 3  { class: cell }
  v5: 15 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ l" { class: tick; style.font-color: "#16a34a" }
  p3: "▲ r" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
}

before -> after: "l++\n− a[1]" { class: step }
```

## Pointers

Two pointers closing in from both ends of a sorted strip. What the figure has to show is not the
pointers but the cells they have already ruled out.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
}

tp: "sorted · looking for a pair summing to 18" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: cells already ruled out.
  v0: 1  { class: [cell; visited] }
  v1: 3  { class: [cell; current] }
  v2: 6  { class: cell }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }
  v7: 23 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
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
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
}

tp: "sorted · looking for a pair summing to 18" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: cells already ruled out.
  v0: 1  { class: [cell; visited] }
  v1: 3  { class: [cell; current] }
  v2: 6  { class: cell }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }
  v7: 23 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
  i7: 7 { class: idx }

  p0 { class: ghost }
  p1: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
  p7 { class: ghost }
}
```

### One comparison

Say *why* the pointer moved in the arrow label. That "why" is the correctness argument for the whole
technique, and it fits in three words.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · 3 + 14 = 17 < 18" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 1  { class: [cell; visited] }
  v1: 3  { class: [cell; current] }
  v2: 6  { class: cell }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
}

after: "after · 6 + 14 = 20 > 18" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 1  { class: [cell; visited] }
  # TODO: the value the moved pointer left behind — ruled out for good.
  v1: 3  { class: [cell; visited] }
  v2: 6  { class: [cell; current] }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
}

before -> after: "17 < 18\nlo++" { class: step }
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
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · 3 + 14 = 17 < 18" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 1  { class: [cell; visited] }
  v1: 3  { class: [cell; current] }
  v2: 6  { class: cell }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p2 { class: ghost }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
}

after: "after · 6 + 14 = 20 > 18" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: 1  { class: [cell; visited] }
  # TODO: the value the moved pointer left behind — ruled out for good.
  v1: 3  { class: [cell; visited] }
  v2: 6  { class: [cell; current] }
  v3: 8  { class: cell }
  v4: 11 { class: cell }
  v5: 14 { class: [cell; current] }
  v6: 19 { class: [cell; visited] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1 { class: ghost }
  p2: "▲ lo" { class: tick; style.font-color: "#ca8a04" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ hi" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
}

before -> after: "17 < 18\nlo++" { class: step }
```

### Fast and slow

Nodes rather than cells here, because the hop lengths are the point — so each pointer's move is drawn
at the length it actually covers.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

n1: 1 { class: [node; visited] }
n2: 2 { class: [node; visited] }
# TODO: where slow is now.
n3: 3 { class: [node; current] }
n4: 4 { class: node }
# TODO: where fast is now — twice as far along.
n5: 5 { class: [node; active] }
n6: 6 { class: node }
n7: 7 { class: node }

n1 -> n2 -> n3 -> n4 -> n5 -> n6 -> n7: { class: hint }

# The two moves of one tick, drawn at the length they actually cover. Fast closes the
# gap by exactly one node per tick, which is why it catches slow inside any cycle.
n3 -> n4: "slow +1" { class: step; style.stroke: "#ca8a04" }
n5 -> n7: "fast +2" { class: step; style.stroke: "#16a34a" }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

n1: 1 { class: [node; visited] }
n2: 2 { class: [node; visited] }
# TODO: where slow is now.
n3: 3 { class: [node; current] }
n4: 4 { class: node }
# TODO: where fast is now — twice as far along.
n5: 5 { class: [node; active] }
n6: 6 { class: node }
n7: 7 { class: node }

n1 -> n2 -> n3 -> n4 -> n5 -> n6 -> n7: { class: hint }

# The two moves of one tick, drawn at the length they actually cover. Fast closes the
# gap by exactly one node per tick, which is why it catches slow inside any cycle.
n3 -> n4: "slow +1" { class: step; style.stroke: "#ca8a04" }
n5 -> n7: "fast +2" { class: step; style.stroke: "#16a34a" }
```

## Prefix and difference

The offset is the whole reason to draw a prefix array rather than describe it: `p` has one more cell
than `a`, the extra one is `p[0] = 0` at the front, and so `a[i]` sits above `p[i+1]`.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

pre: "sum(a[1..3]) = p[4] − p[1] = 27 − 4 = 23" { class: panel
  grid-rows: 4
  grid-columns: 8
  grid-gap: 0

  # ── row 1: the input. Two leading ghosts push a[0] over p[1].
  la: "a" { class: tick }
  ga { class: ghost }
  # TODO: the range being summed.
  a0: 4  { class: cell }
  a1: 12 { class: [cell; active] }
  a2: 7  { class: [cell; active] }
  a3: 4  { class: [cell; active] }
  a4: 3  { class: cell }
  a5: 15 { class: cell }

  # ── row 2: a's indices
  la2 { class: ghost }
  ga2 { class: ghost }
  ia0: 0 { class: idx }
  ia1: 1 { class: idx }
  ia2: 2 { class: idx }
  ia3: 3 { class: idx }
  ia4: 4 { class: idx }
  ia5: 5 { class: idx }

  # ── row 3: the running totals, p[i] = p[i-1] + a[i-1]
  lp: "p" { class: tick }
  # TODO: p[0] is always 0 — the cell that makes the arithmetic work at the left edge.
  p0: 0  { class: [cell; cold] }
  # TODO: the two endpoints of the subtraction.
  p1: 4  { class: [cell; current] }
  p2: 16 { class: cell }
  p3: 23 { class: cell }
  p4: 27 { class: [cell; current] }
  p5: 30 { class: cell }
  p6: 45 { class: cell }

  # ── row 4: p's indices
  lp2 { class: ghost }
  ip0: 0 { class: idx }
  ip1: 1 { class: idx }
  ip2: 2 { class: idx }
  ip3: 3 { class: idx }
  ip4: 4 { class: idx }
  ip5: 5 { class: idx }
  ip6: 6 { class: idx }
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
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

pre: "sum(a[1..3]) = p[4] − p[1] = 27 − 4 = 23" { class: panel
  grid-rows: 4
  grid-columns: 8
  grid-gap: 0

  # ── row 1: the input. Two leading ghosts push a[0] over p[1].
  la: "a" { class: tick }
  ga { class: ghost }
  # TODO: the range being summed.
  a0: 4  { class: cell }
  a1: 12 { class: [cell; active] }
  a2: 7  { class: [cell; active] }
  a3: 4  { class: [cell; active] }
  a4: 3  { class: cell }
  a5: 15 { class: cell }

  # ── row 2: a's indices
  la2 { class: ghost }
  ga2 { class: ghost }
  ia0: 0 { class: idx }
  ia1: 1 { class: idx }
  ia2: 2 { class: idx }
  ia3: 3 { class: idx }
  ia4: 4 { class: idx }
  ia5: 5 { class: idx }

  # ── row 3: the running totals, p[i] = p[i-1] + a[i-1]
  lp: "p" { class: tick }
  # TODO: p[0] is always 0 — the cell that makes the arithmetic work at the left edge.
  p0: 0  { class: [cell; cold] }
  # TODO: the two endpoints of the subtraction.
  p1: 4  { class: [cell; current] }
  p2: 16 { class: cell }
  p3: 23 { class: cell }
  p4: 27 { class: [cell; current] }
  p5: 30 { class: cell }
  p6: 45 { class: cell }

  # ── row 4: p's indices
  lp2 { class: ghost }
  ip0: 0 { class: idx }
  ip1: 1 { class: idx }
  ip2: 2 { class: idx }
  ip3: 3 { class: idx }
  ip4: 4 { class: idx }
  ip5: 5 { class: idx }
  ip6: 6 { class: idx }
}
```

### Difference array

Prefix sum run backwards. Two cells touched, one later pass, every range update applied at once.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

diff: "range update: a[2..4] += 5  →  d[2] += 5, d[5] −= 5" { class: panel
  grid-rows: 4
  grid-columns: 8
  grid-gap: 0

  ld: "d" { class: tick }
  d0: 0  { class: cell }
  d1: 0  { class: cell }
  # TODO: the two cells a range update touches. Everything else stays put.
  d2: "+5" { class: [cell; current] }
  d3: 0  { class: cell }
  d4: 0  { class: cell }
  d5: "−5" { class: [cell; current] }
  d6: 0  { class: cell }

  ld2 { class: ghost }
  id0: 0 { class: idx }
  id1: 1 { class: idx }
  id2: 2 { class: idx }
  id3: 3 { class: idx }
  id4: 4 { class: idx }
  id5: 5 { class: idx }
  id6: 6 { class: idx }

  # The prefix sum of d is the applied result — one pass, all ranges at once.
  la: "Σd" { class: tick }
  a0: 0 { class: cell }
  a1: 0 { class: cell }
  a2: 5 { class: [cell; active] }
  a3: 5 { class: [cell; active] }
  a4: 5 { class: [cell; active] }
  a5: 0 { class: cell }
  a6: 0 { class: cell }

  la2 { class: ghost }
  ia0: 0 { class: idx }
  ia1: 1 { class: idx }
  ia2: 2 { class: idx }
  ia3: 3 { class: idx }
  ia4: 4 { class: idx }
  ia5: 5 { class: idx }
  ia6: 6 { class: idx }
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
}

diff: "range update: a[2..4] += 5  →  d[2] += 5, d[5] −= 5" { class: panel
  grid-rows: 4
  grid-columns: 8
  grid-gap: 0

  ld: "d" { class: tick }
  d0: 0  { class: cell }
  d1: 0  { class: cell }
  # TODO: the two cells a range update touches. Everything else stays put.
  d2: "+5" { class: [cell; current] }
  d3: 0  { class: cell }
  d4: 0  { class: cell }
  d5: "−5" { class: [cell; current] }
  d6: 0  { class: cell }

  ld2 { class: ghost }
  id0: 0 { class: idx }
  id1: 1 { class: idx }
  id2: 2 { class: idx }
  id3: 3 { class: idx }
  id4: 4 { class: idx }
  id5: 5 { class: idx }
  id6: 6 { class: idx }

  # The prefix sum of d is the applied result — one pass, all ranges at once.
  la: "Σd" { class: tick }
  a0: 0 { class: cell }
  a1: 0 { class: cell }
  a2: 5 { class: [cell; active] }
  a3: 5 { class: [cell; active] }
  a4: 5 { class: [cell; active] }
  a5: 0 { class: cell }
  a6: 0 { class: cell }

  la2 { class: ghost }
  ia0: 0 { class: idx }
  ia1: 1 { class: idx }
  ia2: 2 { class: idx }
  ia3: 3 { class: idx }
  ia4: 4 { class: idx }
  ia5: 5 { class: idx }
  ia6: 6 { class: idx }
}
```

---

Next: [stacks, queues, lists and hashing](/synapse/synapse-features/d2-component-library/dsa-stacks-lists-hashing).
