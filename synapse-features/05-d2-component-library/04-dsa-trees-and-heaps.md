---
title: "DSA blocks — trees, heaps and range structures"
summary: "Copy-and-adapt D2 templates for binary trees, BSTs with a search path, heaps drawn both as a tree and as their backing array, tries, segment trees and the Fenwick coverage map."
---

# DSA blocks — trees, heaps and range structures

The branching structures. Files live under `synapse-features/_d2-blocks/dsa/`.

One layout rule matters more here than anywhere else: **ELK ignores `direction` on a nested
container** — every container draws in the root's direction. A two-panel figure holding trees
therefore sets `direction: down` at the root and stacks its panels. `dsa/bst-step.d2` below is the
worked example.

## Binary tree

Draw the missing child as an explicit ∅ wherever the lesson turns on it. A tree drawn with only its
real children looks balanced even when it is not, and "looks balanced" is the misconception most tree
lessons are fighting.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

direction: down

r: 8 { class: [node; current] }
a: 3 { class: node }
b: 10 { class: node }
c: 1 { class: node }
d: 6 { class: node }
# TODO: an explicit hole, where the shape of the tree is the point.
e: "∅" { class: [node; cold] }
f: 14 { class: node }

r -> a
r -> b
a -> c
a -> d
b -> e
b -> f
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

direction: down

r: 8 { class: [node; current] }
a: 3 { class: node }
b: 10 { class: node }
c: 1 { class: node }
d: 6 { class: node }
# TODO: an explicit hole, where the shape of the tree is the point.
e: "∅" { class: [node; cold] }
f: 14 { class: node }

r -> a
r -> b
a -> c
a -> d
b -> e
b -> f
```

## Binary search tree

What is worth showing is not the search path but the subtrees it never looked at. Those are the
`pruned` ones, and they are where the log *n* comes from.

The comparisons live in the title rather than on the edges: a labelled edge makes ELK stretch the
level it sits on, and the tree stops looking like a tree.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

title: "search 6  ·  8 → 3 → 6  ·  everything red was never visited" {
  near: top-center
  shape: text
  style: { font-size: 16; font-color: "#475569" }
}

# TODO: the nodes actually compared.
r: 8 { class: [node; current] }
a: 3 { class: [node; current] }
d: 6 { class: [node; active] }
# TODO: the subtrees the invariant let it skip.
b: 10 { class: [node; pruned] }
c: 1 { class: [node; pruned] }
f: 14 { class: [node; pruned] }

r -> a: { class: step; style.stroke: "#ca8a04" }
a -> d: { class: step; style.stroke: "#ca8a04" }
r -> b: { class: hint }
a -> c: { class: hint }
b -> f: { class: hint }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

title: "search 6  ·  8 → 3 → 6  ·  everything red was never visited" {
  near: top-center
  shape: text
  style: { font-size: 16; font-color: "#475569" }
}

# TODO: the nodes actually compared.
r: 8 { class: [node; current] }
a: 3 { class: [node; current] }
d: 6 { class: [node; active] }
# TODO: the subtrees the invariant let it skip.
b: 10 { class: [node; pruned] }
c: 1 { class: [node; pruned] }
f: 14 { class: [node; pruned] }

r -> a: { class: step; style.stroke: "#ca8a04" }
a -> d: { class: step; style.stroke: "#ca8a04" }
r -> b: { class: hint }
a -> c: { class: hint }
b -> f: { class: hint }
```

### Insert

A new key always lands as a leaf — it never displaces anything. Note the vertical stacking; this is
the nested-`direction` rule in action.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: down

before: "before · insert 5" { class: panel
  r: 8 { class: [node; current] }
  a: 3 { class: [node; current] }
  b: 10 { class: node }
  d: 6 { class: [node; current] }
  r -> a
  r -> b
  a -> d
}

after: "after · 5 hangs off 6 as a leaf" { class: panel
  r2: 8 { class: node }
  a2: 3 { class: node }
  b2: 10 { class: node }
  d2: 6 { class: node }
  # TODO: the new key — always a leaf.
  n2: 5 { class: [node; active] }
  r2 -> a2
  r2 -> b2
  a2 -> d2
  d2 -> n2
}

