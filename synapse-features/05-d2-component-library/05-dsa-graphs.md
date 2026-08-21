---
title: "DSA blocks — graphs and traversal"
summary: "Copy-and-adapt D2 templates for graphs as nodes and edges, adjacency lists and matrices, weighted edges, BFS level layers, DFS with backtracking, topological order and the union-find forest."
---

# DSA blocks — graphs and traversal

Three representations and four traversals. Files live under `synapse-features/_d2-blocks/dsa/`.

## Nodes and edges

Directed and undirected side by side, because the difference is one arrowhead and it is worth
checking which one a problem actually handed you.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
}

direction: right

undirected: "undirected · edges have no side" { class: panel
  a: A { class: node; shape: circle }
  b: B { class: node; shape: circle }
  c: C { class: node; shape: circle }
  d: D { class: node; shape: circle }
  a -- b
  a -- c
  b -- d
  c -- d
}

directed: "directed · A→B does not give B→A" { class: panel
  x: A { class: node; shape: circle }
  y: B { class: node; shape: circle }
  z: C { class: node; shape: circle }
  w: D { class: node; shape: circle }
  x -> y
  x -> z
  y -> w
  z -> w
}
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
}

direction: right

undirected: "undirected · edges have no side" { class: panel
  a: A { class: node; shape: circle }
  b: B { class: node; shape: circle }
  c: C { class: node; shape: circle }
  d: D { class: node; shape: circle }
  a -- b
  a -- c
  b -- d
  c -- d
}

directed: "directed · A→B does not give B→A" { class: panel
  x: A { class: node; shape: circle }
  y: B { class: node; shape: circle }
  z: C { class: node; shape: circle }
  w: D { class: node; shape: circle }
  x -> y
  x -> z
  y -> w
  z -> w
}
```

### Weighted

Draw a shortest path whose hop count is *not* the smallest. A figure where fewest-hops happens to win
teaches the wrong reflex.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

a: A { class: [node; current]; shape: circle }
b: B { class: node; shape: circle }
c: C { class: [node; active]; shape: circle }
d: D { class: [node; active]; shape: circle }

# TODO: the cheapest path — 1 + 3 = 4.
a -> c: 1 { class: step; style.stroke: "#16a34a" }
c -> d: 3 { class: step; style.stroke: "#16a34a" }

a -> b: 2 { class: hint }
b -> d: 8 { class: hint }
a -> d: 9 { class: hint }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

a: A { class: [node; current]; shape: circle }
b: B { class: node; shape: circle }
c: C { class: [node; active]; shape: circle }
d: D { class: [node; active]; shape: circle }

# TODO: the cheapest path — 1 + 3 = 4.
a -> c: 1 { class: step; style.stroke: "#16a34a" }
c -> d: 3 { class: step; style.stroke: "#16a34a" }

a -> b: 2 { class: hint }
b -> d: 8 { class: hint }
a -> d: 9 { class: hint }
```

## Representations

The default: O(V + E), so a sparse graph costs what it actually is.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

a: A { class: [cell; current]; width: 48 }
b: B { class: cell; width: 48 }
c: C { class: cell; width: 48 }
d: D { class: cell; width: 48 }

a -> a1: { class: hint }
a1: B { class: node; width: 48 }
a1 -> a2: { class: hint }
a2: C { class: node; width: 48 }

b -> b1: { class: hint }
b1: D { class: node; width: 48 }

c -> c1: { class: hint }
c1: D { class: node; width: 48 }

d -> d1: { class: hint }
d1: "∅" { class: [node; cold]; width: 48 }
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: right

a: A { class: [cell; current]; width: 48 }
b: B { class: cell; width: 48 }
c: C { class: cell; width: 48 }
d: D { class: cell; width: 48 }

a -> a1: { class: hint }
a1: B { class: node; width: 48 }
a1 -> a2: { class: hint }
a2: C { class: node; width: 48 }

b -> b1: { class: hint }
b1: D { class: node; width: 48 }

c -> c1: { class: hint }
c1: D { class: node; width: 48 }

d -> d1: { class: hint }
d1: "∅" { class: [node; cold]; width: 48 }
```

### Adjacency matrix

O(V²) whether the graph has a million edges or none — which is why it only earns its keep on a dense
graph, or when "is there an edge A→D?" has to answer in one lookup. This is the directed graph from
the top of the page, so it is asymmetric; an undirected graph's matrix is symmetric across the
diagonal.

```bash
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

