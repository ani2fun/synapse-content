# synapse-content

The content for **Synapse** — *books* of *lessons*, organised into *categories*. The Synapse server walks this
repo and serves it; **this README is the authoring guide and the contract** (the rules the walker enforces). No
build step: you add Markdown + two tiny JSON files, and the server picks it up.

---

## The one rule

**A directory that contains a `book.json` is a _book_.** Everything else is positional, relative to that book:

| Where | What it is |
|---|---|
| **above** a book | a **category** (categories nest to any depth; a book may also sit at the repo root with no category) |
| the book dir itself | a **book** (marked by `book.json`) |
| **below** a book | a **chapter** (a section; chapters nest too, up to 6 deep) |
| any `.md` file | a **lesson** |

That single rule is all the "wiring" there is: drop a `book.json` in and the directory becomes a book.

```
synapse-content/
  programming-languages/            ← a category (no book.json)
    category.json                   ← optional category metadata
    01-sql/                         ← a BOOK (has book.json); "01-" just orders it, URL slug is "sql"
      book.json                     ← REQUIRED — this is what makes it a book
      00-index.md                   ← a lesson at the book root
      01-foundations/               ← a chapter (section)
        01-what-is-sql.md           ← a lesson
        02-select.md                ← a lesson
  data-structures-and-algorithms/   ← a book at the repo root (categories are optional)
    book.json
    00-index.md
    02-linear-structures/
      01-arrays/                    ← a nested sub-chapter
        01-basics.md
```

---

## Quick start — add a new book

### 1. Pick where it lives
- **At the repo root** → the book has no category (like `data-structures-and-algorithms`).
- **Under a category** → put it inside a category folder (create one if needed, see step 4).

### 2. Create the book folder
Prefix it with `NN-` to order it among its siblings (optional but recommended): e.g. `programming-languages/04-rust/`.
The number is **stripped from the URL** — the folder `04-rust` is served as `rust`.

### 3. Add `book.json` (this is what makes it a book)
```json
{
  "title": "Rust",
  "description": "A practical, systems-first Rust course.",
  "tags": ["rust", "systems"],
  "estimatedReadingMinutes": 500,
  "order": 4
}
```

### 4. (Only if it's in a new category) add `category.json`
```json
{ "title": "Programming Languages", "description": "Languages, by depth.", "order": 1, "icon": "💻" }
```

### 5. Write lessons
Add `.md` files (and chapter folders for sections). Start with a `00-index.md` landing page:
```markdown
---
title: Rust
---

# Rust

Why Rust, and how this book is organised…
```