before -> after: "5 < 8 → left\n5 > 3 → right\n5 < 6 → left" { class: step }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: down

before: "before · insert 5" { class: panel
  r: 8 { class: [node; current] }
  a: 3 { class: [node; current] }
  b: 10 { class: node }
  d: 6 { class: [node; current] }
  r -> a
  r -> b
  a -> d
}

after: "after · 5 hangs off 6 as a leaf" { class: panel
  r2: 8 { class: node }
  a2: 3 { class: node }
  b2: 10 { class: node }
  d2: 6 { class: node }
  # TODO: the new key — always a leaf.
  n2: 5 { class: [node; active] }
  r2 -> a2
  r2 -> b2
  a2 -> d2
  d2 -> n2
}

before -> after: "5 < 8 → left\n5 > 3 → right\n5 < 6 → left" { class: step }
```

## Heaps

The only invariant is parent ≤ child. Note what is *not* claimed: siblings are unordered and a level
is not sorted. Readers who have only seen a BST assume both.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

direction: down

r: 2 { class: [node; current] }
a: 4 { class: node }
b: 7 { class: node }
c: 9 { class: node }
d: 5 { class: node }
e: 8 { class: node }
f: 11 { class: node }

r -> a
r -> b
a -> c
a -> d
b -> e
b -> f
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

direction: down

r: 2 { class: [node; current] }
a: 4 { class: node }
b: 7 { class: node }
c: 9 { class: node }
d: 5 { class: node }
e: 8 { class: node }
f: 11 { class: node }

r -> a
r -> b
a -> c
a -> d
b -> e
b -> f
```

### And as its backing array

The same heap twice, each node carrying its index so a reader can check the arithmetic themselves.
The arithmetic is the trick — it is what lets a tree live in a contiguous block with no pointers.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

tree: "the tree it behaves like" { class: panel
  direction: down
  r: "2\n[0]" { class: [node; current]; height: 62 }
  a: "4\n[1]" { class: node; height: 62 }
  b: "7\n[2]" { class: node; height: 62 }
  c: "9\n[3]" { class: node; height: 62 }
  d: "5\n[4]" { class: node; height: 62 }
  e: "8\n[5]" { class: node; height: 62 }
  f: "11\n[6]" { class: node; height: 62 }
  r -> a
  r -> b
  a -> c
  a -> d
  b -> e
  b -> f
}

arr: "the array it actually is · left(i)=2i+1, right(i)=2i+2" { class: panel
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0

  v0: 2  { class: [cell; current] }
  v1: 4  { class: cell }
  v2: 7  { class: cell }
  v3: 9  { class: cell }
  v4: 5  { class: cell }
  v5: 8  { class: cell }
  v6: 11 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
}

tree -> arr: "same seven numbers,\nno pointers" { class: hint }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

tree: "the tree it behaves like" { class: panel
  direction: down
  r: "2\n[0]" { class: [node; current]; height: 62 }
  a: "4\n[1]" { class: node; height: 62 }
  b: "7\n[2]" { class: node; height: 62 }
  c: "9\n[3]" { class: node; height: 62 }
  d: "5\n[4]" { class: node; height: 62 }
  e: "8\n[5]" { class: node; height: 62 }
  f: "11\n[6]" { class: node; height: 62 }
  r -> a
  r -> b
  a -> c
  a -> d
  b -> e
  b -> f
}

arr: "the array it actually is · left(i)=2i+1, right(i)=2i+2" { class: panel
  grid-rows: 2
  grid-columns: 7
  grid-gap: 0

  v0: 2  { class: [cell; current] }
  v1: 4  { class: cell }
  v2: 7  { class: cell }
  v3: 9  { class: cell }
  v4: 5  { class: cell }
  v5: 8  { class: cell }
  v6: 11 { class: cell }

  i0: 0 { class: idx }
  i1: 1 { class: idx }
  i2: 2 { class: idx }
  i3: 3 { class: idx }
  i4: 4 { class: idx }
  i5: 5 { class: idx }
  i6: 6 { class: idx }
}