m: "directed · row = from, column = to" { class: panel
  grid-rows: 5
  grid-columns: 5
  grid-gap: 0

  h0: ""  { class: idx; height: 48 }
  hA: A   { class: idx; height: 48 }
  hB: B   { class: idx; height: 48 }
  hC: C   { class: idx; height: 48 }
  hD: D   { class: idx; height: 48 }

  rA: A   { class: idx; height: 56 }
  aa: 0 { class: [cell; cold] }
  # TODO: the 1s — one per edge.
  ab: 1 { class: [cell; active] }
  ac: 1 { class: [cell; active] }
  ad: 0 { class: [cell; cold] }

  rB: B   { class: idx; height: 56 }
  ba: 0 { class: [cell; cold] }
  bb: 0 { class: [cell; cold] }
  bc: 0 { class: [cell; cold] }
  bd: 1 { class: [cell; active] }

  rC: C   { class: idx; height: 56 }
  ca: 0 { class: [cell; cold] }
  cb: 0 { class: [cell; cold] }
  cc: 0 { class: [cell; cold] }
  cd: 0 { class: [cell; cold] }

  rD: D   { class: idx; height: 56 }
  da: 0 { class: [cell; cold] }
  db: 0 { class: [cell; cold] }
  dc: 1 { class: [cell; active] }
  dd: 0 { class: [cell; cold] }
}
```

```d2
classes: {
  cell: { style: { fill: "#ffffff"; stroke: "#94a3b8"; font-size: 18 }; width: 64; height: 56 }
  idx: { style: { fill: transparent; stroke-width: 0; font-size: 13; font-color: "#64748b" }; width: 64; height: 24 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
}

m: "directed · row = from, column = to" { class: panel
  grid-rows: 5
  grid-columns: 5
  grid-gap: 0

  h0: ""  { class: idx; height: 48 }
  hA: A   { class: idx; height: 48 }
  hB: B   { class: idx; height: 48 }
  hC: C   { class: idx; height: 48 }
  hD: D   { class: idx; height: 48 }

  rA: A   { class: idx; height: 56 }
  aa: 0 { class: [cell; cold] }
  # TODO: the 1s — one per edge.
  ab: 1 { class: [cell; active] }
  ac: 1 { class: [cell; active] }
  ad: 0 { class: [cell; cold] }

  rB: B   { class: idx; height: 56 }
  ba: 0 { class: [cell; cold] }
  bb: 0 { class: [cell; cold] }
  bc: 0 { class: [cell; cold] }
  bd: 1 { class: [cell; active] }

  rC: C   { class: idx; height: 56 }
  ca: 0 { class: [cell; cold] }
  cb: 0 { class: [cell; cold] }
  cc: 0 { class: [cell; cold] }
  cd: 0 { class: [cell; cold] }

  rD: D   { class: idx; height: 56 }
  da: 0 { class: [cell; cold] }
  db: 0 { class: [cell; cold] }
  dc: 1 { class: [cell; active] }
  dd: 0 { class: [cell; cold] }
}
```

## Traversal

The whole reason BFS finds shortest paths: it finishes a level before starting the next, so the first
time it reaches a node is by the fewest hops there is. The levels are containers, which is what pins
each node to its own row.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

l0: "level 0 · start" { class: panel
  a: A { class: [node; visited]; shape: circle }
}

l1: "level 1 · 1 hop" { class: panel
  b: B { class: [node; visited]; shape: circle }
  c: C { class: [node; visited]; shape: circle }
}

# TODO: the frontier — the level the queue is chewing through now.
l2: "level 2 · 2 hops — the frontier" { class: panel
  d: D { class: [node; current]; shape: circle }
  e: E { class: [node; current]; shape: circle }
}

l3: "level 3 · not reached yet" { class: panel
  f: F { class: [node; cold]; shape: circle }
}

l0.a -> l1.b
l0.a -> l1.c
l1.b -> l2.d
l1.c -> l2.e
l2.d -> l3.f: { class: hint }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

l0: "level 0 · start" { class: panel
  a: A { class: [node; visited]; shape: circle }
}

l1: "level 1 · 1 hop" { class: panel
  b: B { class: [node; visited]; shape: circle }
  c: C { class: [node; visited]; shape: circle }
}

# TODO: the frontier — the level the queue is chewing through now.
l2: "level 2 · 2 hops — the frontier" { class: panel
  d: D { class: [node; current]; shape: circle }
  e: E { class: [node; current]; shape: circle }
}

l3: "level 3 · not reached yet" { class: panel
  f: F { class: [node; cold]; shape: circle }
}

l0.a -> l1.b
l0.a -> l1.c
l1.b -> l2.d
l1.c -> l2.e
l2.d -> l3.f: { class: hint }
```

### DFS and backtracking

Number the visit order — without the numbers this is the same picture as BFS. The backtrack edge is
dashed because it is not an edge of the graph; it is the call stack unwinding.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

a: A { class: [node; visited]; shape: circle }
b: B { class: [node; visited]; shape: circle }
d: D { class: [node; visited]; shape: circle }
# TODO: the dead end that forces the backtrack.
g: G { class: [node; pruned]; shape: circle }
c: C { class: [node; current]; shape: circle }
e: E { class: [node; cold]; shape: circle }

a -> b: 1 { class: step; style.stroke: "#16a34a" }
b -> d: 2 { class: step; style.stroke: "#16a34a" }
d -> g: 3 { class: step; style.stroke: "#16a34a" }
g -> a: "4. backtrack" { class: step; style.stroke: "#dc2626"; style.stroke-dash: 5 }
a -> c: 5 { class: step; style.stroke: "#ca8a04" }
c -> e: { class: hint }
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  visited: { style: { fill: "#e2e8f0"; stroke: "#94a3b8"; font-color: "#64748b" } }   # already processed
  pruned:  { style: { fill: "#fee2e2"; stroke: "#dc2626"; stroke-dash: 4; font-color: "#991b1b" } }   # cut off, never explored
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
}

