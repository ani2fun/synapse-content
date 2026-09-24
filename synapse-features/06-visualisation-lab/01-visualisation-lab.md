---
title: "Visualisation Lab — watch your own code run"
summary: "The /viz page: paste any Python or Java program, press Trace, and step through it line by line. Two lenses — Structure animates one data structure you name, Frames & objects draws every frame and every object with an arrow per reference, PythonTutor-style. Programs that call input() are asked as you step, a crash says where it broke, and any step exports as a D2 diagram. Eight copy-and-try examples."
---

# Visualisation Lab

The [Visualisation Gallery](/synapse/synapse-features/visualisation-gallery/visualisation-gallery)
animates code that an author wrote into a lesson. The **Visualisation Lab** at
**[/viz](/viz)** does the same for code **you** write. Paste a program, press **Trace**, and step
through it one line at a time. It is a real run in the same sandbox that powers every **Run**
button, not a simulation.

The page is not in the navigation bar, like the `/d2` and `/mermaid` editors. Open it from
[/viz](/viz) or from a link on this page.

---

## The page at a glance

| Where | What it is |
|---|---|
| **Left pane — the canvas** | The picture of the run. It has a **Structure** picker, a **Root** box, **Copy as d2** and **Trace**. |
| **Right pane, top — the workbench** | An ordinary editor with **Run**, and Python and Java tabs. You can type without signing in, because this page has no authored code to protect. |
| **Right pane, middle — the console** | Everything that describes the *code* rather than the data: which line you are on, the call stack, what the program has printed so far, the inputs it read, and its question when it waits for one. |
| **Right pane, bottom — STDIN** | The program's input, one line per `input()`. **Run** and **Trace** both read it. |

The left pane *draws*; the right pane *reads*. Drag the seam between them to give either side more
room. Your code, your STDIN and your structure choice save to this browser as you type, so a
reload loses nothing.

### The two arrows in the editor

When you step through a trace, the editor marks two lines, as a debugger does:

- **green** — the line that **just executed**;
- **red** — the **next line to execute**.

The console's legend names both colours and gives their line numbers. When both arrows fall on
the same line, for example a loop that runs one line again, they draw stacked. On the very last
step there is no red arrow, because the program has finished.

**Editing the code clears the trace.** A trace of different code would put its arrows on the
wrong lines, so the lab clears it. PythonTutor does the same.

### Stepping

Use the transport bar under the canvas (**First · Prev · Play · Next · Last**) or the slider. The
keyboard works too:

- <kbd>←</kbd> / <kbd>→</kbd> step back and forward.
- <kbd>Space</kbd> plays and pauses.
- <kbd>F</kbd> resets the zoom.
- <kbd>D</kbd> turns on diff mode, which stops only on steps that changed the structure.

<kbd>Ctrl</kbd>/<kbd>⌘</kbd> + scroll zooms the canvas, and dragging pans it.

---

## Two lenses on one run

A trace can answer two different questions, so the canvas has two tabs.

### Structure — "what shape is my data?"

This lens needs a **structure** and a **root**. The structure is one of the gallery's renderers:
`array`, `grid`, `stack`, `queue`, `deque`, `tree`, `heap`, `list`, `hashmap`, `graph`, `trie`,
`union-find`, `fenwick`, `bitset`, `skiplist`, `segment-tree` or `callstack`. The root is the
variable to watch, such as `arr`, `head` or `self.root`. The lens draws that one structure with
the gallery's own animation.

- Leave **Root** blank to let the lab find the structure itself. It picks the biggest data
  structure nothing else points at.
- If you type a root that does not exist, the lab **says so**. It never quietly draws some other
  variable under the name you typed.
- If the program has no structure of that shape, the lens shows an objection and points you to
  the other tab.

### Frames & objects — "what does memory look like?"

This lens needs nothing. It draws **every frame** on the left, **every object** the program can
reach on the right, and **an arrow for every reference**. It follows the PythonTutor layout:

- **Frames** stack top to bottom: the *Global frame* first, then each call below its caller. The
  running frame is highlighted, and a caller's arrows are dimmed.
- **Objects** sit in columns by depth. A frame's objects are in the first column, the objects
  those point at in the next, and so on. A linked list therefore reads left to right, and a
  matrix's rows sit beside the matrix.
- A **list** draws as an indexed strip. An empty one says `empty list`.
- A **function** shows its signature, for example `function spiralOrder(self, matrix)`. A **class**
  you defined lists its methods, each with an arrow to its function box.
- When a function returns, its frame shows a red **Return value** row.
- A value that just changed is marked, and an object that just appeared is marked as new.

When the Structure lens has nothing to draw, the lab opens the trace on this lens instead, so the
run is never a dead end. Each lens keeps its own step counter, because the two count different
steps.

### Output arrives as you step