tree -> arr: "same seven numbers,\nno pointers" { class: hint }
```

## Trie

One character per **edge**, not per node — a node in a trie is a prefix, not a letter. Terminal nodes
are marked, since "cat" being a word while "ca" is not is otherwise invisible.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

direction: right

root: "root\n(\"\")" { class: [node; cold]; width: 70 }
c: "c" { class: node; width: 44 }
ca: "ca" { class: node; width: 44 }
# TODO: terminal nodes — a stored word ends here.
cat: "cat ●" { class: [node; active]; width: 58 }
car: "car ●" { class: [node; active]; width: 58 }
card: "card ●" { class: [node; active]; width: 66 }
d: "d" { class: node; width: 44 }
do: "do ●" { class: [node; active]; width: 52 }

root -> c: c
c -> ca: a
ca -> cat: t
ca -> car: r
car -> card: d
root -> d: d
d -> do: o
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

direction: right

root: "root\n(\"\")" { class: [node; cold]; width: 70 }
c: "c" { class: node; width: 44 }
ca: "ca" { class: node; width: 44 }
# TODO: terminal nodes — a stored word ends here.
cat: "cat ●" { class: [node; active]; width: 58 }
car: "car ●" { class: [node; active]; width: 58 }
card: "card ●" { class: [node; active]; width: 66 }
d: "d" { class: node; width: 44 }
do: "do ●" { class: [node; active]; width: 52 }

root -> c: c
c -> ca: a
ca -> cat: t
ca -> car: r
car -> card: d
root -> d: d
d -> do: o
```

## Segment tree

Label both the range and the value. A segment tree drawn with only values looks like a heap, and it
is not one. Draw a query too: the shape of the answer is the interesting part.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

direction: down

root: "[0,5]\nsum 42" { class: node; width: 76; height: 62 }
l: "[0,2]\nsum 14" { class: node; width: 76; height: 62 }
r: "[3,5]\nsum 28" { class: node; width: 76; height: 62 }

ll: "[0,1]\nsum 9" { class: node; width: 76; height: 62 }
lr: "[2,2]\n5" { class: [node; active]; width: 76; height: 62 }
rl: "[3,4]\nsum 19" { class: [node; active]; width: 76; height: 62 }
rr: "[5,5]\n9" { class: node; width: 76; height: 62 }

root -> l
root -> r
l -> ll
l -> lr
r -> rl
r -> rr

note: "query sum[2,4] = 5 + 19 = 24 — two nodes, not three leaves" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#16a34a" }
}
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

direction: down

root: "[0,5]\nsum 42" { class: node; width: 76; height: 62 }
l: "[0,2]\nsum 14" { class: node; width: 76; height: 62 }
r: "[3,5]\nsum 28" { class: node; width: 76; height: 62 }

ll: "[0,1]\nsum 9" { class: node; width: 76; height: 62 }
lr: "[2,2]\n5" { class: [node; active]; width: 76; height: 62 }
rl: "[3,4]\nsum 19" { class: [node; active]; width: 76; height: 62 }
rr: "[5,5]\n9" { class: node; width: 76; height: 62 }

root -> l
root -> r
l -> ll
l -> lr
r -> rl
r -> rr

