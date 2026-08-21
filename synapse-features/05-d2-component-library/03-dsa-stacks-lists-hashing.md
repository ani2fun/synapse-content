---
title: "DSA blocks — stacks, lists and hashing"
summary: "Copy-and-adapt D2 templates for stacks, queues, deques, circular buffers, singly and doubly linked lists, cycle detection, hash tables in both collision strategies, and interval timelines."
---

# DSA blocks — stacks, lists and hashing

The rest of the linear structures: things with ends, things with pointers, and things with buckets.
Files live under `synapse-features/_d2-blocks/dsa/`, same as the
[array blocks](/synapse/synapse-features/d2-component-library/dsa-arrays-and-windows).

## Stacks and queues

Vertical, top at the top. Keep it that way and "push" means the same thing on the page as it does in
the code.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

st: "stack · top = 9" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  # TODO: the top of the stack — first row, because the top is drawn at the top.
  v3: 9 { class: [cell; current] }
  t3: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }

  v2: 4 { class: cell }
  t2 { class: ghost }

  v1: 7 { class: cell }
  t1 { class: ghost }

  v0: 2 { class: cell }
  t0: "◀ bottom" { class: tick; width: 110 }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

st: "stack · top = 9" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  # TODO: the top of the stack — first row, because the top is drawn at the top.
  v3: 9 { class: [cell; current] }
  t3: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }

  v2: 4 { class: cell }
  t2 { class: ghost }

  v1: 7 { class: cell }
  t1 { class: ghost }

  v0: 2 { class: cell }
  t0: "◀ bottom" { class: tick; width: 110 }
}
```

### Push

Everything below the top is untouched — that is the whole claim a stack makes, and two panels prove
it at a glance.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · top = 4" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  b3 { class: ghost }
  bt3 { class: ghost }
  v2: 4 { class: [cell; current] }
  t2: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }
  v1: 7 { class: cell }
  t1 { class: ghost }
  v0: 2 { class: cell }
  t0 { class: ghost }
}

after: "after · top = 9" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  # TODO: the pushed value.
  v3: 9 { class: [cell; current] }
  t3: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }
  v2: 4 { class: [cell; visited] }
  t2 { class: ghost }
  v1: 7 { class: cell }
  t1 { class: ghost }
  v0: 2 { class: cell }
  t0 { class: ghost }
}

before -> after: "push 9" { class: step }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before · top = 4" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  b3 { class: ghost }
  bt3 { class: ghost }
  v2: 4 { class: [cell; current] }
  t2: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }
  v1: 7 { class: cell }
  t1 { class: ghost }
  v0: 2 { class: cell }
  t0 { class: ghost }
}

after: "after · top = 9" { class: panel
  grid-rows: 4
  grid-columns: 2
  grid-gap: 0

  # TODO: the pushed value.
  v3: 9 { class: [cell; current] }
  t3: "◀ top" { class: tick; width: 110; style.font-color: "#ca8a04" }
  v2: 4 { class: [cell; visited] }
  t2 { class: ghost }
  v1: 7 { class: cell }
  t1 { class: ghost }
  v0: 2 { class: cell }
  t0 { class: ghost }
}

before -> after: "push 9" { class: step }
```

### Queue

Horizontal, head left, work flowing right. Reserving the vertical column for stacks is what stops
the two blurring together in a lesson that uses both.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

