---
title: "Appendix B — Glossary"
summary: "The vocabulary this codebase uses in a specific way — starting with the one term that is routinely misread, including by people who should know better."
essential: false
---

# Appendix B — Glossary

Every project grows private vocabulary. It is efficient right up to the moment someone reads a term
as its industry meaning and quietly draws the wrong conclusion.

## oracle

**In this codebase: the previous implementation, used as the reference specification.**

Nothing to do with Oracle the database company, Oracle Cloud, or an Oracle instance. It is
[the testing sense](https://en.wikipedia.org/wiki/Test_oracle) — a source of known-correct answers.
This platform was rebuilt in a new language, and the previous version served as the specification:
its test suites defined correct behaviour, its golden files defined correct output, and its live
deployment was the parity target.

**This entry exists because the term was misread during the writing of this very book.** A file named
`openapi.oracle.yaml` was reasonably taken to mean "the OpenAPI spec for our Oracle instances" — a
sentence that makes complete sense and is entirely wrong. There are no Oracle instances anywhere in
this system.

That is the whole argument for a glossary. The misreading was not careless; it was the *obvious*
reading for anyone who has met the industry meaning first. Vocabulary that requires context to
disambiguate will eventually be read without that context.

The file should probably be renamed `openapi.reference.yaml`.

---

## Architecture and code

**bounded context** — a self-contained area of the domain with its own vocabulary, types and rules:
`catalog`, `execution`, `submission`, `identity`, `blog`, `authoring`, `progress`, `insights`,
`tutoring`, `platform`. Each is a directory and an error type, not a service. They are deliberately
different sizes — two of them are three files each.

**port** — a trait an application layer *declares* describing what it needs from the outside world
(`ContentRepository`, `CodeRunner`). Named for the thing needed, never for the technology providing
it.

**adapter** — an implementation of a port (`PostgresSubmissionRepository`). Ports point inward,
adapters live at the edge.

**seam** — a deliberate boundary where one kind of code stops and another begins, chosen so both
sides can change independently. The island boundary is a seam; so is the port layer.

**hexagon** — shorthand for the ports-and-adapters layering of a context: `domain` → `application` →
`infrastructure` → `http`.

**gate** — an automated check that fails the build on a threshold: purity greps, file-size caps, the
bundle budget. Distinguished from a convention by being unignorable.

**watermark** — a cheap value that changes when content changes, used to invalidate caches. In
production it is the content repository's commit hash.

---

## The web tier

**island** — a unit of interactivity that hydrates independently on a server-rendered page: the
workbench, the quiz, the diagram renderers, the auth store, the visualiser. Islands share no state
with each other, only the DOM and named events.

**loader** — the thin module standing in front of a heavy dependency (the editor, mermaid, d2, the
tracers, the viz bundle) so it is reached by dynamic import. What makes a dependency lazy is the
loader, not the library.

**seam contract** — the single module declaring every cross-island event name and window provider.
The alternative — an event string spelled in two files — fails silently.

**eager** — of an asset: referenced by a page's HTML, so the browser fetches it before content is
readable. The per-page budget measures exactly this, and "an island went eager" is the regression it
exists to catch.

**placeholder** — what the markdown pipeline emits instead of a finished widget: a `div` carrying a
diagram's source or a quiz's JSON, which an island claims on mount.

**signal** — a reactive value; the previous client's core primitive. Retained in the vocabulary
because the visualisation bundle still uses them internally, and because the *absence* of a shared
signal graph is what forces the seam contract above.

**chrome** — the UI framing around content: toolbars, close buttons, zoom controls, the sidebar.
Distinguished from the content it frames.

**workbench** — the two-pane problem interface: editor on one side, tests and results on the other.

**codebench** — the standalone popped-out editor, as opposed to a block embedded in a lesson.

**block** — one rendered unit inside a lesson: a runnable block, a quiz block, a diagram block.

**variant** — one language's version of a grouped fence. Adjacent `python` and `java` fences become
one block with two variants.

---

## Visualisation

**spine** — the shared machinery every visualisation widget uses regardless of what it draws:
stepping, playback, the frame panel, the legend.

**family** — a way of *drawing* (`Cells`, `Tree`, `Buckets`, `Force`, …). Twelve of them. Distinct
from a structure, which is what a thing *is* — seventeen of those.

**card** — a panel grouping one visualised value with its label and controls.

**cue** — a visual signal about what changed in a step: a ring on a touched cell, a highlight, a
fade.

**cursor** — a labelled pointer drawn onto a structure, promoted from an integer local like `left` or
`i`. Cursors are what make an algorithm's *idea* visible rather than just its data.

**root** — the object a visualisation is about, named in the fence (`viz=array:nums` roots at `nums`).
A heap contains many objects; the picture is about one.

**slot** — a position within a structure's layout, distinct from an object's identity. Contents move
between slots; identity does not.

**adapt pipeline** — the stages turning raw heap snapshots into drawable steps: cleanup,
segmentation, rooting, projection, cursors, flow, diff, narration.

**golden** — a recorded expected output used as a test fixture. The rebuild was specified by the
previous implementation's goldens.

---

## Operations

**git-sync** — the sidecar that fetches content commits and repoints the `current` symlink. The
symlink swap is what makes a content update atomic.

**fail fast** — exit on a dependency the application cannot serve correctly without (Postgres), as
opposed to **degrade** — keep serving what still works (Keycloak).

**grace window** — the age threshold before the reconciler treats an unfinished submission as
abandoned. Fifteen minutes, so a sweep never steals work another process is legitimately doing.

**reconciler** — the startup sweep that completes submissions a dead process left unfinished. The
other half of returning 202.

**promote** — commit a newly built image tag to the infrastructure repository, which is what actually
triggers a deployment.

**trigger** — in the scaling plan, the observable condition that justifies a deferred piece of work.
A deferral without one is an excuse.

---

## Contribution

**forge** — the hosting service a repository lives on, named as a role rather than as a product so
the port can have more than one implementation. `ContentForge` is the port; GitHub and a dry run are
its adapters.

**dry run** — a deployment mode, not a test double: the whole contribution flow executes and only the
forge call is skipped. Development, CI and the browser suite run in it.

**drift** — a lesson file changing on disk while someone has it open in the editor. Caught by a
fingerprint rather than a lock, and answered with 409.

**fingerprint** — a non-cryptographic digest of a lesson's *normalised* text, handed to an editor and
presented back on submit. A drift detector; nothing is authorised by it.

**attempt** — the counter that distinguishes a contributor's second proposal for a page from their
first, once the first has merged or closed. It is what puts the `-2` on a branch name.
