---
title: "Appendix A — The authoring reference"
summary: "The complete fence vocabulary and repository layout, verified against the renderer: every special block, what it produces, and the grouping rules that surprise people."
essential: false
---

# Appendix A — The authoring reference

This is the reference the rest of the book kept implying. Everything here is verified against the
renderer rather than remembered, because a wrong fence fails *quietly* — it renders as plain code
instead of the widget you meant.

## Repository layout

```
<book-slug>/
  book.json                        required — the book's metadata
  NN-<part-slug>/
    NN-<lesson-slug>.md            a lesson
    NN-<lesson-slug>.editorial.md  worked solutions, revealed on demand
    NN-<lesson-slug>.tests.json    hidden test suite — never served as content
    _c4-docs/<elementId>.md        click-docs for architecture diagram elements
    _media/                        images
    <name>.c4                      architecture model
local-only/                        never published
```

**`NN-` prefixes order; slugs identify.** `02-low-level-design/` sorts second and appears in the URL
as `low-level-design`. Renumbering changes order without changing any URL — only renaming the *slug*
breaks links.

### `book.json`

```json
{
  "title": "Synapse App From Scratch",
  "description": "…",
  "tags": ["architecture", "rust"],
  "estimatedReadingMinutes": 220,
  "order": 9,
  "slug": "synapse-app-from-scratch"
}
```

### Lesson frontmatter

```yaml
---
title: "The server hexagon"
summary: "One or two sentences shown in listings."
essential: true
---
```

## Fence vocabulary

Seven language names are **reserved** — the renderer claims them for widgets rather than
highlighting them as code:

```
mermaid · d2 · viz · quiz · problem · testcases · editorial
```

Anything else (`python`, `rust`, `sql`, …) is a display language, and its behaviour is decided by the
fence's **meta** — the text after the language name.

| Fence | Produces |
|---|---|
| ` ```python ` | a highlighted code card |
| ` ```python run ` | an interactive editor with a Run button |
| ` ```python run viz=array:nums ` | runnable **and** visualised, rooted at `nums` |
| ` ```python solution time=O(n) space=O(1) ` | a spoiler-safe revealed answer |
| ` ```mermaid ` | a rendered mermaid diagram |
| ` ```d2 ` | a rendered d2 diagram |
| ` ```viz widget=array ` | a declarative visualisation from an authored payload |
| ` ```quiz ` | an interactive question |
| ` ```problem ` | a problem workbench |
| ` ```testcases ` | the visible cases for the problem above it |
| ` ```editorial ` | an editorial section attached to the problem above it |

### The meta grammar, precisely

- **`run`** must appear as a bare word — `run` surrounded by whitespace or string boundaries. `runs`
  or `run=true` will not match.
- **`solution`** likewise, optionally with `time=` and `space=` annotations.
- **`viz=<structure>[:<root>]`** names the structure and, after a colon, the variable to draw. The
  root is what makes the picture about `nums` rather than about whichever object the tracer saw
  first.
- **`widget=<structure>`** on a `viz` fence switches it from traced to declarative.

The 17 structure names: `array` `grid` `stack` `queue` `deque` `tree` `heap` `list` `hashmap`
`graph` `trie` `unionFind` `fenwick` `bitset` `skiplist` `segmentTree` `callstack`.

### Adjacent fences group

This is the rule that most often surprises. Two `run` fences in different languages, written
back to back, become **one** card with a language switcher — not two cards:

````markdown
```python run
def solve(): ...
```

```java run
class Solution { }
```
````

The same grouping applies to `solution` fences and to plain display fences (which become tab groups).
If you want two separate cards, put something between them.

### Orphans render as plain code

A `testcases` fence with no `problem` above it, or a `viz` fence with no `widget=`, is not an error —
it renders as a highlighted code block. That is the quiet failure mode: **if a widget renders as
code, the fence did not match**, and the usual cause is a typo in the meta.

## Quiz payload

A quiz fence carries a single JSON object:

```json
{"prompt": "The question.", "options": ["A", "B", "C"], "answer": "B"}
```

The `answer` must be **exactly** one of the `options` strings — compared by string equality, not by
index. A mismatch produces a question that cannot be answered correctly, and nothing warns you.

Written as a ` ```quiz ` fence rather than the ` ```json ` shown above, that payload renders as an
interactive question instead of a code block. (This book does not use them; other books do.)

## Declarative visualisation payload

A `viz widget=<structure>` fence carries JSON with a `steps` array; each step is a full snapshot:

```json
{
  "steps": [
    {
      "nodes": [
        { "id": "0", "label": "a", "kind": "cell", "meta": [], "slot": 0, "cardId": "", "layoutKind": "" }
      ],
      "edges": [],
      "cursor": [{ "name": "left", "target": "0", "color": "#3b82f6" }],
      "highlight": [], "changed": [], "removed": [],
      "annotation": "What this step shows.",
      "line": 0, "frames": [], "cardCursor": []
    }
  ]
}
```

Every field is required even when empty. Use it to isolate a renderer bug from a tracer bug: if the
declarative version draws correctly but the traced one does not, the fault is upstream of rendering.

## Architecture diagrams

Embed a view by `iframe`:

```html
<iframe src="/c4/view/<viewId>" width="100%" height="620" loading="lazy"></iframe>
```

Then any element in that view can carry a click-doc at `_c4-docs/<elementId>.md`, resolved
**relative to the lesson doing the embedding** — so the same element can have a brief doc in an
overview chapter and a detailed one in a deep-dive chapter.

Four rules that are easy to get wrong:

1. **Exactly one `specification {}` exists across the whole merged workspace.** Adding a second
   breaks every architecture diagram on the site.
2. **Use a unique id prefix per book** so models cannot collide.
3. **List `include`s explicitly.** `include *` pulls in every other book's model.
4. **A container may not have a relationship to its own child.** This produces an error that does
   *not* fail the build — see below.

### The build exits 0 on invalid input

The diagram build **returns success while dropping invalid relationships**. Four broken
relationships in this book's model were silently discarded, and the only evidence was in the log.
Always grep it:

```bash
npx -y likec4@latest build --base /c4/ --output <dir> . 2>&1 | grep -iE "error|invalid"
```

An exit code you cannot trust is worse than no check, because it looks like verification.

## Verifying before publishing

1. Grep the diagram build log for errors (above).
2. Confirm every `<iframe src>` names a view that exists, and every element id has its click-doc.
3. Render each lesson locally: diagrams draw, widgets mount, quizzes hydrate, no console errors.
4. Confirm the book appears in the library index with the right title and order.

For step 3, note that diagrams are **viewport-lazy**: a diagram far down the page has not rendered
because nothing scrolled near it, which is not the same as having failed. Check by driving the
renderer directly rather than by asserting an `svg` exists — an Enlarge button contains an `svg` too,
and mistaking one for a rendered diagram is exactly the false positive this book hit while being
written.