### 6. See it
- **Local dev:** make sure the file is under `SYNAPSE_ROOT` (default: the sibling `../synapse-content` clone). The
  running server picks up the change on the **next request** — no restart (see [Auto-reload](#auto-reload)).
- Browse `GET /api/synapse/index` to see it in the tree, and `GET /api/synapse/programming-languages/rust/index`
  to read the landing lesson.

That's it. There is no registration list, no build, no codegen — the folder layout *is* the source of truth.

---

## The two metadata files

Only two JSON files exist, and folder/file names carry everything else.

### `book.json` — required, at every book root
Its **existence** marks the book; every field is optional.

| Field | Type | Default | Purpose |
|---|---|---|---|
| `title` | string | humanized folder name | Book title (set it for acronyms — `SQL`, not `Sql`). |
| `description` | string | `""` | One-line blurb for the library card. |
| `tags` | string[] | `[]` | Topic tags. |
| `estimatedReadingMinutes` | int | — | Shown on the library card. |
| `order` | int | the folder's `NN-` prefix | Sorts the book among its siblings. |
| `slug` | string | order-stripped folder name | The book's **globally-unique** URL id. Set it once and renaming the folder won't break links. |

### `category.json` — optional, in a category folder
Everything optional; omit the file and the category falls back to its humanized folder name.

| Field | Type | Default | Purpose |
|---|---|---|---|
| `title` | string | humanized folder name | Category title on the library page. |
| `description` | string | — | Blurb. |
| `order` | int | the folder's `NN-` prefix | Sorts the category among its siblings. |
| `icon` | string | — | An emoji/short label for the library page. |

> **There is no `_section.json`.** A chapter's title is its humanized folder name and its order is the numeric
> prefix — nothing to maintain. A lesson's optional/essential status is its own frontmatter (below).

---

## Lessons & frontmatter

A lesson is a `.md` file. Optional YAML frontmatter (a `---` fence at the very top) overrides defaults:

```markdown
---
title: What is SQL?
summary: The relational model in one page.
essential: false
topics: [databases, relational-model]
---

# What is SQL?

Body markdown…
```

| Field | Type | Default | Purpose |
|---|---|---|---|
| `title` | string | first `# H1`, else humanized filename | Lesson title. |
| `summary` | string | — | Short blurb. |
| `essential` | bool | `true` | `false` marks an optional/reference lesson. |
| `topics` | inline list | — | `[a, b, c]` (flow style only — not a block list). |
| `kind` | string | — | Reserved for problem/workbench layouts (later phases). |
| `difficulty` | string | — | Reserved (problems). |

A missing or malformed `---` fence is treated as plain body — never an error.

---

## Ordering, naming & URLs

- **Order** with an `NN-` prefix on folders/files (`01-`, `02-`, …). It's stripped from the URL, so renumbering
  never breaks a link. `00-index.md` (or `index.md`) sorts **first** within its folder.
- **Titles** are the humanized name unless overridden (`01-what-is-sql` → "What Is Sql"). Set `title` explicitly
  for acronyms.
- **Slugs** are lowercase, made of letters / digits / `-` / `_`. A book's slug must be **globally unique**; a
  lesson's slug-path (chapter slugs + lesson, `/`-joined) must be unique **within its book**.
- **URLs mirror the tree** (every segment is real — no `%2F` encoding):
  ```
  /api/synapse/{category}/[…/{sub-category}]/{book}/{chapter}/[…]/{lesson}
  e.g.  /api/synapse/programming-languages/sql/foundations/what-is-sql
        /api/synapse/data-structures-and-algorithms/linear-structures/arrays/basics   (book at root)
  ```

---

## Modifying existing content

- **Rename a book folder** safely: set `book.json#slug` once, then the folder can be renamed/reordered without
  changing the URL.
- **Reorder** anything: change the `NN-` prefixes (or `order` in the JSON). URLs are unaffected (prefix is stripped).
- **Move a book** between categories: the URL's category segment changes (that's intentional — URLs mirror the
  tree). If you must keep the old URL, that's a redirect concern for the app, not the content.
- **Add a chapter**: just make a `NN-folder/` under the book and drop lessons in it (nest up to 6 deep).

---

## Auto-reload

You don't restart the server to see content changes.

- **Local dev** (`autoReload = true`): the server tracks a cheap `newestModifiedMs:fileCount` watermark over the
  tree. Add a book, edit a lesson, or delete a file — the **file count** or **newest modification time** moves,
  and the index rebuilds on the **next** request. Drop it in, refresh.
- **`git commit` alone changes nothing the server reads** — it serves the working tree, so your edits were already
  live when you saved them. Committing matters for **prod**: there a sidecar `git pull`s this repo and the server
  rebuilds when the **commit SHA** changes.

---

## Rules the walker enforces (so a bad drop fails loudly)

| Rule | Violation |
|---|---|
| Book slugs are globally unique | two books resolve to the same slug → rejected |
| Lesson slug-paths are unique within a book | two lessons collide after stripping `NN-` prefixes → rejected |
| Chapters nest at most **6** deep | a 7th level → rejected |
| Slugs are `[a-z0-9-_]` | a non-slug folder/file name → rejected |

If the index can't be built, the server logs the violation (and, in dev, the boot smoke-log won't show your book).

---

## What's ignored

`_`- and `.`-prefixed files and folders (e.g. `_draft.md`, `.git/`), non-`.md` files, and the companion folders
`examples/` and `c4/` are never treated as content — safe places for work-in-progress and supporting assets.

---

## Copy-paste scaffold

A new book under a (possibly new) category:

```
synapse-content/
  my-category/
    category.json          # { "title": "My Category", "order": 9, "icon": "📦" }
    01-my-book/
      book.json            # { "title": "My Book", "description": "…", "order": 1 }
      00-index.md          # ---\ntitle: My Book\n---\n# My Book\n…
      01-getting-started/
        01-hello.md        # ---\ntitle: Hello\n---\n# Hello\n…
        02-next-steps.md
```

`book.json` (root book — no category folder) is identical; just place `01-my-book/` directly under
`synapse-content/`.
