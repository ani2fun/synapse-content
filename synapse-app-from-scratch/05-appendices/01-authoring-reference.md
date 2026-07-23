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
    NN-<lesson-slug>.tests.json    the suite — only its sample cases reach the browser
    _c4-docs/<elementId>.md        click-docs for architecture diagram elements
    <name>.c4                      architecture model
_media/<book-slug>/<lesson-slug>/  images and video — at the REPOSITORY ROOT, served at /media/…
local-only/                        never published
```

**`NN-` prefixes order; slugs identify.** `02-low-level-design/` sorts second and appears in the URL
as `low-level-design`. Renumbering changes order without changing any URL — only renaming the *slug*
breaks links.

**Everything that is not excluded is a lesson.** The walker skips names beginning with `_` or `.`,
files ending `.editorial.md`, and the reserved companion directories — and renders every other `.md`
under a book as a visible page. A `README.md` dropped into a book directory becomes a lesson in the
sidebar, which is why author-facing notes live outside the book tree entirely.

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

One more field changes a lesson's *kind*:

```yaml
kind: problem
```

That single line does three things, and nothing else switches them on individually. It renders the
two-pane problem workbench instead of the prose page; it makes the lesson's `.editorial.md` sidecar
reachable (a lesson without `kind: problem` has its editorial silently ignored); and it makes the
`.tests.json` sidecar load.

### What the browser is allowed to see

The `.tests.json` sidecar is read twice, by two different consumers, and they are given different
things:

| Consumer | Gets |
|---|---|
| The reader's page | only the cases marked as **samples** |
| The judge, server-side | the whole suite |

So a suite can hold thirty cases while the workbench shows three, and the hidden ones are not
"hidden by the UI" — they are never serialised into the response. A malformed sidecar is a **loud
error** rather than a silently empty suite, on both paths, because a problem that quietly grades
against nothing is worse than one that fails to load.

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

The 17 structure names, spelled **exactly** as the parser accepts them:

```
array · grid · stack · queue · deque · tree · heap · list · hashmap
graph · trie · union-find · fenwick · bitset · skiplist · segment-tree · callstack
```

Two of those are **kebab-case**, and they are the two people get wrong. `union-find` and
`segment-tree` are the only accepted spellings; `unionFind` and `segmentTree` parse to nothing, and
the fence then falls through to a plain code block with no error — the failure mode described above,
in its most easily-missed form. Names are matched case-insensitively after trimming, so `Array` is
fine and `union_find` is not.

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

## Editing from inside the app

There is a second way to change a lesson, for people who do not want a checkout. An allow-listed,
signed-in reader gets a **Suggest an edit** link on a lesson; it opens a dedicated editor page with
the file's full source, frontmatter fence included, and a mandatory rendered preview before submit.
The server commits to `edit/<username>/<lesson-path>` and opens a pull request.

Four things are worth knowing before relying on it:

- **It edits existing `.md` lessons only.** No sidecars, no `book.json`, no new files, no media.
- **The frontmatter fence is part of what you are editing** — deleting it is refused, because it
  silently changes the page's title, summary and social tags.
- **A second edit while your pull request is open adds a commit to the same branch**, rather than
  opening a second one.
- **The editor is on its own page.** That is deliberate: a lesson page carries zero eager JavaScript
  for this feature, just a small link that a tiny island un-hides for an allow-listed caller.

The design is in [Content contribution, without git](/synapse/synapse-app-from-scratch/running-it/content-contribution).

## Verifying before publishing

1. Grep the diagram build log for errors (above).
2. Confirm every `<iframe src>` names a view that exists, and every element id has its click-doc.
3. Render each lesson locally: diagrams draw, widgets mount, quizzes hydrate, no console errors.
4. Confirm the book appears in the library index with the right title and order.

For step 3, note what is and is not in the server's response. **Prose and code blocks are rendered
server-side**, so "the text is there" is answered by `curl` — but every widget is a *placeholder* in
that HTML, claimed by an island on mount. A `div` carrying a diagram's source is what success looks
like in the raw response; the picture only exists after hydration.

Diagrams are additionally **viewport-lazy**: one far down the page has not rendered because nothing
scrolled near it, which is not the same as having failed. Check by driving the renderer directly
rather than by asserting an `svg` exists — an Enlarge button contains an `svg` too, and mistaking one
for a rendered diagram is exactly the false positive this book hit while being written.
