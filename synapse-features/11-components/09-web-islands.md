---
title: "Web islands"
summary: "C4 level 3 for the browser side of the web tier: every island, what it mounts on, what it calls, and the nine named events that are the only way islands talk to each other."
essential: false
---

# Web islands

> **You'll be able to:** find the island behind any interactive part of a page; say which ones load on
> every page and which load only on demand; and list the events islands use to talk, and why there is
> no shared state.

The web tier server-renders every page as plain HTML. Interactivity is added by **islands**: each one
finds the markup it owns and hydrates it. Vanilla TypeScript is the default; Preact is used only where
there is real component state. Everything heavy is a dynamic import behind a loader, so a reader who
never opens an editor never downloads one.

## The islands

Grouped by where a reader meets them. Paths are under `web/src/islands/`.

| Island | Loads | Mounts on | Talks to |
| --- | --- | --- | --- |
| `auth/` (boot, account, admin panels) | every page | the header chip; `/account`; `/admin` | Keycloak via `keycloak-js`, `/api/me`, `/api/admin/*` |
| `palette.ts` (⌘K) | every page | a singleton modal | `/api/synapse/search` |
| `library.ts`, `tour.ts` | landing | the library and the tour carousel | — |
| `reader.ts`, `chrome.ts` | lesson pages | sidebar ticks, reading progress, the book drawer and Browse pill, floating navigation | `/api/progress` |
| `reader/privateLesson.ts` | private-book lessons | the lesson body | `/api/synapse/*` with the bearer |
| `widgets/` | lessons with widgets | quizzes, D2 and Mermaid diagrams, D2 walkthroughs, simulators, citations, the Codebench | `/api/synapse/d2/*`, `/simulators`, `/content-assets` |
| `workbench/` | lessons with runnable code | each runnable block: editor, run, tests panel | `/api/run` |
| `practice/`, `problem.tsx`, `problem-submissions.tsx` | problem pages | the problem layout, editorial, solution viewer, submissions | `/api/submissions` |
| `canvas/` | problem pages | the **Think** pane | `/api/canvas` |
| `notes/` | problem pages | the **Notes** tab | `/api/notes` |
| `coach/` | problem pages | the **Coach** tab | `/api/tutor/*` |
| `viz.ts` | on demand | the only code that loads the `viz-wasm` bundle | — |
| `vizlab/` | `/viz` | the visualisation lab | `/api/run` |
| `diagramlab/`, `d2lab/`, `mermaidlab/`, `labshell/` | `/d2`, `/mermaid` | the diagram editors and their split view | — (D2 drawn in the browser) |
| `authoring/` | `/edit/<path>` | the editor, preview, lint and review dialog | `/api/edits/*` |

## No shared state, only named events

Separate islands are separate mounts with no common reactive graph. So every seam between two of them
is an explicit `CustomEvent` or a provider on `window` — and all of them are declared **once**, in
`workbench/contracts.ts`, because an event name spelled in two files is a typo waiting to disagree.

| Event | Fired by | Heard by | Means |
| --- | --- | --- | --- |
| `synapse:load-code` | the editorial's copy-to-editor | a workbench | put this code in the editor |
| `synapse:use-case` | a Submissions row | the tests panel | add this failing input as a test |
| `synapse:submitted` | a workbench | the Submissions tab | refetch, a judgement finished |
| `synapse:code-changed` | a workbench, on every edit | the Coach | latest code, read at send time |
| `synapse:auth-changed` | the auth store | every sign-in gate | re-render, the user changed |
| `synapse:open-contents` | the problem page's Browse pill | `reader.ts` | open the book drawer |
| `synapse:relayout` | a pane that unhides an editor | Monaco | re-measure |
| `synapse:viz-ready` | the viz loader | every workbench | the Visualise button may now appear |
| `synapse:viz-rescan` | a pane that renders Markdown late | the viz loader | look again for widgets |

The cost, compared with one application owning one signal graph, is that every interaction across a
seam has to be designed and named. What it buys is that no island can depend on another's internals,
and any island can be deleted by removing its mount — its seams are listed in one file.

## Where the logic lives

Pure logic stays out of islands. It lives in `web/src/lib/` — the catalog tree and path resolution,
the run-block state machine, the judge's verdict shaping, the Markdown pipeline, search ranking, URL
shapes and SEO — and that is where the unit tests point. Islands are the thin part that touches the
DOM. [The web tier](/synapse/synapse-features/containers/the-web-tier) covers that split and the
per-page budget that keeps islands lazy.
