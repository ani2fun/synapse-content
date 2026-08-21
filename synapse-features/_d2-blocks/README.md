# D2 component library

Reusable D2 diagram templates for **data structures & algorithms** and **system design** — figures
to copy and adapt, not one-off drawings. Every block compiles on its own, carries a header saying
what it shows and which knobs to turn, and marks its customization points with `# TODO:`.

The rendered catalogue lives in the book, one page per family, starting at
[Using the component library](/synapse/synapse-features/d2-component-library/using-the-library).

```
lib/theme.d2      every colour and size, in one place — spread in with `...@../lib/theme`
lib/icons.d2      45 verified icon URLs for the system-design blocks
lib/flatten.mjs   turns a block into the self-contained source a lesson fence carries
lib/sheet.py      stacks rendered blocks into one contact-sheet PNG
demo/             the three figures on the "using the library" page
dsa/              data structures and algorithms
system-design/    primitives, native shapes, boundaries, composed patterns
render.sh         the gate
build/            rendered output (gitignored)
```

## The gate

```bash
./render.sh all
```

| | |
| --- | --- |
| `./render.sh` | compile every block to `build/<path>.svg`, **and** compile its flattened form |
| `./render.sh png` | the same, plus a PNG per block |
| `./render.sh sheet` | one captioned contact sheet per directory |
| `./render.sh fence <path>` | the ```` ```bash ```` + ```` ```d2 ```` pair to paste into a lesson |
| `./render.sh anim <dir>` | the ```` ```bash ```` + N consecutive ```` ```d2 ```` fences of a **stepper** |
| `./render.sh player <dir>` | the ```` ```bash ```` + the frame run of a **player** |
| `./render.sh stable` | every highlight-mode animation is layout-stable to within 2% |
| `./render.sh media` | redraw the figures that ship as files, under `_media/synapse-features/` |
| `./render.sh icons` | every icon URL answers 200 |
| `./render.sh app` | draw every lesson fence with the engine the app actually ships |

Two things about that list are load-bearing.

**Each block is compiled twice** — as written, and flattened. A `d2` fence has no filesystem, so
`...@../lib/theme` resolves to nothing inside one. The flattened form is what a lesson publishes, and
if only the file compiled you would ship a dead fence.

**`app` uses a different d2 from the rest.** The app pins the WASM build (v0.7.0 at the time of
writing) and renders with **ELK** at `pad: 20`; your CLI is probably v0.8.1 and defaults to dagre at
`pad: 100`. `render.sh` passes `--layout elk --pad 20` everywhere so the local picture matches, but
only `app` compiles with the engine a reader receives. It draws into a throwaway root by default —
committing those figures is CI's job (`.github/workflows/render-d2.yml`); pass `APP_GATE_INPLACE=1`
to populate `_media/d2` here instead.

## Imports

Imports in D2 resolve **relative to the importing file**, and there is no root-anchor flag. So a
block one level down writes

```
...@../lib/theme
```

and one two levels down writes `...@../../lib/theme`. Every file still compiles standalone.

## Icons

Icons are a **runtime dependency**. d2 leaves them as remote `<image href>` and never inlines the
bytes, so a reader with no route to `icons.d2lang.com` sees the box and the label and nothing else.
Where a native shape carries the meaning on its own — `queue`, `cylinder`, `person` — prefer the
shape.

`./render.sh icons` probes every URL in `lib/icons.d2` and fails on any non-200. That gate is not
optional: the CDN answers **403**, not 404, for a path that does not exist, and d2 turns an icon it
cannot fetch into an empty box without a word of complaint.

## The state palette

Eight state classes layer over a structure class with the list form, so recolouring is a one-word
edit and never a hex edit:

```
v3: 9 { class: [cell; current] }
```

| | |
| --- | --- |
| `active` | in play — inside the window, in range |
| `current` | being touched right now |
| `visited` | already processed |
| `pruned` | cut off, proven impossible |
| `hot` | frequent — a cache hit, a busy path |
| `cold` | rare — a cache miss, a cold path |
| `idle` | declared, untouched, **recolourable** — see below |
| `dim` | on screen, and not what this frame is about |

The last two exist for the animations. `idle` looks exactly like an unstyled cell, and what it buys
is the *slot*: D2 will not override a scalar `class: cell` with a list, so anything a frame will
recolour has to be declared two-class from the start.

## Layout rules worth knowing

| | |
| --- | --- |
| **Set `grid-rows` AND `grid-columns`** | With only `grid-columns`, D2 fills column-major and re-flows the cells, overriding the widths and heights you set. `grid-gap: 0` is what makes cells read as one strip. |
| **Grid keywords are ignored inside `classes`** | Set them on the container. Classes are for styling and sizing only. |
| **Connections do not route into a grid** | To point at a column, add a spacer row of `ghost` cells and put a `tick` in the column you mean. |
| **A nested container ignores `direction`** | ELK lays every container out in the **root's** direction. Panels holding a tree therefore need `direction: down` at the root, and they stack vertically. |
| **Unconnected siblings lay out perpendicular to the direction** | `direction: right` stacks two panels; `direction: down` puts them in a row. Join them with an edge and they line up along the direction. |
| **The panel IS the grid** | Do not nest a `board` inside a `panel`. The wrapper costs about 100×70px of dead space and buys nothing. |
| **Same form in, same form out** | D2 will not override a scalar `class: cell` with a **list**, and says nothing when it declines — the node simply keeps its old colour. Overriding with a bare `class: active` does apply, and drops `cell` along with its pinned width. Anything a frame will recolour is declared `[cell; idle]` from the start. |
| **A `near:` title sizes the diagram** | A free-floating text shape widens the whole figure to fit itself, so a long caption and a short one give different bounding boxes. Pin its `width` and they do not. |
| **Redeclaring an edge makes a second one** | `a -> b: "x"` written twice is two connections, indexed `(a -> b)[0]` and `(a -> b)[1]`. To change one, address it by index — `(a -> b)[0].class: step` — never by writing it again. |
| **An undeclared key is a declaration** | `db_a -> db_b` where neither exists creates two empty boxes and draws them. Fully qualify a cross-container edge: `az_a.db_a -> az_b.db_b`. |

## Animations

Two panels show one step; an animation shows the run. The sources are directories:

```
dsa/sliding-window.anim/
  base.d2          # every node, edge and label — dimmed. Frame zero.
  01-open.d2       # ...@./base  +  a title and three classes
  02-grow.d2
  …
