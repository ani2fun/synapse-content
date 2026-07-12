---
title: "Visualisation Gallery — every bespoke widget"
summary: "One runnable block per bespoke DSA visualiser — array cells, a stack column, a heap tree, a fenwick staircase, a skip-list grid, a force-directed graph, and more. Each block carries a viz=<structure>:<root> hint; click Visualise to trace the code and watch that structure animate. Use this page to eyeball every renderer, in Python and Java, in one place."
---

# Visualisation Gallery

Synapse can **animate a running program**. A runnable block whose info-string carries a
`viz=<structure>:<root>` hint gains a **Visualise** button (the ▶ / network icon in the CODE
toolbar): click it and Synapse re-runs the code under a tracer, captures the heap on every line,
and drives a **bespoke renderer** for that data structure — cells, a tree, a graph, a stack column,
and so on.

This page is a **diagnostic gallery**: every bespoke renderer appears once, as the simplest
shape-correct example. Open each block's **Visualise** button to see that structure's widget drive
off a real captured trace. Use it to eyeball every renderer in one place — and to spot the ones that
render *flat / generic / wrong*, which tells us the traced data shape isn't matching the renderer.

## How to read a block

Every block below carries a hint like `viz=tree:root`:

- **`tree`** — the *structure*, which picks the renderer (the closed vocabulary is listed by family
  below). An unknown name shows an honest "not available" card rather than guessing.
- **`root`** — the *variable* to visualise. `viz=array:arr` draws the local `arr`; a dotted root like
  `viz=list:self.head` reaches into an object. Some renderers (the call stack) need no root.

Each structure has a **Python** and a **Java** block, grouped into one workbench with language tabs —
**Visualise works on whichever tab is active**, so you can compare the two tracers on the same shape.
These are minimal examples modelled on the renderer fixtures, not teaching content — the point is to
*see* each visual.

> There are two ways a widget reaches the screen. This gallery uses the **runnable** path (trace →
> adapt → render — the full pipeline, where most issues surface). A lesson can also embed a
> **declarative** ` ```viz widget=<structure> ` block with a hand-authored payload that renders
> immediately without running anything — handy for isolating a pure renderer bug from a tracer/adapt
> bug. If a block here renders wrong, try the same structure declaratively to tell the two apart.

---

## Cells family

Structures laid out as a **row of boxed cells** with index labels; integer locals (`i`, `left`,
`right`) become coloured pointer carets. Renders: `array`, `queue`, `deque`, `bitset`, `fenwick`.

### Array — `viz=array`

A plain list. The canonical example is a **two-pointer reverse**: `left`/`right` carets march inward
and each swap rings the touched cells.

```python run viz=array:arr
arr = [5, 2, 8, 1, 9, 3]
left, right = 0, len(arr) - 1
while left < right:
    arr[left], arr[right] = arr[right], arr[left]
    left += 1
    right -= 1
```

```java run viz=array:arr
public class Main {
    public static void main(String[] args) {
        int[] arr = {5, 2, 8, 1, 9, 3};
        int left = 0, right = arr.length - 1;
        while (left < right) {
            int t = arr[left]; arr[left] = arr[right]; arr[right] = t;
            left++; right--;
        }
    }
}
```

### Queue — `viz=queue`

A FIFO buffer: a list with **enqueue at the back, dequeue from the front**. The renderer calls out the
head (front) and tail (back).

```python run viz=queue:queue
queue = []
for x in [10, 20, 30, 40]:
    queue.append(x)   # enqueue at the back
queue.pop(0)          # dequeue from the front
queue.pop(0)
```

```java run viz=queue:queue
import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> queue = new ArrayList<>();
        for (int x : new int[]{10, 20, 30, 40}) queue.add(x);   // enqueue
        queue.remove(0);                                        // dequeue
        queue.remove(0);
    }
}
```

### Deque — `viz=deque`

A double-ended queue: both ends are active — pushes to the **front** and the **back**.

```python run viz=deque:dq
dq = []
dq.append(5)      # back
dq.insert(0, 3)   # front
dq.append(8)      # back
dq.insert(0, 1)   # front
```

```java run viz=deque:dq
import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> dq = new ArrayList<>();
        dq.add(5);        // back
        dq.add(0, 3);     // front
        dq.add(8);        // back
        dq.add(0, 1);     // front
    }
}
```

### Bitset — `viz=bitset`

A list of `0`/`1` as a bit row: set bits filled, clear bits muted, with a popcount. Here bits 1, 3, 4,
6 are set, then bit 4 is cleared.

```python run viz=bitset:bits
bits = [0] * 8
for i in [1, 3, 4, 6]:
    bits[i] = 1   # set
