---
title: "Catalog and content"
summary: "C4 level 3 for the catalog context: how many content repositories become one library, how a lesson is resolved and served, how search reads the prose, and how private books stay private."
essential: true
---

# Catalog and content

> **You'll be able to:** trace a lesson request from URL to payload; explain how the catalog merges
> several repositories without one bad source taking the library down; and say why search can never
> show a page the site would not serve.

`catalog` is the largest context in the origin — about 5,700 lines without tests — and the reference
hexagon the others were modelled on. It owns everything about *what the library contains*: walking
the content checkouts, merging them, resolving a URL to a lesson, searching the prose, and the
registry of content repositories that `/admin` manages.

## The components

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  pure:   { style: { fill: "#ffffff"; stroke: "#16a34a"; stroke-dash: 3; font-color: "#14532d" } }
  external: { style: { fill: "#f8fafc"; stroke: "#94a3b8"; font-color: "#475569"; stroke-dash: 3 } }
}

web: "Web tier / browser" { class: client }

catalog: "catalog context" {
  http: "http/routes\n/api/synapse/*" { class: svc }
  admin: "http/admin\n/api/admin/content-sources/*" { class: svc }
  service: "CatalogService\n[version-gated index cache]" { class: svc }
  domain: "domain (pure)" {
    walker: "walker\n[one tree → catalog]" { class: pure }
    merge: "merge\n[N catalogs → one, first wins]" { class: pure }
    search: "search\n[BM25 over bodies]" { class: pure }
    lint: "lint\n[invisible mistakes]" { class: pure }
  }
  registry: "ContentSources\n[registry port]" { class: svc }
  sync: "sync loop\n[every 60 s]" { class: svc }
  fs: "FileSystemContentRepository" { class: svc }
  fetcher: "GitHubFetcher" { class: svc }
  cache: "content_cache\n[safe unpack]" { class: svc }
}

checkouts: "Content checkouts" { class: data; shape: stored_data }
db: "Postgres\n[content_source, content_source_reader]" { class: data; shape: cylinder }
github: "GitHub API" { class: external }