```

Four rules make one watchable, and `base.d2` is where they are enforced: **declare everything in
the base**, **recolour rather than relabel**, **pin the title's width**, and **keep the edge count
down**. `./render.sh stable` reads the `viewBox` off every frame and fails an animation whose
frames drift more than 2%.

There are two modes. **Highlight** freezes the layout and moves colour through it — right for a
sequence of events. **Build** lets the diagram grow, chaining each frame's import from the one
before, and is exempt from the stability gate — right for a system evolving. A build chain can add
but never remove; to retire something, blank its label and set `style.opacity: 0` through its index.

Four transports put one in a lesson, and the trade is where the frames get drawn:

| | Reader gets | Drawn |
| --- | --- | --- |
| **Stepper** — consecutive ```` ```d2 ```` fences | ‹ 3/5 › | in the reader's browser, pulling the ~6 MB engine |
| **Player** — a run of images, alt `— frame i of N` | ▶ ⏸ scrubber, arrow keys | at authoring time, by `./render.sh media` |
| **Auto-loop** — `steps:` + `--animate-interval` | plays itself, forever, no controls | at authoring time; never a fence |
| **Walkthrough** — ```` ```d2 boards ```` + `layers:` | click to drill, ⌂ ☰, shareable | by content CI, into `_d2/` beside the lesson |

The player is the default for anything longer than a few frames.

## The transition skeleton

The most reused block in the library. Two panels and an arrow that names the one step between them:

```
direction: right
before: "before · <state>" { class: panel   <grid keys, then cells> }
after:  "after · <state>"  { class: panel   <grid keys, then cells> }
before -> after: "<the step>" { class: step }
```

Keep the arrow label short — ELK routes the edge straight through its text, so a long one ends up
struck through by its own arrow. Put the invariant in the panel titles.

## Index — DSA

### Arrays, windows and pointers

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `array-strip` | [dsa/array-strip.d2](dsa/array-strip.d2) | `build/dsa/array-strip.svg` | A contiguous run of cells with its indices printed underneath. |
| `array-strip-range` | [dsa/array-strip-range.d2](dsa/array-strip-range.d2) | `build/dsa/array-strip-range.svg` | The same strip with a half-open range [lo, hi) called out, and a caption row naming the bounds. |
| `array-strip-step` | [dsa/array-strip-step.d2](dsa/array-strip-step.d2) | `build/dsa/array-strip-step.svg` | THE block to copy. Two panels — the state before a step and the state after it — joined by an arrow that names the step. |
| `sliding-window` | [dsa/sliding-window.d2](dsa/sliding-window.d2) | `build/dsa/sliding-window.svg` | A window [l, r] over a strip, with both bounds labelled on a spacer row and the window's invariant in the title. |
| `sliding-window-expand` | [dsa/sliding-window-expand.d2](dsa/sliding-window-expand.d2) | `build/dsa/sliding-window-expand.svg` | One growth step: r advances, the new cell joins the window, the running total rises. |
| `sliding-window-shrink` | [dsa/sliding-window-shrink.d2](dsa/sliding-window-shrink.d2) | `build/dsa/sliding-window-shrink.svg` | One contraction step: the window has broken its constraint, so l advances and the cell it leaves behind is subtracted. |
| `two-pointers` | [dsa/two-pointers.d2](dsa/two-pointers.d2) | `build/dsa/two-pointers.svg` | Two indices closing in from the ends of a sorted strip. The cells between them are still in play; the cells outside are ruled out for good. |
| `two-pointers-step` | [dsa/two-pointers-step.d2](dsa/two-pointers-step.d2) | `build/dsa/two-pointers-step.svg` | The step that makes the technique work: the sum is too small, so the ONLY move that can help is lo++. |
| `fast-slow-pointers` | [dsa/fast-slow-pointers.d2](dsa/fast-slow-pointers.d2) | `build/dsa/fast-slow-pointers.svg` | Two walkers on a list, one hopping once per tick and the other twice. |
| `prefix-sum` | [dsa/prefix-sum.d2](dsa/prefix-sum.d2) | `build/dsa/prefix-sum.svg` | The input above, the prefix array below, and the identity that makes the structure worth building: a range sum becomes one subtraction. |
| `difference-array` | [dsa/difference-array.d2](dsa/difference-array.d2) | `build/dsa/difference-array.svg` | Prefix sum run backwards: to add v across a whole range in O(1), touch two cells and let a later prefix pass spread the change. |

### Stacks, lists and hashing

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `stack` | [dsa/stack.d2](dsa/stack.d2) | `build/dsa/stack.svg` | A single column, top at the top. Drawing it vertically is not decoration: it is what makes "push" and "pop" mean the same thing to the reader as they do in the code. |
| `stack-step` | [dsa/stack-step.d2](dsa/stack-step.d2) | `build/dsa/stack-step.svg` | One push. Everything below the top is untouched — that is the whole claim a stack makes, and two panels prove it at a glance. |
| `queue` | [dsa/queue.d2](dsa/queue.d2) | `build/dsa/queue.svg` | Horizontal, head on the left, tail on the right, work flowing left to right. |
| `deque` | [dsa/deque.d2](dsa/deque.d2) | `build/dsa/deque.svg` | A queue that grows and shrinks at both ends, so both ends get a labelled pair of operations. |
| `circular-buffer` | [dsa/circular-buffer.d2](dsa/circular-buffer.d2) | `build/dsa/circular-buffer.svg` | A fixed strip with head and tail that wrap. Drawn straight rather than as a ring, because the wrap is easier to believe when you can see tail sitting to the LEFT of head with the filled cell |
| `linked-list-singly` | [dsa/linked-list-singly.d2](dsa/linked-list-singly.d2) | `build/dsa/linked-list-singly.svg` | Boxes and one-way arrows, with the null terminator drawn rather than implied. |
| `linked-list-singly-step` | [dsa/linked-list-singly-step.d2](dsa/linked-list-singly-step.d2) | `build/dsa/linked-list-singly-step.svg` | Splicing a node in after n1. Both pointer writes are shown because the ORDER of them is the bug: set the new node's next FIRST, then n1's. |
| `linked-list-doubly` | [dsa/linked-list-doubly.d2](dsa/linked-list-doubly.d2) | `build/dsa/linked-list-doubly.svg` | Two independent chains of pointers over the same nodes, drawn as two rows of arrows so the reader can count them. |
| `cycle-detection` | [dsa/cycle-detection.d2](dsa/cycle-detection.d2) | `build/dsa/cycle-detection.svg` | The shape the whole problem is named after: a straight run into a loop. |
| `hash-chaining` | [dsa/hash-chaining.d2](dsa/hash-chaining.d2) | `build/dsa/hash-chaining.svg` | A bucket array on the left, a list hanging off each occupied slot. |
| `hash-open-addressing` | [dsa/hash-open-addressing.d2](dsa/hash-open-addressing.d2) | `build/dsa/hash-open-addressing.svg` | No chains: a collision walks forward to the next free slot, so the table IS the strip. |
| `intervals-timeline` | [dsa/intervals-timeline.d2](dsa/intervals-timeline.d2) | `build/dsa/intervals-timeline.svg` | One row per interval, one column per time unit, so an overlap is a column with two filled cells in it. |

### Trees, heaps and range structures

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `binary-tree` | [dsa/binary-tree.d2](dsa/binary-tree.d2) | `build/dsa/binary-tree.svg` | Plain shape with `direction: down`. Draw the missing child as an explicit ∅ wherever the lesson turns on it — a tree drawn with only its real children looks balanced even when it is not, and |
| `bst` | [dsa/bst.d2](dsa/bst.d2) | `build/dsa/bst.svg` | A tree plus the invariant that makes it a BST, with the search path picked out. |
| `bst-step` | [dsa/bst-step.d2](dsa/bst-step.d2) | `build/dsa/bst-step.svg` | One insertion. A new key always lands as a LEAF — it never displaces anything — and two panels are the cheapest way to make that stick. |
| `heap` | [dsa/heap.d2](dsa/heap.d2) | `build/dsa/heap.svg` | A min-heap drawn as the tree it behaves like. The only invariant is parent ≤ child — note what is NOT claimed: siblings are unordered, and a level is not sorted. |
| `heap-array` | [dsa/heap-array.d2](dsa/heap-array.d2) | `build/dsa/heap-array.svg` | The same heap twice: the tree it behaves like, and the flat array it actually is. |
| `trie` | [dsa/trie.d2](dsa/trie.d2) | `build/dsa/trie.svg` | One character per EDGE, not per node — that is the distinction the drawing has to earn, because a node in a trie is a prefix, not a letter. |
| `segment-tree` | [dsa/segment-tree.d2](dsa/segment-tree.d2) | `build/dsa/segment-tree.svg` | Each node owns a RANGE and stores the aggregate over it. Labelling both — the range and the value — is what makes the structure legible: a segment tree drawn with only values looks like a he |
| `fenwick-tree` | [dsa/fenwick-tree.d2](dsa/fenwick-tree.d2) | `build/dsa/fenwick-tree.svg` | The coverage map. Fenwick index i stores the sum of (i − lowbit(i), i], and THAT is the whole structure — there is no tree in memory, only an array whose indices happen to describe one. |

### Graphs and traversal

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `graph-node-edge` | [dsa/graph-node-edge.d2](dsa/graph-node-edge.d2) | `build/dsa/graph-node-edge.svg` | The plain picture, in both flavours. Directed and undirected are drawn as ONE figure here on purpose: the difference is a single arrowhead, and putting them side by side is the fastest way t |
| `graph-weighted` | [dsa/graph-weighted.d2](dsa/graph-weighted.d2) | `build/dsa/graph-weighted.svg` | Weights on the edges and the shortest path picked out. Draw a path whose hop count is NOT the cheapest — here A→C→D costs 4 across two hops while the single hop A→D costs 9. |
| `graph-adjacency-list` | [dsa/graph-adjacency-list.d2](dsa/graph-adjacency-list.d2) | `build/dsa/graph-adjacency-list.svg` | One row per vertex, its neighbours hanging off it. The representation to reach for by default: the space it uses is O(V + E), so a sparse graph costs what it actually is. |
| `graph-adjacency-matrix` | [dsa/graph-adjacency-matrix.d2](dsa/graph-adjacency-matrix.d2) | `build/dsa/graph-adjacency-matrix.svg` | V × V cells, one per possible edge. Its cost is the point: O(V²) whether the graph has a million edges or none, which is why it only earns its keep on a dense graph — or when "is there an ed |
| `bfs-levels` | [dsa/bfs-levels.d2](dsa/bfs-levels.d2) | `build/dsa/bfs-levels.svg` | The whole reason BFS finds shortest paths, in one picture: it finishes a level before it starts the next, so the first time it reaches a node is by the fewest hops there is. |
| `dfs-path` | [dsa/dfs-path.d2](dsa/dfs-path.d2) | `build/dsa/dfs-path.svg` | Depth-first commits to a branch and only backs out when it must. |
| `topological-order` | [dsa/topological-order.d2](dsa/topological-order.d2) | `build/dsa/topological-order.svg` | A DAG laid out left to right so every edge points forward — which IS the topological order, made visible. |
| `union-find` | [dsa/union-find.d2](dsa/union-find.d2) | `build/dsa/union-find.svg` | Disjoint sets as a forest of parent pointers, arrows running UP toward each root. |

### DP and divide-and-conquer

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `dp-1d` | [dsa/dp-1d.d2](dsa/dp-1d.d2) | `build/dsa/dp-1d.svg` | A table part-filled, with the cell being computed and the cells it reads picked out separately. |
| `dp-2d` | [dsa/dp-2d.d2](dsa/dp-2d.d2) | `build/dsa/dp-2d.svg` | The same idea one dimension up. The three cells feeding dp[i][j] — up, left, and diagonal — are what determine the fill order, so they are drawn `active` while the cell being written is `cur |
| `recursion-tree-memo` | [dsa/recursion-tree-memo.d2](dsa/recursion-tree-memo.d2) | `build/dsa/recursion-tree-memo.svg` | The call tree with repeated subproblems marked as cache hits. |
| `binary-search` | [dsa/binary-search.d2](dsa/binary-search.d2) | `build/dsa/binary-search.svg` | lo, mid and hi over a sorted strip, with the discarded half already greyed out. |
| `binary-search-step` | [dsa/binary-search-step.d2](dsa/binary-search-step.d2) | `build/dsa/binary-search-step.svg` | One comparison, one half gone. Put the range SIZE in both titles — 9 → 4 → 2 → 1 is the sequence a reader should leave with, and it does not survive being described in words. |
| `quicksort-partition` | [dsa/quicksort-partition.d2](dsa/quicksort-partition.d2) | `build/dsa/quicksort-partition.svg` | The invariant Lomuto partitioning maintains, drawn as three regions plus the pivot. |
| `merge-step` | [dsa/merge-step.d2](dsa/merge-step.d2) | `build/dsa/merge-step.svg` | Two sorted runs and the output being built from them, one comparison at a time. |
| `grid-traversal` | [dsa/grid-traversal.d2](dsa/grid-traversal.d2) | `build/dsa/grid-traversal.svg` | A grid with walls, visited cells and the path found. Every grid problem is a graph problem where the edges are implicit — this figure is the translation, and drawing the walls is what stops |