In the Frames & objects lens, **Program output** in the console shows only what the program had
printed **by the step on screen**. Step forward and the output grows. Showing it all at step 1
would hand you the answer before the program had worked it out.

---

## Programs that ask for input

The sandbox runs a program once, with all of its stdin fixed up front, so nobody can type into a
running program. The lab gets around that by **asking, then re-running**:

- **STDIN first.** Every line in the STDIN box feeds one `input()`, in order.
- **With Trace**, a program that wants more input than the box holds **stops at that point**. The
  trace opens on the step that asks, and the console shows the program's own question in an
  input box that already has focus. Type an answer and press <kbd>Enter</kbd>. The program re-runs
  from the top with every earlier answer plus the new one, and lands **one step past** the
  question, on the first step that uses what you typed. The **User inputs** list strikes through
  each value once the step on screen has read it.
- **With Run**, a program that runs out of input shows **Waiting for input** rather than an error.
  The STDIN area becomes the prompt and takes focus. Press <kbd>Enter</kbd> and your answer is
  added to the STDIN box as its next line, then the program runs again.

Only Python programs are asked. A Java program simply stops when its input runs out.

## When a program crashes

A program that raises an exception still traced every step up to the crash, so the lab shows
them all. The console shows a red card with the exception, its message and its line. **Show me**
jumps to the step that raised it. A program that does not compile shows the compiler's reason
instead of an empty canvas.

## Exporting to D2

**Copy as d2** turns the Structure lens into a diagram you can put in a lesson:

- **Copy this step** — the step on screen, as a ` ```d2 ` fence.
- **Copy walkthrough** — the steps that changed something, as a clickable ` ```d2 boards ` fence
  (see [D2 walkthroughs](/synapse/synapse-features/reading-a-lesson/d2-walkthroughs)).
- **Open this step in /d2** — hands the diagram to the [D2 editor](/d2) to edit.

Only the Structure lens exports. The memory picture is a view of one run, not a document.

---

## Examples to try

Copy each program into the lab's editor. Set the **Structure** and **Root** as listed, or use the
link, which sets them for you. Then press **Trace**. Leave STDIN empty unless the example says
otherwise.

### 1 · Two pointers on an array (Structure lens)

**Structure** `array` · **Root** `arr` · [open](/viz?s=array:arr&lang=python)

```python
arr = [5, 2, 8, 1, 9, 3]
left, right = 0, len(arr) - 1
while left < right:
    arr[left], arr[right] = arr[right], arr[left]
    left += 1
    right -= 1
print(arr)
```

**Look for:**
- `left` and `right` show as carets under the cells and march inward.
- Each swap rings the two cells it touched.
- Press <kbd>D</kbd> to skip the steps where nothing moved.

The same program is the lab's Java starter. Switch to the **Java** tab and trace it again to
compare the two tracers.

### 2 · Reversing a linked list (Structure lens, then Frames & objects)

**Structure** `list` · **Root** `head` · [open](/viz?s=list:head&lang=python)

```python
class Node:
    def __init__(self, val, next=None):
        self.val = val
        self.next = next

head = Node(1, Node(2, Node(3, Node(4))))

prev = None
cur = head
while cur:
    nxt = cur.next
    cur.next = prev
    prev = cur
    cur = nxt
head = prev
```

**Look for:**
- In **Structure**, the arrows flip one node at a time.
- Switch to **Frames & objects**. The four `Node` boxes read left to right. `prev`, `cur` and
  `nxt` are three arrows from the Global frame that slide along the list.
- The class body is **not** stepped. The trace jumps from `class Node:` straight to `head = …`.

### 3 · Aliasing (Frames & objects only)

**Structure** `array` · **Root** `a`, then switch to **Frames & objects**

```python
a = [1, 2, 3]
b = a            # the same list, not a copy
c = list(a)      # a new list
b.append(4)
print(a, c)
```

**Look for:**
- `a` and `b` are two arrows into **one** strip, and `c` points at its own.
- When `b.append(4)` runs, `a`'s list grows too. That is aliasing, drawn.

### 4 · Recursion and return values

**Structure** `callstack` (no root) · [open](/viz?s=callstack&lang=python)

```python
def fact(n):
    if n <= 1:
        return 1
    return n * fact(n - 1)

answer = fact(4)
print(answer)
```

**Look for:**
- In **Structure**, the stack grows to four frames and unwinds.
- In **Frames & objects**, each `fact()` frame appears under its caller.
- On the way back up, each returning frame shows a red **Return value** of `1`, `2`, `6`, `24`.

### 5 · A program that asks (interactive input)

**Structure** `array` · **Root** `nums` · leave **STDIN empty** · [open](/viz?s=array:nums&lang=python)

```python
n = int(input("How many numbers? "))
nums = []
for i in range(n):
    nums.append(int(input(f"Number {i + 1}: ")))
print("Sum:", sum(nums))
```