bits[4] = 0       # clear
```

```java run viz=bitset:bits
public class Main {
    public static void main(String[] args) {
        int[] bits = new int[8];
        for (int i : new int[]{1, 3, 4, 6}) bits[i] = 1;   // set
        bits[4] = 0;                                       // clear
    }
}
```

### Fenwick tree (BIT) — `viz=fenwick`

A **binary indexed tree** for prefix sums. The 1-indexed backing array (`tree[0]` unused) renders as the
*responsibility staircase* — each cell a bar over the half-open range `(i − lowbit(i), i]` it owns. This
builds a BIT over `[1, 2, …, 8]`.

```python run viz=fenwick:tree
n = 8
tree = [0] * (n + 1)   # 1-indexed; tree[0] is the unused sentinel

def update(i, delta):
    while i <= n:
        tree[i] += delta
        i += i & (-i)   # add lowbit

for i in range(1, n + 1):
    update(i, i)        # build a BIT over [1, 2, …, 8]
```

```java run viz=fenwick:tree
public class Main {
    public static void main(String[] args) {
        int n = 8;
        int[] tree = new int[n + 1];   // 1-indexed; tree[0] unused
        for (int i = 1; i <= n; i++) {
            int j = i;
            while (j <= n) { tree[j] += i; j += j & (-j); }
        }
    }
}
```

---

## Stack family

A **vertical column**, bottom → top, with a `top` marker. Renders: `stack`, `callstack`.

### Stack — `viz=stack`

A list used as a LIFO stack: pushes stack upward, pops peel off the top.

```python run viz=stack:stack
stack = []
for x in [3, 7, 1, 9, 5]:
    stack.append(x)   # push
stack.pop()           # pop
stack.pop()
```

```java run viz=stack:stack
import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> stack = new ArrayList<>();
        for (int x : new int[]{3, 7, 1, 9, 5}) stack.add(x);   // push
        stack.remove(stack.size() - 1);                        // pop
        stack.remove(stack.size() - 1);
    }
}
```

### Call stack — `viz=callstack`

Not a variable — the program's **own call frames**. Recursion pushes a frame per call and pops on return;
the widget shows the stack growing and shrinking. Classic recursive factorial (needs no root).

```python run viz=callstack
def fact(n):
    if n <= 1:
        return 1
    return n * fact(n - 1)   # each call pushes a frame; each return pops one

answer = fact(4)
print(answer)
```

```java run viz=callstack
public class Main {
    static int fact(int n) {
        if (n <= 1) return 1;
        return n * fact(n - 1);   // each call pushes a frame; each return pops one
    }
    public static void main(String[] args) {
        int answer = fact(4);
        System.out.println(answer);
    }
}
```

---

## Tree family

**Node-link trees** laid out by depth, children left-to-right, parent→child edges behind the nodes.
Renders: `tree`, `heap`, `segment-tree`. Node values come from a recognised field (`val` / `value` /
`key`), so use those names.

### Binary tree / BST — `viz=tree`

`TreeNode(val, left, right)` objects render as a node-link tree. This builds a BST by inserting
`5, 3, 8, 1, 4, 7, 9`.

```python run viz=tree:root
class TreeNode:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

def insert(root, val):
    if root is None:
        return TreeNode(val)
    if val < root.val:
        root.left = insert(root.left, val)
    else:
        root.right = insert(root.right, val)
    return root

root = None
for v in [5, 3, 8, 1, 4, 7, 9]:
    root = insert(root, v)