q: "queue · 4 waiting" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  # TODO: the entries, oldest first.
  v0: A { class: [cell; current] }
  v1: B { class: cell }
  v2: C { class: cell }
  v3: D { class: cell }
  v4: "" { class: [cell; cold] }
  v5: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0: "▲ head" { class: tick; style.font-color: "#ca8a04" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ tail" { class: tick; style.font-color: "#0284c7" }
  p5 { class: ghost }
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
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

q: "queue · 4 waiting" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  # TODO: the entries, oldest first.
  v0: A { class: [cell; current] }
  v1: B { class: cell }
  v2: C { class: cell }
  v3: D { class: cell }
  v4: "" { class: [cell; cold] }
  v5: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  p0: "▲ head" { class: tick; style.font-color: "#ca8a04" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "▲ tail" { class: tick; style.font-color: "#0284c7" }
  p5 { class: ghost }
}
```

### Deque

A deque *is* its four operations, so the four operations are the labels.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

dq: "deque · push and pop at either end" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: A { class: [cell; active] }
  v1: B { class: cell }
  v2: C { class: cell }
  v3: D { class: cell }
  v4: E { class: [cell; active] }
  v5: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  # TODO: the four operations, parked under the ends they act on.
  p0: "push_front\npop_front" { class: tick; style.font-color: "#16a34a" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "push_back\npop_back" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
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
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

dq: "deque · push and pop at either end" { class: panel
  grid-rows: 3
  grid-columns: 6
  grid-gap: 0

  v0: A { class: [cell; active] }
  v1: B { class: cell }
  v2: C { class: cell }
  v3: D { class: cell }
  v4: E { class: [cell; active] }
  v5: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }

  # TODO: the four operations, parked under the ends they act on.
  p0: "push_front\npop_front" { class: tick; style.font-color: "#16a34a" }
  p1 { class: ghost }
  p2 { class: ghost }
  p3 { class: ghost }
  p4: "push_back\npop_back" { class: tick; style.font-color: "#16a34a" }
  p5 { class: ghost }
}
```

### Circular buffer

Drawn straight rather than as a ring. The wrap is easier to believe when you can see `tail` sitting
to the left of `head` with the filled cells split across the ends.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

cb: "capacity 8 · 5 items · tail has wrapped past the end" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: the filled cells. Here they run 5,6,7 then wrap to 0,1.
  v0: R { class: [cell; active] }
  v1: S { class: [cell; active] }
  v2: "" { class: [cell; cold] }
  v3: "" { class: [cell; cold] }
  v4: "" { class: [cell; cold] }
  v5: O { class: [cell; active] }
  v6: P { class: [cell; active] }
  v7: Q { class: [cell; active] }

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
  p2: "▲ tail\n(next write)" { class: tick; style.font-color: "#0284c7" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ head\n(next read)" { class: tick; style.font-color: "#ca8a04" }
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
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

cb: "capacity 8 · 5 items · tail has wrapped past the end" { class: panel
  grid-rows: 3
  grid-columns: 8
  grid-gap: 0

  # TODO: the filled cells. Here they run 5,6,7 then wrap to 0,1.
  v0: R { class: [cell; active] }
  v1: S { class: [cell; active] }
  v2: "" { class: [cell; cold] }
  v3: "" { class: [cell; cold] }
  v4: "" { class: [cell; cold] }
  v5: O { class: [cell; active] }
  v6: P { class: [cell; active] }
  v7: Q { class: [cell; active] }

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
  p2: "▲ tail\n(next write)" { class: tick; style.font-color: "#0284c7" }
  p3 { class: ghost }
  p4 { class: ghost }
  p5: "▲ head\n(next read)" { class: tick; style.font-color: "#ca8a04" }
  p6 { class: ghost }
  p7 { class: ghost }
}
```

## Linked lists

Draw the null terminator. Half of all list bugs live at the end of the list, and a picture that stops
at the last node quietly suggests there is nothing there to get wrong.

```bash
classes: {
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

head: head { class: tick; width: 70; style.font-color: "#ca8a04" }
n0: 3 { class: node }
n1: 7 { class: node }
n2: 1 { class: node }
n3: 9 { class: node }
nil: "∅" { class: [node; cold] }

head -> n0: { class: hint }
n0 -> n1 -> n2 -> n3 -> nil
```

```d2
classes: {
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

head: head { class: tick; width: 70; style.font-color: "#ca8a04" }
n0: 3 { class: node }
n1: 7 { class: node }
n2: 1 { class: node }
n3: 9 { class: node }
nil: "∅" { class: [node; cold] }

head -> n0: { class: hint }
n0 -> n1 -> n2 -> n3 -> nil
```

### Splicing a node in

Both pointer writes, numbered, because the order of them is the bug.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before" { class: panel
  direction: right
  a0: 3 { class: node }
  a1: 7 { class: [node; current] }
  a2: 1 { class: node }
  a0 -> a1 -> a2
}

after: "after" { class: panel
  direction: right
  b0: 3 { class: node }
  b1: 7 { class: [node; current] }
  # TODO: the spliced node.
  bx: 5 { class: [node; active] }
  b2: 1 { class: node }
  b0 -> b1
  b1 -> bx: "2. n1.next" { class: step; style.stroke: "#ca8a04" }
  bx -> b2: "1. new.next" { class: step; style.stroke: "#16a34a" }
}

before -> after: "insert 5\nafter n1" { class: step }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: right

before: "before" { class: panel
  direction: right
  a0: 3 { class: node }
  a1: 7 { class: [node; current] }
  a2: 1 { class: node }
  a0 -> a1 -> a2
}

after: "after" { class: panel
  direction: right
  b0: 3 { class: node }
  b1: 7 { class: [node; current] }
  # TODO: the spliced node.
  bx: 5 { class: [node; active] }
  b2: 1 { class: node }
  b0 -> b1
  b1 -> bx: "2. n1.next" { class: step; style.stroke: "#ca8a04" }
  bx -> b2: "1. new.next" { class: step; style.stroke: "#16a34a" }
}

before -> after: "insert 5\nafter n1" { class: step }
```

### Doubly linked

Two chains over the same nodes. The cost a doubly linked list charges is exactly this: every
structural change has to fix both, and the second one is the one people forget.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

n0: 3 { class: node }
n1: 7 { class: node }
n2: 1 { class: node }
nil_r: "∅" { class: [node; cold] }

n0 -> n1: next
n1 -> n2: next
n2 -> nil_r: next

n1 -> n0: prev { class: hint }
n2 -> n1: prev { class: hint }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

n0: 3 { class: node }
n1: 7 { class: node }
n2: 1 { class: node }
nil_r: "∅" { class: [node; cold] }

n0 -> n1: next
n1 -> n2: next
n2 -> nil_r: next

n1 -> n0: prev { class: hint }
n2 -> n1: prev { class: hint }
```

### A cycle

The shape the problem is named after. Marking the entry node is what makes the second half of Floyd's
algorithm worth explaining.

```bash
classes: {
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
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
# TODO: the node the cycle re-enters — what phase two of Floyd's algorithm returns.
n3: 3 { class: [node; current] }
n4: 4 { class: node }
# TODO: where slow and fast collide.
n5: 5 { class: [node; active] }
n6: 6 { class: node }

n1 -> n2 -> n3 -> n4 -> n5 -> n6
n6 -> n3: "loops back" { class: step; style.stroke: "#dc2626" }

entry: "cycle entry" { class: tick; width: 110; style.font-color: "#ca8a04" }
meet: "slow meets fast" { class: tick; width: 130; style.font-color: "#16a34a" }
entry -> n3: { class: hint }
meet -> n5: { class: hint }
```

```d2
classes: {
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
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
# TODO: the node the cycle re-enters — what phase two of Floyd's algorithm returns.
n3: 3 { class: [node; current] }
n4: 4 { class: node }
# TODO: where slow and fast collide.
n5: 5 { class: [node; active] }
n6: 6 { class: node }

n1 -> n2 -> n3 -> n4 -> n5 -> n6
n6 -> n3: "loops back" { class: step; style.stroke: "#dc2626" }

entry: "cycle entry" { class: tick; width: 110; style.font-color: "#ca8a04" }
meet: "slow meets fast" { class: tick; width: 130; style.font-color: "#16a34a" }
entry -> n3: { class: hint }
meet -> n5: { class: hint }
```

## Hash tables

Empty buckets are drawn, not omitted — the ratio of empty to occupied *is* the load factor.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

b0: "0" { class: cell }
b1: "1" { class: cell }
b2: "2" { class: cell }
b3: "3" { class: cell }
b4: "4" { class: cell }

# TODO: the collision — two keys landing in one bucket is the case worth drawing.
b1 -> k_ada: { class: hint }
k_ada: "\"ada\" → 41" { class: [node; hot]; width: 120 }
k_ada -> k_bob: { class: hint }
k_bob: "\"bob\" → 7" { class: [node; hot]; width: 120 }

b3 -> k_cy: { class: hint }
k_cy: "\"cy\" → 19" { class: node; width: 120 }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

b0: "0" { class: cell }
b1: "1" { class: cell }
b2: "2" { class: cell }
b3: "3" { class: cell }
b4: "4" { class: cell }

# TODO: the collision — two keys landing in one bucket is the case worth drawing.
b1 -> k_ada: { class: hint }
k_ada: "\"ada\" → 41" { class: [node; hot]; width: 120 }
k_ada -> k_bob: { class: hint }
k_bob: "\"bob\" → 7" { class: [node; hot]; width: 120 }

b3 -> k_cy: { class: hint }
k_cy: "\"cy\" → 19" { class: node; width: 120 }
```

### Open addressing

No chains: a collision walks forward, so the table is the strip. The probe count is on the caption
row because that is the number which degrades — and it degrades sharply, not gradually.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  tick: { style: { fill: transparent; stroke-width: 0; font-size: 14; font-color: "#0f172a" }; width: 64 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

oa: "insert \"cy\" · h(\"cy\") = 1 · 2 probes" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: "" { class: [cell; cold] }
  # TODO: the home slot — occupied, so the probe walks on.
  v1: ada { class: [cell; hot] }
  v2: bob { class: [cell; hot] }
  # TODO: where it lands.
  v3: cy { class: [cell; current] }
  v4: "" { class: [cell; cold] }
  v5: dee { class: cell }
  v6: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1: "probe 1\ntaken" { class: tick; style.font-color: "#ea580c" }
  p2: "probe 2\ntaken" { class: tick; style.font-color: "#ea580c" }
  p3: "probe 3\nfree ✓" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
  p6 { class: ghost }
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
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

oa: "insert \"cy\" · h(\"cy\") = 1 · 2 probes" { class: panel
  grid-rows: 3
  grid-columns: 7
  grid-gap: 0

  v0: "" { class: [cell; cold] }
  # TODO: the home slot — occupied, so the probe walks on.
  v1: ada { class: [cell; hot] }
  v2: bob { class: [cell; hot] }
  # TODO: where it lands.
  v3: cy { class: [cell; current] }
  v4: "" { class: [cell; cold] }
  v5: dee { class: cell }
  v6: "" { class: [cell; cold] }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }

  p0 { class: ghost }
  p1: "probe 1\ntaken" { class: tick; style.font-color: "#ea580c" }
  p2: "probe 2\ntaken" { class: tick; style.font-color: "#ea580c" }
  p3: "probe 3\nfree ✓" { class: tick; style.font-color: "#16a34a" }
  p4 { class: ghost }
  p5 { class: ghost }
  p6 { class: ghost }
}
```

## Intervals

One row per interval, one column per time unit, so an overlap is a column with two filled cells in
it. Sorting the rows by start time is not cosmetic: every interval algorithm assumes it.

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

tl: "sorted by start · B and C overlap at t=4" { class: panel
  grid-rows: 5
  grid-columns: 9
  grid-gap: 0

  # ── A = [0, 3)
  la: A { class: tick; width: 40 }
  a0: "" { class: [cell; active] }
  a1: "" { class: [cell; active] }
  a2: "" { class: [cell; active] }
  a3 { class: ghost }
  a4 { class: ghost }
  a5 { class: ghost }
  a6 { class: ghost }
  a7 { class: ghost }

  # ── B = [2, 5)
  lb: B { class: tick; width: 40 }
  b0 { class: ghost }
  b1 { class: ghost }
  b2: "" { class: [cell; active] }
  b3: "" { class: [cell; active] }
  # TODO: the overlapping cell — the one the sweep has to notice.
  b4: "" { class: [cell; current] }
  b5 { class: ghost }
  b6 { class: ghost }
  b7 { class: ghost }

  # ── C = [4, 7)
  lc: C { class: tick; width: 40 }
  c0 { class: ghost }
  c1 { class: ghost }
  c2 { class: ghost }
  c3 { class: ghost }
  c4: "" { class: [cell; current] }
  c5: "" { class: [cell; active] }
  c6: "" { class: [cell; active] }
  c7 { class: ghost }

  # ── D = [7, 8)
  ld: D { class: tick; width: 40 }
  d0 { class: ghost }
  d1 { class: ghost }
  d2 { class: ghost }
  d3 { class: ghost }
  d4 { class: ghost }
  d5 { class: ghost }
  d6 { class: ghost }
  d7: "" { class: [cell; active] }

  lt { class: ghost; width: 40 }
  t0: 0 { class: idx }
  t1: 1 { class: idx }
  t2: 2 { class: idx }
  t3: 3 { class: idx }
  t4: 4 { class: idx }
  t5: 5 { class: idx }
  t6: 6 { class: idx }
  t7: 7 { class: idx }
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

tl: "sorted by start · B and C overlap at t=4" { class: panel
  grid-rows: 5
  grid-columns: 9
  grid-gap: 0

  # ── A = [0, 3)
  la: A { class: tick; width: 40 }
  a0: "" { class: [cell; active] }
  a1: "" { class: [cell; active] }
  a2: "" { class: [cell; active] }
  a3 { class: ghost }
  a4 { class: ghost }
  a5 { class: ghost }
  a6 { class: ghost }
  a7 { class: ghost }

  # ── B = [2, 5)
  lb: B { class: tick; width: 40 }
  b0 { class: ghost }
  b1 { class: ghost }
  b2: "" { class: [cell; active] }
  b3: "" { class: [cell; active] }
  # TODO: the overlapping cell — the one the sweep has to notice.
  b4: "" { class: [cell; current] }
  b5 { class: ghost }
  b6 { class: ghost }
  b7 { class: ghost }

  # ── C = [4, 7)
  lc: C { class: tick; width: 40 }
  c0 { class: ghost }
  c1 { class: ghost }
  c2 { class: ghost }
  c3 { class: ghost }
  c4: "" { class: [cell; current] }
  c5: "" { class: [cell; active] }
  c6: "" { class: [cell; active] }
  c7 { class: ghost }

  # ── D = [7, 8)
  ld: D { class: tick; width: 40 }
  d0 { class: ghost }
  d1 { class: ghost }
  d2 { class: ghost }
  d3 { class: ghost }
  d4 { class: ghost }
  d5 { class: ghost }
  d6 { class: ghost }
  d7: "" { class: [cell; active] }

  lt { class: ghost; width: 40 }
  t0: 0 { class: idx }
  t1: 1 { class: idx }
  t2: 2 { class: idx }
  t3: 3 { class: idx }
  t4: 4 { class: idx }
  t5: 5 { class: idx }
  t6: 6 { class: idx }
  t7: 7 { class: idx }
}
```

---

Next: [trees, heaps and range structures](/synapse/synapse-features/d2-component-library/dsa-trees-and-heaps).