## Index — how-to figures

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `state-classes` | [demo/state-classes.d2](demo/state-classes.d2) | `build/demo/state-classes.svg` | Every state class in lib/theme.d2, on the structure class they layer over. |
| `grid-gotcha` | [demo/grid-gotcha.d2](demo/grid-gotcha.d2) | `build/demo/grid-gotcha.svg` | The single most expensive mistake in this library — the same eight cells with and without `grid-rows`. |
| `tick-row` | [demo/tick-row.d2](demo/tick-row.d2) | `build/demo/tick-row.svg` | Connections do not route into a grid's children, so you cannot draw an arrow to cell 3. |

## Index — system design

### Primitives

Every box, grouped by tier. Each file is a catalog: copy the whole grid to start, or one
line to add a box to a diagram you already have.

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `async` | [system-design/primitives/async.d2](system-design/primitives/async.d2) | `build/system-design/primitives/async.svg` | The purple tier: everything that decouples a caller from a callee in TIME. A request crossing one of these boundaries stops being synchronous, and every guarantee changes with it — which is why they g |
| `clients` | [system-design/primitives/clients.d2](system-design/primitives/clients.d2) | `build/system-design/primitives/clients.svg` | Everything that originates a request. Copy the ONE line you need — each node here is a complete, self-contained declaration. |
| `compute` | [system-design/primitives/compute.d2](system-design/primitives/compute.d2) | `build/system-design/primitives/compute.svg` | The things that run your code. Green in the five-role palette. |
| `data` | [system-design/primitives/data.d2](system-design/primitives/data.d2) | `build/system-design/primitives/data.svg` | Where state lives. Orange in the five-role palette — and the one tier where the SHAPE earns its keep: `cylinder` says "database" with no icon and no network fetch. |
| `edge` | [system-design/primitives/edge.d2](system-design/primitives/edge.d2) | `build/system-design/primitives/edge.svg` | Everything a request passes through before it reaches code you wrote. Blue in the five-role palette, because "edge" is a tier, not a technology. |
| `mesh` | [system-design/primitives/mesh.d2](system-design/primitives/mesh.d2) | `build/system-design/primitives/mesh.svg` | What sits BETWEEN your services once there are more than about five of them. These are the boxes an "and how do the services find each other?" question is fishing for. |
| `platform` | [system-design/primitives/platform.d2](system-design/primitives/platform.d2) | `build/system-design/primitives/platform.svg` | The boxes that serve every other box. They are the ones candidates forget and operators care most about. |