```

```java run viz=tree:root
public class Main {
    static class TreeNode { int val; TreeNode left, right; TreeNode(int v) { val = v; } }
    static TreeNode insert(TreeNode root, int val) {
        if (root == null) return new TreeNode(val);
        if (val < root.val) root.left = insert(root.left, val);
        else root.right = insert(root.right, val);
        return root;
    }
    public static void main(String[] args) {
        TreeNode root = null;
        for (int v : new int[]{5, 3, 8, 1, 4, 7, 9}) root = insert(root, v);
    }
}
```

### Heap — `viz=heap`

An **array-backed** binary heap renders as its *implicit* tree (children of `i` are `2i+1`, `2i+2`).
Note: a heap must be an array/list here — a node-object heap renders as a plain tree instead.

```python run viz=heap:heap
import heapq
heap = []
for x in [5, 3, 8, 1, 9, 2, 7]:
    heapq.heappush(heap, x)
```

```java run viz=heap:heap
import java.util.*;
public class Main {
    public static void main(String[] args) {
        List<Integer> heap = new ArrayList<>();   // array-backed min-heap
        for (int x : new int[]{5, 3, 8, 1, 9, 2, 7}) {
            heap.add(x);
            int i = heap.size() - 1;
            while (i > 0 && heap.get((i - 1) / 2) > heap.get(i)) {
                Collections.swap(heap, i, (i - 1) / 2);
                i = (i - 1) / 2;
            }
        }
    }
}
```

### Segment tree — `viz=segment-tree`

`SegNode(lo, hi, value, left, right)` — each node a range `[lo, hi]` with an aggregate `value`. The
recursive `build` only assigns `root` on its last line (the partial subtrees live in recursion frames
the tracer doesn't follow), so construction collapses to one step; the trailing descent then walks a
`cur` pointer down to the leaf covering index 2, animating the finished tree across several steps.

```python run viz=segment-tree:root
class SegNode:
    def __init__(self, lo, hi, value, left=None, right=None):
        self.lo = lo
        self.hi = hi
        self.value = value
        self.left = left
        self.right = right

def build(arr, lo, hi):
    if lo == hi:
        return SegNode(lo, hi, arr[lo])
    mid = (lo + hi) // 2
    l = build(arr, lo, mid)
    r = build(arr, mid + 1, hi)
    return SegNode(lo, hi, l.value + r.value, l, r)

root = build([3, 1, 4, 2], 0, 3)

# Descend from the root to the leaf covering index 2 so the finished tree
# animates with a moving `cur` pointer across several steps.
cur = root
while cur.lo != cur.hi:
    mid = (cur.lo + cur.hi) // 2
    cur = cur.left if 2 <= mid else cur.right
```

```java run viz=segment-tree:root
public class Main {
    static class SegNode {
        int lo, hi, value;
        SegNode left, right;
        SegNode(int lo, int hi, int value) { this.lo = lo; this.hi = hi; this.value = value; }
    }
    static SegNode build(int[] arr, int lo, int hi) {
        if (lo == hi) return new SegNode(lo, hi, arr[lo]);
        int mid = (lo + hi) / 2;
        SegNode l = build(arr, lo, mid), r = build(arr, mid + 1, hi);
        SegNode node = new SegNode(lo, hi, l.value + r.value);
        node.left = l; node.right = r;
        return node;
    }
    public static void main(String[] args) {
        SegNode root = build(new int[]{3, 1, 4, 2}, 0, 3);
        SegNode cur = root;
        while (cur.lo != cur.hi) {
            int mid = (cur.lo + cur.hi) / 2;
            cur = (2 <= mid) ? cur.left : cur.right;
        }
    }
}
```

---

## Chain family

**Boxed nodes joined by arrows** (`next` above, a dashed `prev` below), ending in a `∅` null sentinel.
Renders: `list`, `skiplist`.

### Linked list — `viz=list`

A `next` chain of `Node(val, next)`. `head` / `cur` show as carets. (Add a `prev` field and the renderer
draws the doubly-linked back-arrows too.)

```python run viz=list:head
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None

head = Node(1)
head.next = Node(2)
head.next.next = Node(3)
head.next.next.next = Node(4)

cur = head
while cur:
    cur = cur.next
```

```java run viz=list:head
public class Main {
    static class Node { int val; Node next; Node(int v) { val = v; } }
    public static void main(String[] args) {
        Node head = new Node(1);
        head.next = new Node(2);
        head.next.next = new Node(3);
        head.next.next.next = new Node(4);
        Node cur = head;
        while (cur != null) cur = cur.next;
    }
}
```

### Doubly linked list — `viz=list`

The same `list` structure with a `prev` field: each node grows a **PREV** compartment, the moss `next`
arrows gain mulberry return arrows, and the legend explains both. `head` / `tail` / `cur` carets ride
along.

```python run viz=list:head
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None
        self.prev = None