note: "query sum[2,4] = 5 + 19 = 24 — two nodes, not three leaves" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#16a34a" }
}
```

## Fenwick tree

The coverage map, and the only figure that makes a Fenwick tree make sense. There is no tree in
memory — only an array whose indices describe one. Powers of two reach furthest; every odd index
covers only itself.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

fw: "tree[i] covers (i − lowbit(i), i]  ·  prefix(6) = tree[6] + tree[4]" { class: panel
  grid-rows: 9
  grid-columns: 9
  grid-gap: 0

  hh: "i \\ pos" { class: idx; width: 84; height: 40 }
  h1: 1 { class: idx; height: 40 }
  h2: 2 { class: idx; height: 40 }
  h3: 3 { class: idx; height: 40 }
  h4: 4 { class: idx; height: 40 }
  h5: 5 { class: idx; height: 40 }
  h6: 6 { class: idx; height: 40 }
  h7: 7 { class: idx; height: 40 }
  h8: 8 { class: idx; height: 40 }

  r1: "tree[1]" { class: idx; width: 84; height: 40 }
  a11: "" { class: [cell; active]; height: 40 }
  a12 { class: ghost; height: 40 }
  a13 { class: ghost; height: 40 }
  a14 { class: ghost; height: 40 }
  a15 { class: ghost; height: 40 }
  a16 { class: ghost; height: 40 }
  a17 { class: ghost; height: 40 }
  a18 { class: ghost; height: 40 }

  r2: "tree[2]" { class: idx; width: 84; height: 40 }
  a21: "" { class: [cell; active]; height: 40 }
  a22: "" { class: [cell; active]; height: 40 }
  a23 { class: ghost; height: 40 }
  a24 { class: ghost; height: 40 }
  a25 { class: ghost; height: 40 }
  a26 { class: ghost; height: 40 }
  a27 { class: ghost; height: 40 }
  a28 { class: ghost; height: 40 }

  r3: "tree[3]" { class: idx; width: 84; height: 40 }
  a31 { class: ghost; height: 40 }
  a32 { class: ghost; height: 40 }
  a33: "" { class: [cell; active]; height: 40 }
  a34 { class: ghost; height: 40 }
  a35 { class: ghost; height: 40 }
  a36 { class: ghost; height: 40 }
  a37 { class: ghost; height: 40 }
  a38 { class: ghost; height: 40 }

  # TODO: the rows a prefix query lands on — here prefix(6) = tree[6] + tree[4].
  r4: "tree[4]" { class: idx; width: 84; height: 40 }
  a41: "" { class: [cell; current]; height: 40 }
  a42: "" { class: [cell; current]; height: 40 }
  a43: "" { class: [cell; current]; height: 40 }
  a44: "" { class: [cell; current]; height: 40 }
  a45 { class: ghost; height: 40 }
  a46 { class: ghost; height: 40 }
  a47 { class: ghost; height: 40 }
  a48 { class: ghost; height: 40 }

  r5: "tree[5]" { class: idx; width: 84; height: 40 }
  a51 { class: ghost; height: 40 }
  a52 { class: ghost; height: 40 }
  a53 { class: ghost; height: 40 }
  a54 { class: ghost; height: 40 }
  a55: "" { class: [cell; active]; height: 40 }
  a56 { class: ghost; height: 40 }
  a57 { class: ghost; height: 40 }
  a58 { class: ghost; height: 40 }

  r6: "tree[6]" { class: idx; width: 84; height: 40 }
  a61 { class: ghost; height: 40 }
  a62 { class: ghost; height: 40 }
  a63 { class: ghost; height: 40 }
  a64 { class: ghost; height: 40 }
  a65: "" { class: [cell; current]; height: 40 }
  a66: "" { class: [cell; current]; height: 40 }
  a67 { class: ghost; height: 40 }
  a68 { class: ghost; height: 40 }

  r7: "tree[7]" { class: idx; width: 84; height: 40 }
  a71 { class: ghost; height: 40 }
  a72 { class: ghost; height: 40 }
  a73 { class: ghost; height: 40 }
  a74 { class: ghost; height: 40 }
  a75 { class: ghost; height: 40 }
  a76 { class: ghost; height: 40 }
  a77: "" { class: [cell; active]; height: 40 }
  a78 { class: ghost; height: 40 }

  r8: "tree[8]" { class: idx; width: 84; height: 40 }
  a81: "" { class: [cell; active]; height: 40 }
  a82: "" { class: [cell; active]; height: 40 }
  a83: "" { class: [cell; active]; height: 40 }
  a84: "" { class: [cell; active]; height: 40 }
  a85: "" { class: [cell; active]; height: 40 }
  a86: "" { class: [cell; active]; height: 40 }
  a87: "" { class: [cell; active]; height: 40 }
  a88: "" { class: [cell; active]; height: 40 }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  ghost: { label: ""; style: { fill: transparent; stroke-width: 0 }; width: 64; height: 28 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
}

fw: "tree[i] covers (i − lowbit(i), i]  ·  prefix(6) = tree[6] + tree[4]" { class: panel
  grid-rows: 9
  grid-columns: 9
  grid-gap: 0

  hh: "i \\ pos" { class: idx; width: 84; height: 40 }
  h1: 1 { class: idx; height: 40 }
  h2: 2 { class: idx; height: 40 }
  h3: 3 { class: idx; height: 40 }
  h4: 4 { class: idx; height: 40 }
  h5: 5 { class: idx; height: 40 }
  h6: 6 { class: idx; height: 40 }
  h7: 7 { class: idx; height: 40 }
  h8: 8 { class: idx; height: 40 }

  r1: "tree[1]" { class: idx; width: 84; height: 40 }
  a11: "" { class: [cell; active]; height: 40 }
  a12 { class: ghost; height: 40 }
  a13 { class: ghost; height: 40 }
  a14 { class: ghost; height: 40 }
  a15 { class: ghost; height: 40 }
  a16 { class: ghost; height: 40 }
  a17 { class: ghost; height: 40 }
  a18 { class: ghost; height: 40 }

  r2: "tree[2]" { class: idx; width: 84; height: 40 }
  a21: "" { class: [cell; active]; height: 40 }
  a22: "" { class: [cell; active]; height: 40 }
  a23 { class: ghost; height: 40 }
  a24 { class: ghost; height: 40 }
  a25 { class: ghost; height: 40 }
  a26 { class: ghost; height: 40 }
  a27 { class: ghost; height: 40 }
  a28 { class: ghost; height: 40 }

  r3: "tree[3]" { class: idx; width: 84; height: 40 }
  a31 { class: ghost; height: 40 }
  a32 { class: ghost; height: 40 }
  a33: "" { class: [cell; active]; height: 40 }
  a34 { class: ghost; height: 40 }
  a35 { class: ghost; height: 40 }
  a36 { class: ghost; height: 40 }
  a37 { class: ghost; height: 40 }
  a38 { class: ghost; height: 40 }

  # TODO: the rows a prefix query lands on — here prefix(6) = tree[6] + tree[4].
  r4: "tree[4]" { class: idx; width: 84; height: 40 }
  a41: "" { class: [cell; current]; height: 40 }
  a42: "" { class: [cell; current]; height: 40 }
  a43: "" { class: [cell; current]; height: 40 }
  a44: "" { class: [cell; current]; height: 40 }
  a45 { class: ghost; height: 40 }
  a46 { class: ghost; height: 40 }
  a47 { class: ghost; height: 40 }
  a48 { class: ghost; height: 40 }

  r5: "tree[5]" { class: idx; width: 84; height: 40 }
  a51 { class: ghost; height: 40 }
  a52 { class: ghost; height: 40 }
  a53 { class: ghost; height: 40 }
  a54 { class: ghost; height: 40 }
  a55: "" { class: [cell; active]; height: 40 }
  a56 { class: ghost; height: 40 }
  a57 { class: ghost; height: 40 }
  a58 { class: ghost; height: 40 }

  r6: "tree[6]" { class: idx; width: 84; height: 40 }
  a61 { class: ghost; height: 40 }
  a62 { class: ghost; height: 40 }
  a63 { class: ghost; height: 40 }
  a64 { class: ghost; height: 40 }
  a65: "" { class: [cell; current]; height: 40 }
  a66: "" { class: [cell; current]; height: 40 }
  a67 { class: ghost; height: 40 }
  a68 { class: ghost; height: 40 }

  r7: "tree[7]" { class: idx; width: 84; height: 40 }
  a71 { class: ghost; height: 40 }
  a72 { class: ghost; height: 40 }
  a73 { class: ghost; height: 40 }
  a74 { class: ghost; height: 40 }
  a75 { class: ghost; height: 40 }
  a76 { class: ghost; height: 40 }
  a77: "" { class: [cell; active]; height: 40 }
  a78 { class: ghost; height: 40 }

  r8: "tree[8]" { class: idx; width: 84; height: 40 }
  a81: "" { class: [cell; active]; height: 40 }
  a82: "" { class: [cell; active]; height: 40 }
  a83: "" { class: [cell; active]; height: 40 }
  a84: "" { class: [cell; active]; height: 40 }
  a85: "" { class: [cell; active]; height: 40 }
  a86: "" { class: [cell; active]; height: 40 }
  a87: "" { class: [cell; active]; height: 40 }
  a88: "" { class: [cell; active]; height: 40 }
}
```

---

Next: [graphs and traversal](/synapse/synapse-features/d2-component-library/dsa-graphs).