### Native shapes and boundaries

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `native-shapes` | [system-design/shapes/native-shapes.d2](system-design/shapes/native-shapes.d2) | `build/system-design/shapes/native-shapes.svg` | Six shapes d2 draws itself. Prefer them over an icon whenever they fit, for three reasons: they need no network (an icon is a remote fetch in the reader's browser), they scale cleanly, and they carry |
| `sql-table` | [system-design/shapes/sql-table.d2](system-design/shapes/sql-table.d2) | `build/system-design/shapes/sql-table.svg` | `shape: sql_table` turns a node's keys into typed rows, and a connection BETWEEN TWO ROWS draws the foreign key. This is the fastest way to answer "what does your schema look like?" without leaving th |
| `regions-and-azs` | [system-design/boundaries/regions-and-azs.d2](system-design/boundaries/regions-and-azs.d2) | `build/system-design/boundaries/regions-and-azs.svg` | A container is a BLAST RADIUS. Nesting says what fails together: an AZ can go dark without taking its region with it, and a region can go dark without taking the service with it — but only if you drew |
| `vpc-and-trust` | [system-design/boundaries/vpc-and-trust.d2](system-design/boundaries/vpc-and-trust.d2) | `build/system-design/boundaries/vpc-and-trust.svg` | Two boundaries, and they are not the same one. The VPC is a NETWORK fact: what can route to what. The trust boundary is a SECURITY fact: where a request stops being believed and has to prove itself. |

### Patterns

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `cache-aside` | [system-design/patterns/cache-aside.d2](system-design/patterns/cache-aside.d2) | `build/system-design/patterns/cache-aside.svg` | The default caching strategy, and the one worth being able to draw from memory. The APPLICATION owns the cache: it looks, it misses, it loads, it fills. The cache itself knows nothing about the databa |
| `cqrs-event-sourcing` | [system-design/patterns/cqrs-event-sourcing.d2](system-design/patterns/cqrs-event-sourcing.d2) | `build/system-design/patterns/cqrs-event-sourcing.svg` | Two patterns that get named in one breath and are separable: |
| `event-driven` | [system-design/patterns/event-driven.d2](system-design/patterns/event-driven.d2) | `build/system-design/patterns/event-driven.svg` | One publisher, three subscribers, and nobody knows about anybody. The producer does not import a client for Email, Analytics or Fraud — it publishes a fact and stops caring, which is why a fourth cons |
| `multi-region-active-active` | [system-design/patterns/multi-region-active-active.d2](system-design/patterns/multi-region-active-active.d2) | `build/system-design/patterns/multi-region-active-active.svg` | Both regions serve writes. That single sentence is the entire difficulty: two writers, one dataset, and the speed of light between them. |
| `rate-limited-api` | [system-design/patterns/rate-limited-api.d2](system-design/patterns/rate-limited-api.d2) | `build/system-design/patterns/rate-limited-api.svg` | Where a request gets rejected, and by what. The order of these checks is the design: the cheapest rejection comes first, so an abusive caller never reaches anything expensive. |
| `replicas-and-shards` | [system-design/patterns/replicas-and-shards.d2](system-design/patterns/replicas-and-shards.d2) | `build/system-design/patterns/replicas-and-shards.svg` | The two ways to scale a database, drawn side by side because they solve DIFFERENT problems and candidates reach for the wrong one under pressure: |
| `request-sequence` | [system-design/patterns/request-sequence.d2](system-design/patterns/request-sequence.d2) | `build/system-design/patterns/request-sequence.svg` | `shape: sequence_diagram` reads the connections in ORDER, top to bottom, so this is the shape to reach for when the question is "walk me through a request" — a box diagram shows what exists, this show |
| `three-tier` | [system-design/patterns/three-tier.d2](system-design/patterns/three-tier.d2) | `build/system-design/patterns/three-tier.svg` | The diagram every system-design answer starts from. Draw this in the first two minutes, then earn the rest of the whiteboard by breaking one tier at a time. |
| `write-behind` | [system-design/patterns/write-behind.d2](system-design/patterns/write-behind.d2) | `build/system-design/patterns/write-behind.svg` | The write returns before the durable store has it. That is the trade in one sentence, and the whole diagram exists to make the consequences visible. |

## Index — animations

An animation is a DIRECTORY, not a file: `base.d2` holds the whole diagram dimmed, and each
numbered frame spreads it in and overrides three or four lines. `base.d2` declares its mode, the
lesson its frames are drawn into, and the caption that groups them:

```
# animation-mode: highlight     # highlight = layout frozen · build = layout grows
# lesson: animated-dsa          # _media/<book>/<lesson>/<name>/frame-N.svg
# caption: A sliding window …   # must match the alt text byte for byte
```

`./render.sh stable` fails a highlight-mode animation whose frames drift more than 2%.
`./render.sh media` draws every frame. `./render.sh player <dir>` emits the lesson markup, and
`./render.sh anim <dir>` emits the stepper form instead.

| Animation | Directory | Frames | When to use it |
| --- | --- | --- | --- |
| `cache-aside` | [system-design/animated/cache-aside.anim/](system-design/animated/cache-aside.anim/) | 5 · *highlight* | The whole diagram with nothing happening yet. Frame zero, and the file every frame spreads in with `...@./base`. |
| `leader-failover` | [system-design/animated/leader-failover.anim/](system-design/animated/leader-failover.anim/) | 6 · *highlight* | A failure over TIME, which is the one thing a static architecture diagram cannot show at all. The boxes never move; what changes is which node is the leader, and that is carried entirely by colour: |
| `rolling-deploy` | [system-design/animated/rolling-deploy.anim/](system-design/animated/rolling-deploy.anim/) | 5 · *highlight* | A deploy is a sequence, so a static picture of it is always the wrong picture: it shows one moment and the reader has to imagine the rest. |
| `scaling-story` | [system-design/animated/scaling-story.anim/](system-design/animated/scaling-story.anim/) | 5 · *build* | The OTHER animation mode. Everywhere else in this library a frame recolours a fixed picture; here each frame ADDS to the last, and the diagram grows. |
| `bfs-frontier` | [dsa/bfs-frontier.anim/](dsa/bfs-frontier.anim/) | 5 · *highlight* | Breadth-first search is a wave, and a wave is the thing a still picture is worst at. Five frames show the frontier expanding one hop at a time — which IS the proof that BFS finds shortest paths: a nod |
| `binary-search` | [dsa/binary-search.anim/](dsa/binary-search.anim/) | 5 · *highlight* | The search space halving, frame by frame. A static picture of binary search shows one comparison; the whole idea is what happens to the OTHER half, and only a sequence shows that. |
| `dp-2d-fill` | [dsa/dp-2d-fill.anim/](dsa/dp-2d-fill.anim/) | 5 · *highlight* | Counting paths across a 4×4 grid, moving only right or down. Every cell is the sum of the one above it and the one to its left — and THAT is the thing a static table cannot show: which two cells the a |
| `sliding-window` | [dsa/sliding-window.anim/](dsa/sliding-window.anim/) | 6 · *highlight* | The canonical animated DSA figure: a window that grows on the right and shrinks on the left, over a fixed strip. Problem: the longest subarray with sum ≤ 8. |

### The other two transports

| Block | File | Preview | When to use it |
| --- | --- | --- | --- |
| `cache-aside-loop` | [system-design/animated/cache-aside-loop.d2](system-design/animated/cache-aside-loop.d2) | `build/system-design/animated/cache-aside-loop.svg` | The same cache-aside sequence as cache-aside.anim/, written as d2 `steps:` and compiled with `--animate-interval`. The output is a SINGLE svg carrying CSS keyframes: it plays by itself, forever, with |
| `drilldown-boards` | [system-design/animated/drilldown-boards.d2](system-design/animated/drilldown-boards.d2) | `build/system-design/animated/drilldown-boards.svg` | The fourth transport, and the only one that is not a sequence. d2 `layers:` compiles to a TREE of boards, and a node carrying `link:` is a door into one of them: overview → the edge → the service → th |