head = Node(10)
b = Node(20)
c = Node(30)
head.next = b; b.prev = head
b.next = c; c.prev = b
tail = c

cur = head
while cur:
    cur = cur.next
```

```java run viz=list:head
public class Main {
    static class Node { int val; Node next; Node prev; Node(int v) { val = v; } }
    public static void main(String[] args) {
        Node head = new Node(10);
        Node b = new Node(20);
        Node c = new Node(30);
        head.next = b; b.prev = head;
        b.next = c; c.prev = b;
        Node tail = c;
        Node cur = head;
        while (cur != null) cur = cur.next;
    }
}
```

### Skip list — `viz=skiplist`

A level-0 `next` chain of `SkipNode(value, level)` renders as the multi-level grid — one row per level,
columns by key; `level` is the top express lane each node reaches.

```python run viz=skiplist:head
class SkipNode:
    def __init__(self, value, level):
        self.value = value
        self.level = level
        self.next = None

head = SkipNode(3, 0)
n7 = SkipNode(7, 2);   head.next = n7
n12 = SkipNode(12, 0); n7.next = n12
n19 = SkipNode(19, 1); n12.next = n19
n25 = SkipNode(25, 2); n19.next = n25
n31 = SkipNode(31, 0); n25.next = n31
```

```java run viz=skiplist:head
public class Main {
    static class SkipNode { int value, level; SkipNode next; SkipNode(int v, int l) { value = v; level = l; } }
    public static void main(String[] args) {
        SkipNode head = new SkipNode(3, 0);
        SkipNode n7 = new SkipNode(7, 2);   head.next = n7;
        SkipNode n12 = new SkipNode(12, 0); n7.next = n12;
        SkipNode n19 = new SkipNode(19, 1); n12.next = n19;
        SkipNode n25 = new SkipNode(25, 2); n19.next = n25;
        SkipNode n31 = new SkipNode(31, 0); n25.next = n31;
    }
}
```

---

## Graph family

**Force-directed node-link graphs** (a seeded layout, so a redraw is stable). Renders: `graph`,
`hashmap`, `union-find`.

### Graph — `viz=graph`

`Node(id, neighbors)` adjacency renders as a node-link graph; each node is relabelled from its `id`
field. A BFS walks it from `start`.

```python run viz=graph:start
from collections import deque

class Node:
    def __init__(self, name):
        self.id = name       # relabelled from `id`
        self.neighbors = []

start = Node("A"); b = Node("B"); c = Node("C"); d = Node("D")
start.neighbors = [b, c]
b.neighbors = [d]
c.neighbors = [d]

seen = set()
queue = deque([start])
while queue:
    node = queue.popleft()
    if node.id in seen:
        continue
    seen.add(node.id)
    for nb in node.neighbors:
        queue.append(nb)
```

```java run viz=graph:start
import java.util.*;
public class Main {
    static class Node { String id; List<Node> neighbors = new ArrayList<>(); Node(String id) { this.id = id; } }
    public static void main(String[] args) {
        Node start = new Node("A"), b = new Node("B"), c = new Node("C"), d = new Node("D");
        start.neighbors = Arrays.asList(b, c);
        b.neighbors = Arrays.asList(d);
        c.neighbors = Arrays.asList(d);
        Set<String> seen = new HashSet<>();
        Queue<Node> queue = new ArrayDeque<>();
        queue.add(start);
        while (!queue.isEmpty()) {
            Node node = queue.poll();
            if (!seen.add(node.id)) continue;
            for (Node nb : node.neighbors) queue.add(nb);
        }
    }
}
```

### Hash map — `viz=hashmap`

Separate chaining: a `dict` of `bucket-index → list of Entry` renders as buckets each with a
`key: value` chain.

```python run viz=hashmap:table
class Entry:
    def __init__(self, key, value):
        self.key = key
        self.value = value

table = {}   # bucket index -> list of Entry (the chain)

def put(key, value):
    i = len(key) % 4   # deterministic toy hash
    table.setdefault(i, []).append(Entry(key, value))

for k, v in [("apple", 1), ("grape", 2), ("fig", 3), ("kiwi", 4)]:
    put(k, v)
