---
title: "Diagram labs"
summary: "The /d2 and /mermaid editors: write a diagram against a live preview that is the reader's own renderer, then copy the fence, download it, or propose it into a lesson as a pull request."
---

# Diagram labs

Two pages are editors rather than lessons: **[/d2](/d2)** and **[/mermaid](/mermaid)**. Each puts the
diagram source on the left and the live figure on the right, and the figure is drawn by the same
component a reader sees in a lesson — so what you preview is what will be published.

## What both labs do

- **Autosave.** The source is kept in this browser as you type. Close the tab and come back; it is still
  there. Nothing leaves the browser until you choose to send it.
- **A split you can drag**, and an Enlarge view of the figure.
- **Three ways out:** **Copy fence** to paste into a lesson, **Download** the source, or **Add to a
  lesson…**, which proposes it as a pull request (below).
- **Zoom** controls and a **Re-indent** button for the source.
- **Opening from a lesson.** Every rendered figure in a lesson has an **Edit** pill. It opens the right
  lab loaded with that exact fence, and proposing your change replaces the figure where it stands.

Neither lab needs an account to draw. Proposing a change needs you signed in and on the
content-editor list, exactly like **Suggest an edit**.

## `/d2`

D2 diagrams in Synapse can be **walkthroughs** — one source, many boards, clicked through by the reader
— so the D2 lab treats a document as a tree rather than a picture:

- The heading is the walkthrough's **root board title**, editable in place; its **name** sits on one
  quiet line beneath it. Both end up on the fence's opening line:
  ` ```d2 boards name="…" root="…" `.
- The preview is the reader's own board navigator. Click a node with a link badge and it drills down,
  exactly as it will in the lesson.
- **Export boards** downloads every board together, because a walkthrough is several figures at once.

Use it for architecture diagrams: the C4 walkthrough on
[System context](/synapse/synapse-features/system-context/system-context) opens in it from its **Edit** pill. The
templates in the [D2 component library](/synapse/synapse-features/d2-component-library/using-the-library)
paste straight in.

## `/mermaid`

Mermaid needs less. A ` ```mermaid ` fence has no info string, so a Mermaid diagram's title lives
inside the source, in a `---` frontmatter block at the top. The lab's heading edits that block for you,
which is why it appears in the editor as soon as you name the diagram. The preview parses and renders
in the browser, the same path a lesson takes.

## Add to a lesson

**Add to a lesson…** turns a diagram into a pull request against whichever repository owns the lesson
you pick. There is no separate endpoint behind it: the lab fetches the lesson's source, splices your
fence in, and sends the whole file through the same path as **Suggest an edit**. So it inherits that
path's checks — the content-editor list, the drift guard, the rate limit, and dry-run mode on a
development machine.

Two things follow from that:

- A second proposal for a lesson whose pull request is still open becomes **another commit on the same
  pull request**, not a new one, and the confirmation says which happened.
- Lessons under `local-only/` are never editable, so the picker leaves them out rather than letting the
  submit fail.
