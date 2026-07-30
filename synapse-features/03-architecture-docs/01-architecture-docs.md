---
title: "Architecture Docs You Can Click"
summary: "An embedded LikeC4 architecture diagram where every component is clickable — click a box to read its tutorial docs, right beside the diagram."
---

# Architecture Docs You Can Click

Synapse can embed **LikeC4 architecture diagrams** right in a lesson — and turn each diagram into an interface to
the documentation. Below is a minimal client–server app: a **User** talks to a **Client** (the app in their
browser), which talks to a **Server & DB**.

Try it: **click any component** — *User*, *Client*, or *Server & DB* — and its tutorial docs slide in from the
right. Click another component to switch context. (Use **Enlarge** to open the diagram fullscreen with pan and
zoom; the small ⇄ and 🪪 icons on each box are LikeC4's own relationship / details tools.)

<iframe
  src="/c4/view/sf_client_server"
  width="100%"
  height="480"
  loading="lazy"
  title="A simple client–server app"
></iframe>

Each component's write-up lives in a Markdown file **right next to this lesson** — a `_c4-docs/` folder in this same
directory, one file per component. So the diagram and its docs are authored and maintained together: the picture
*is* the table of contents.
