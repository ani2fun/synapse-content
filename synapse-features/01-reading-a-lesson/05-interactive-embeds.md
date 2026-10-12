---
title: "Interactive embeds"
summary: "Simulators and lesson-local widgets: a small self-contained web app framed inside a lesson, with Enlarge, parameters from the fence, and the same privacy as the book it belongs to."
---

# Interactive embeds

Some ideas need a control the reader can push: a slider, a Step button, a packet you drag through the
network stack. For those a lesson can frame a **simulator** — a small, self-contained web page that
the content repository ships beside its prose.

## A widget that belongs to one lesson

The binary-search stepper below lives *beside this lesson*, in the chapter folder's
`_assets/_simulators/index.html`. Press **Step** and watch the range halve:

```simulator src=_assets/_simulators/index.html?target=23 height=170 title="Binary search, one step at a time"
```

The fence that draws it is one line with an empty body:

````markdown
```simulator src=_assets/_simulators/index.html?target=23 height=170 title="Binary search, one step at a time"
```
````

- `src=` is a path inside the lesson's own `_assets/_simulators/` folder, with an optional query. It
  may not contain `..`.
- `height=` is the frame's height in pixels; `title=` captions it and labels it for screen readers.
- The query reaches the widget as `window.synapseSimulator.params`, so one widget can serve several
  figures — this page could frame the same file again with `?target=72`.
- The **Enlarge** button opens the widget full screen, like any diagram.

The files are served at `/content-assets/<book>/<chapter>/<lesson>/_assets/_simulators/…` and are
**gated exactly like the book**: on a public book anyone can load them; on a private book only the
readers on its list can (ADR RS012). Anything else a lesson keeps in `_assets/` — its D2 sources in
`_assets/_diagrams/`, for example — is never served.

## A simulator a whole repository shares

When several lessons use the same app, it goes at the **root** of the content repository instead, in
`_simulators/<id>/`, and the fence names it:

````markdown
```simulator name=osi-encapsulation height=560 title="OSI Encapsulation Simulator"
```
````

That example is real: the system-design guide's networking lesson frames an OSI encapsulation
simulator this way (ADR RS006). The bundle is a static app — `index.html` plus its assets — served at
`/simulators/<id>/`.

## Writing one

A simulator is any static web page that works inside an iframe:

1. Keep it self-contained: `index.html` and files beside it, referenced by relative paths.
2. Read your parameters from `window.synapseSimulator?.params ?? new URLSearchParams(location.search)`.
   On a private book the reader page fetches the widget with the reader's credentials and frames it
   as `srcdoc`, which has no query string — so the page provides the parameters for you.
3. Respect `prefers-color-scheme` so it matches the reader's theme.
4. Keep it small and free of network dependencies, so it works for a reader on a slow connection.

If a fence is malformed — a missing `src`, a path with `..` — the lesson shows a visible authoring-error
card with the raw fence, never a silently missing embed.
