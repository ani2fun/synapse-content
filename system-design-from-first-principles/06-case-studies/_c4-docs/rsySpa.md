---
title: Reader SPA
kind: Web application
technology: Scala.js · Laminar
---

## Reader SPA

The reading UI, the code editor, and the result display — everything interactive is client-side,
so the origin serves **data, not pages**. Served as static, immutable-cached assets from the edge;
after first load, a reading session touches the origin only for content JSON (usually
edge-served) and the run/submit APIs.

**Responsibilities**

- Render lessons: prose, diagrams, syntax-highlighted and runnable code blocks.
- The workbench: edit a starter, `POST /run` for interactive feedback, `POST /submissions` and
  poll for the verdict (the ~1 s poll loop is the client's half of the async judging contract).
- The OIDC dance (authorization code + PKCE) against the identity provider — once per session;
  the resulting token rides API calls and is verified locally at the origin.

**Design notes**

Anonymous readers get the full reading + run experience — sign-in gates only editing persistence
and submissions. The judged verdict, including the one revealed failing case, is rendered from the
server's response; the hidden suite itself never reaches this component.