web -> catalog.http: "index, lesson, search"
web -> catalog.admin: "admin only"
catalog.http -> catalog.service
catalog.service -> catalog.fs: "load_tree, read_lesson"
catalog.service -> catalog.domain.walker
catalog.service -> catalog.domain.merge
catalog.service -> catalog.domain.search
catalog.fs -> checkouts
catalog.admin -> catalog.registry
catalog.registry -> db
catalog.sync -> catalog.registry: "what is registered"
catalog.sync -> catalog.fetcher: "new commit?"
catalog.fetcher -> github: "head, then tarball"
catalog.sync -> catalog.cache: "unpack, flip current"
catalog.cache -> checkouts
```

| Component | File | Job |
| --- | --- | --- |
| HTTP routes | `catalog/http/routes.rs` | `/api/synapse` (index), `/api/synapse/{*paths}` (lesson), `/api/synapse/search` |
| Admin routes | `catalog/http/admin.rs` | register, remove and sync sources; list warnings; grant and revoke private-book readers |
| `CatalogService` | `catalog/application/service.rs` | the use cases, with an index cache keyed on the content version |
| walker | `catalog/domain/walker.rs` | one checkout → books, chapters, lessons and the lesson-file map; strict about duplicate slugs |
| merge | `catalog/domain/merge.rs` | several walked catalogs → one; conflicts become warnings |
| search | `catalog/domain/search/` | full-text index over lesson bodies, BM25-shaped ranking, snippets |
| lint | `catalog/domain/lint.rs` | finds mistakes that render fine but are wrong; used by `validate_book` |
| `FileSystemContentRepository` | `catalog/infrastructure/filesystem.rs` | reads a checkout from disk, off the async threads |
| `ContentSources` / `PostgresContentSources` | `catalog/application/content_sources.rs` | the registry of satellite repositories and their readers |
| sync loop | `catalog/infrastructure/sync.rs` | reconciles registry, disk and the mounted set every 60 s |
| `GitHubFetcher` | `catalog/infrastructure/github_fetcher.rs` | asks GitHub for the head commit, then the tarball |
| content cache | `catalog/infrastructure/content_cache.rs` | the only code that unpacks an archive |

The four `domain/` modules are pure: standard library and `serde` only, enforced by the
[purity grep](/synapse/synapse-features/components/the-server-hexagon).

## Serving a lesson

A reader opens `/synapse/<book>/<chapter>/<lesson>`. The web tier asks the origin for
`/api/synapse/<book>/<chapter>/<lesson>` and gets one payload: the book and lesson references, the
parsed frontmatter, the raw Markdown, the previous and next lesson, and — for a problem — the
editorial and the **sample** test cases. The hidden cases never leave the server; the judge reads them
itself.

The index behind that lookup is cached and keyed on the **content version** — the commit hashes of
the mounted checkouts. A new push changes the version, so the next request rebuilds the index. There
is no purge to call. The directory walk is blocking filesystem work, so it runs off the async
runtime's threads rather than stalling unrelated requests.

A lesson that resolves also records one row of readership through the `insights` port. A 404 is not a
read, so it records nothing.

## Many sources, one library

The primary checkout is wired in code: it arrives by git-sync, is always mounted, and is always
**first**. Every other repository is a row in `content_source`, registered from `/admin`. On every
tick the sync loop reconciles three things that drift independently — what is registered, what is
on disk, and what the catalog is serving.

Two rules shape the loop:

- **A failing source never takes the library down.** A failure is recorded on the source's row and
  the tick moves on. A source that has never landed is simply an absent book; one whose fetch broke
  keeps serving the commit it already has. Stale content beats none.
- **An archive is untrusted.** A tar entry can name `../../etc/passwd`, an absolute path, or a symlink
  pointing anywhere. Every guard lives in the unpacker, because by the time a later path check runs
  the write has already happened. The unpacked commit goes into `<cache>/<id>/<sha>/` in full before
  a `current` symlink is flipped onto it — the same atomic trick git-sync uses.

`walker` and `merge` divide the work deliberately. `walker` interprets one tree and is strict: a
duplicate slug inside one checkout is an authoring bug and fails. `merge` takes catalogs that were each
already valid and resolves what only appears when they meet. Those conflicts are survivable, so they
come back as **warnings** — visible at `/api/admin/content-warnings` — and the first source wins.
Source order is what makes a migration safe: while a book exists both in the primary and in its new
repository, the primary's copy keeps serving until the new one is verified.

## Private books

A source can be `private` (ADR RS011). The catalog keeps an `Audiences` map — which readers may see
which source — and the same map gates three routes, so a source made private stops serving its
prose, its `/media` files and its lesson widgets on the same tick:

| Caller | Response |
| --- | --- |
| anonymous | 401 |
| signed in, not on the list | 403 |
| on the list | 200, `cache-control: private, no-store` |

The list is `content_source_reader`, edited from `/admin`. A public lesson never verifies a token at
all, which keeps the public read path free of identity-provider calls.

## Search reads the prose

Search used to match titles only, so a concept explained at length but never named in a heading was
unreachable. It now indexes lesson **bodies** across every mounted source, ranks with a BM25-shaped
score, and returns the sentence it matched as a snippet, which ⌘K shows.

The index is built from the walk's own lesson-file map. So it can only contain what the catalog
already serves: `local-only-content/`, `_`-prefixed files and the losing copy of a duplicated slug are
absent for the same reason they are absent from the site, not because of a second exclusion rule that
could drift from the first.

## Lint, before the push

`lint` exists because some mistakes are invisible on the rendered page. A lesson with no summary
renders fine and ships an empty meta description. A problem with no test suite renders a workbench
with nothing to judge. An orphaned `.tests.json` left behind by a rename is simply never read again.

The rules run in `validate_book`, a binary any content repository can run before it pushes
(`cargo run --bin validate_book -- <dir>`, or `dev-tools/validate-book`). It uses the server's own
walker, so what it reports cannot drift from what the site does — which matters most for a satellite
repository maintained by someone who cannot see the server. The admin's content warnings are a
different list: the conflicts `merge` found between sources.

<details>
<summary>Why is `blog` a separate context when it looks almost identical to `catalog`?</summary>

Lessons and posts share a filesystem seam and not much else. They have different lifecycles,
different URL shapes, and different metadata, and a post is never part of a book. Merging them would
couple two things that only look alike, and the first feature that one needed and the other did not
would turn into a flag. Keeping `blog` separate costs a few hundred lines of near-duplicate code.
That is cheaper than a shared abstraction over two things that are going to diverge.

</details>