direction: down

a: A { class: [node; visited]; shape: circle }
b: B { class: [node; visited]; shape: circle }
d: D { class: [node; visited]; shape: circle }
# TODO: the dead end that forces the backtrack.
g: G { class: [node; pruned]; shape: circle }
c: C { class: [node; current]; shape: circle }
e: E { class: [node; cold]; shape: circle }

a -> b: 1 { class: step; style.stroke: "#16a34a" }
b -> d: 2 { class: step; style.stroke: "#16a34a" }
d -> g: 3 { class: step; style.stroke: "#16a34a" }
g -> a: "4. backtrack" { class: step; style.stroke: "#dc2626"; style.stroke-dash: 5 }
a -> c: 5 { class: step; style.stroke: "#ca8a04" }
c -> e: { class: hint }
```

### Topological order

Laid out left to right so every edge points forward, which *is* the topological order made visible.
The in-degrees are written on the nodes because that is the number Kahn's algorithm consumes.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

direction: right

# TODO: in-degree 0 — the only nodes that can start.
a: "A\nin:0" { class: [node; active]; width: 66 }
b: "B\nin:1" { class: node; width: 66 }
c: "C\nin:1" { class: node; width: 66 }
d: "D\nin:2" { class: node; width: 66 }
e: "E\nin:1" { class: node; width: 66 }

a -> b
a -> c
b -> d
c -> d
d -> e

order: "a valid order:  A → B → C → D → E" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#475569" }
}
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  active:  { style: { fill: "#dcfce7"; stroke: "#16a34a" } }   # in play — inside the window, in range
}

direction: right

# TODO: in-degree 0 — the only nodes that can start.
a: "A\nin:0" { class: [node; active]; width: 66 }
b: "B\nin:1" { class: node; width: 66 }
c: "C\nin:1" { class: node; width: 66 }
d: "D\nin:2" { class: node; width: 66 }
e: "E\nin:1" { class: node; width: 66 }

a -> b
a -> c
b -> d
c -> d
d -> e

order: "a valid order:  A → B → C → D → E" {
  near: bottom-center
  shape: text
  style: { font-size: 15; font-color: "#475569" }
}
```

## Union-find

Arrows run **up**, toward each root. Two elements share a set exactly when they climb to the same
root — that is the entire data structure. One set is drawn already flattened by path compression and
the other is not, so the optimisation has something to be compared against.

```bash
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: up

flat: "set {1,2,3,4} · path compressed" { class: panel
  # TODO: a root is a node whose parent is itself.
  r1: "1\nroot" { class: [node; current]; width: 62 }
  n2: 2 { class: node }
  n3: 3 { class: node }
  n4: 4 { class: node }
  n2 -> r1
  n3 -> r1
  # 4 points straight at the root instead of climbing through 3.
  n4 -> r1: compressed { class: step; style.stroke: "#16a34a" }
}

deep: "set {5,6,7} · still a chain" { class: panel
  r5: "5\nroot" { class: [node; current]; width: 62 }
  n6: 6 { class: node }
  n7: 7 { class: node }
  n6 -> r5
  n7 -> n6: "find(7) climbs twice" { class: step; style.stroke: "#ea580c" }
}
```

```d2
classes: {
  node: { style: { fill: "#ffffff"; stroke: "#64748b"; font-size: 16 }; width: 56; height: 56 }
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  current: { style: { fill: "#fef08a"; stroke: "#ca8a04"; stroke-width: 3 } }   # being touched right now
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
}

direction: up

flat: "set {1,2,3,4} · path compressed" { class: panel
  # TODO: a root is a node whose parent is itself.
  r1: "1\nroot" { class: [node; current]; width: 62 }
  n2: 2 { class: node }
  n3: 3 { class: node }
  n4: 4 { class: node }
  n2 -> r1
  n3 -> r1
  # 4 points straight at the root instead of climbing through 3.
  n4 -> r1: compressed { class: step; style.stroke: "#16a34a" }
}

deep: "set {5,6,7} · still a chain" { class: panel
  r5: "5\nroot" { class: [node; current]; width: 62 }
  n6: 6 { class: node }
  n7: 7 { class: node }
  n6 -> r5
  n7 -> n6: "find(7) climbs twice" { class: step; style.stroke: "#ea580c" }
}
```

---

Next: [dynamic programming and divide-and-conquer](/synapse/synapse-features/d2-component-library/dsa-dp-and-divide).