**Try it with Trace:**
1. Press **Trace**. The trace opens on the step that asks, and the console shows
   `How many numbers?` in a box that already has focus. It opens on **Frames & objects**, because
   `nums` does not exist yet and the Structure lens has nothing to draw.
2. Type `3` and press <kbd>Enter</kbd>. You land one step past the question, with `n` now `3`.
   The console says *Keep stepping*, because the next question is further on.
3. Press ⏭ (**Last step**). The program asks `Number 1:`. Answer it, and repeat for all three
   numbers. **User inputs** lists each value, struck through once the step on screen has read it.
4. Step backwards. Values the program has not reached yet stop being struck through.

**Try it with Run:**
1. Clear STDIN and press **Run**. The output shows **Waiting for input**, and the STDIN area
   becomes the prompt, quoting `How many numbers?`.
2. Answer each question with <kbd>Enter</kbd>. Every answer is added to the STDIN box as a new
   line, so at the end the box holds the program's whole input.

**Try it the batch way:**
1. Put all four lines in STDIN up front (`3`, `10`, `20`, `30`).
2. Press **Trace**. It runs to the end without asking.

### 6 · Spiral matrix: classes, methods, comprehensions and input

This is the program the lab was checked against PythonTutor with.

**Structure** `grid` · **Root** `rows` · leave **STDIN empty** ·
[open](/viz?s=grid:rows&lang=python)

```python
class Solution:
    def spiralOrder(self, matrix):
        ans = []
        m, n = len(matrix), len(matrix[0])
        top, bottom, left, right = 0, m - 1, 0, n - 1
        while top <= bottom and left <= right:
            for j in range(left, right + 1):
                ans.append(matrix[top][j])
            top += 1
            for i in range(top, bottom + 1):
                ans.append(matrix[i][right])
            right -= 1
            if top <= bottom:
                for j in range(right, left - 1, -1):
                    ans.append(matrix[bottom][j])
                bottom -= 1
            if left <= right:
                for i in range(bottom, top - 1, -1):
                    ans.append(matrix[i][left])
                left += 1
        return ans

inner = input("Matrix (e.g. [[1, 2, 3], [4, 5, 6], [7, 8, 9]]): ")
rows = [[int(x) for x in r.split(",")] for r in inner.strip()[2:-2].split("], [")]
print(Solution().spiralOrder(rows))
```

When it asks, answer `[[1, 2, 3], [4, 5, 6], [7, 8, 9]]`.

**Look for:**
- The `Solution class` box lists `spiralOrder`, with an arrow to
  `function spiralOrder(self, matrix)`.
- While the `rows = …` comprehension runs, its loop variables sit in their own
  **comprehension** frame under the Global frame. `Solution` and `inner` stay visible the whole
  time.
- Inside `spiralOrder()`, `matrix` points at a list whose three rows sit in the next column.
- `ans` starts as `empty list` and fills in spiral order.
- The Global frame's arrows are dimmed while the call runs.
- The last step shows only the green arrow, and the output is `[1, 2, 3, 6, 9, 8, 7, 4, 5]`.

In **Structure**, `rows` draws as a 3×3 grid once the input has been parsed. The details above
are all in **Frames & objects**.

### 7 · A crash

**Structure** `array` · **Root** `values` · [open](/viz?s=array:values&lang=python)

```python
values = [4, 2, 0, 5]
ratios = []
for v in values:
    ratios.append(10 // v)
print(ratios)
```

**Look for:**
- A red card in the console reads `ZeroDivisionError: integer division or modulo by zero`, with
  its line.
- **Show me** jumps to the step that raised it, the third time round the loop, with `ratios`
  holding `[2, 5]`.

### 8 · A root that isn't there

**Structure** `list` · **Root** `head`, on the program from example 1

**Look for:**
- The trace opens on **Frames & objects**, because the Structure lens has nothing to draw.
- Switch to **Structure**. It says it could not find `head`, rather than drawing `arr` under a
  borrowed name.
- Set **Structure** back to `array`, clear the **Root** box and trace again. The lab finds `arr`
  on its own.

---

## Limits worth knowing

- **Languages.** Python and Java trace. Interactive input is Python only.
- **Size.** A trace keeps at most 600 steps and 400 objects, and anything past that is cut off.
  Trace a small input rather than a long loop.
- **Python version.** The sandbox runs Python 3.13, and PythonTutor runs 3.11. A comprehension in
  3.13 is part of the function that runs it rather than a call of its own. Step counts can
  therefore differ from PythonTutor's even when the pictures match.
- **Only the code you wrote is stepped.** Library calls and class bodies run in a single step.
- **Runs are rate-limited**, like every Run button on the site. If the canvas says
  `Rate limit exceeded: Retry after 49s`, wait that long and press **Trace** again.
- **Screen height.** On a short window the Structure canvas gets cramped. Drag the drawing to pan,
  or <kbd>Ctrl</kbd>/<kbd>⌘</kbd> + scroll to zoom out.
