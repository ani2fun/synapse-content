---
title: "The decision record"
summary: "Every architecture decision record of the Rust rebuild, RS001 to RS012: what each decided, whether it still stands, and which chapter of this book shows it in the code."
essential: false
---

# The decision record

The app repository keeps one record per architecture decision in
[`docs/adr/`](https://github.com/ani2fun/synapse/tree/main/docs/adr). A record is written once and
never rewritten. A decision that changes gets a new record that **amends**, **extends** or
**supersedes** the old one, and the old one says so at the top. This page is the index.

| ADR | Decision | Status | In this book |
| --- | --- | --- | --- |
| [RS001](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs001-the-rust-rebuild.md) | Rebuild the server in Rust: scope, stack and the disciplines (ports, purity, file caps) | accepted 2026-07-15, amended 2026-07-30 | [Why a rebuild](/synapse/synapse-features/system-context/why-a-rebuild), [The server hexagon](/synapse/synapse-features/components/the-server-hexagon) |
| [RS002](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs002-derivative-content.md) | Derivative study material never reaches the served catalog | accepted 2026-07-19, amended 2026-07-27 | [Catalog and content](/synapse/synapse-features/components/catalog-and-content) |
| [RS003](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs003-the-astro-web-tier.md) | The web tier is server-rendered Astro with TypeScript islands | accepted 2026-07-21 | [The web tier](/synapse/synapse-features/containers/the-web-tier) |
| [RS004](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs004-content-contribution.md) | Content edits are proposed in-app and land as pull requests | accepted 2026-07-23 | [Content contribution](/synapse/synapse-features/components/content-contribution) |
| [RS005](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs005-multi-repo-content.md) | The library is assembled from many content repositories | accepted 2026-07-27; amended by RS010, extended by RS011 | [The content pipeline](/synapse/synapse-features/containers/the-content-pipeline) |
| [RS006](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs006-simulator-embeds.md) | Simulators are static bundles content repositories ship and lessons frame | accepted 2026-08-03 | [Platform](/synapse/synapse-features/components/platform) |
| [RS007](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs007-ahead-of-time-d2.md) | D2 figures are drawn in each content repository's CI | **superseded** by RS009 on 2026-08-27 | [Containers](/synapse/synapse-features/containers/containers) (the history) |
| [RS008](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs008-test-placement.md) | A module's tests live at `<module>/tests.rs` and are not measured as production | accepted 2026-08-25 | [The server hexagon](/synapse/synapse-features/components/the-server-hexagon) |
| [RS009](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs009-on-demand-d2.md) | D2 figures are drawn on demand by a sidecar | accepted 2026-08-27 | [Containers](/synapse/synapse-features/containers/containers) |
| [RS010](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs010-retiring-likec4.md) | LikeC4 is retired; D2 draws every diagram | accepted 2026-08-28 | [System context](/synapse/synapse-features/system-context/system-context) — the walkthrough is D2 |
| [RS011](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs011-private-books.md) | Private books: a registered repository served to its reader list | accepted 2026-09-15 | [Catalog and content](/synapse/synapse-features/components/catalog-and-content) |
| [RS012](https://github.com/ani2fun/synapse/blob/main/docs/adr/rs012-lesson-local-assets.md) | A lesson's widgets live beside it in `_assets/`, gated like the book | accepted 2026-09-25 | [Platform](/synapse/synapse-features/components/platform) |

Older records with an `S` prefix (for example ADR-S025, which made the coach local-only) come from the
Scala implementation. Where one still governs behaviour, the code cites it in a comment and this book
names it where it matters.

## Reading the chain

Three pairs show how the record evolves without being edited:

- **RS007 → RS009.** Drawing D2 in CI fixed the reader's download size but made publishing a diagram a
  three-step affair, and kept two copies of one hash function in agreement by test alone. RS009
  measured the real cause of the memory problem RS007 had ruled out — the WebAssembly build, not D2 —
  and moved rendering into a native sidecar. RS007 stays in the record, marked superseded, with its
  reasoning intact.
- **RS005 → RS010.** Multi-repo content first merged every repository's LikeC4 models into one
  workspace. RS010 retired LikeC4, which removed that part of RS005 — so RS010 *amends* RS005 rather
  than replacing it.
- **RS005 → RS011.** Private books did not change how sources merge; they added an audience to each
  source. RS011 *extends* RS005.

A record that can only be appended to is accurate about the moment it describes. The trade-off is
that the current state has to be read across several records, which is what this table is for.