```

```java run viz=hashmap:table
import java.util.*;
public class Main {
    static class Entry { String key; int value; Entry(String k, int v) { key = k; value = v; } }
    public static void main(String[] args) {
        Map<Integer, List<Entry>> table = new HashMap<>();   // bucket index -> chain
        String[] keys = {"apple", "grape", "fig", "kiwi"};
        int[] vals = {1, 2, 3, 4};
        for (int i = 0; i < keys.length; i++) {
            int b = keys[i].length() % 4;                    // toy hash
            table.computeIfAbsent(b, x -> new ArrayList<>()).add(new Entry(keys[i], vals[i]));
        }
    }
}
```

### Union-Find (DSU) — `viz=union-find`

A `parent` array (`parent[i] == i` marks a root) renders as a forest with parent arcs. Four unions merge
`{0,1}`, `{2,3}`, then `{0,1,2,3}`, and `{4,5}`.

```python run viz=union-find:parent
parent = [0, 1, 2, 3, 4, 5]

def find(x):
    while parent[x] != x:
        x = parent[x]
    return x

def union(a, b):
    parent[find(a)] = find(b)

union(0, 1)
union(2, 3)
union(1, 3)
union(4, 5)
```

```java run viz=union-find:parent
public class Main {
    static int[] parent;
    static int find(int x) { while (parent[x] != x) x = parent[x]; return x; }
    static void union(int a, int b) { parent[find(a)] = find(b); }
    public static void main(String[] args) {
        parent = new int[]{0, 1, 2, 3, 4, 5};
        union(0, 1); union(2, 3); union(1, 3); union(4, 5);
    }
}
```

---

## Trie family

### Trie — `viz=trie`

`TrieNode(children: dict, is_end)` renders as a prefix tree; edges carry the character, and `is_end`
nodes get a terminal double-ring. Inserts `"cat"`, `"car"`, `"do"`.

```python run viz=trie:root
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

def insert(root, word):
    node = root
    for ch in word:
        if ch not in node.children:
            node.children[ch] = TrieNode()
        node = node.children[ch]
    node.is_end = True

root = TrieNode()
for word in ["cat", "car", "do"]:
    insert(root, word)
```

```java run viz=trie:root
import java.util.*;
public class Main {
    static class TrieNode {
        Map<Character, TrieNode> children = new HashMap<>();
        boolean isEnd = false;
    }
    static void insert(TrieNode root, String word) {
        TrieNode node = root;
        for (char ch : word.toCharArray()) {
            node.children.putIfAbsent(ch, new TrieNode());
            node = node.children.get(ch);
        }
        node.isEnd = true;
    }
    public static void main(String[] args) {
        TrieNode root = new TrieNode();
        for (String w : new String[]{"cat", "car", "do"}) insert(root, w);
    }
}
```

---

## Grid family

### 2-D grid / matrix — `viz=grid`

A list-of-lists (Python) or `int[][]` (Java) renders as a matrix: boxed cells with a column-index header
and per-row labels; the just-written cell rings. Here a 3×4 grid is filled with `r*4 + c`.

```python run viz=grid:grid
grid = [[0] * 4 for _ in range(3)]
for r in range(3):
    for c in range(4):
        grid[r][c] = r * 4 + c
```

```java run viz=grid:grid
public class Main {
    public static void main(String[] args) {
        int[][] grid = new int[3][4];
        for (int r = 0; r < 3; r++)
            for (int c = 0; c < 4; c++)
                grid[r][c] = r * 4 + c;
    }
}
```

---

## What to look for

Open each block's **Visualise** button (Python **and** Java) and check:

- **Renders the right shape** — cells in a row, a tree by depth, a graph by force, a stack as a column.
  A structure that falls back to a flat/generic drawing means the traced heap doesn't match the renderer.
- **Values are labelled** — nodes should show `val` / `value` / `key`, not a bare `N`. A missing label is
  a field-recognition gap.
- **Steps animate** — the transport should step through the algorithm; the last frame should be the final
  state (e.g. two pointers meeting, the full tree). A trace that stops one step short is a tracer gap.
- **Python and Java agree** — the two tabs should tell the same story; a divergence points at one tracer.

Anything that doesn't match is a concrete bug to file against the visualisation pipeline.
