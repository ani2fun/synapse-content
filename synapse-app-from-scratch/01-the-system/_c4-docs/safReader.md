---
title: Reader
kind: Actor
---

## Reader

Reads anonymously. Identity is required only to edit code in place and to submit a solution for
judging — never to read, and never to run.

That split is deliberate and shapes the whole architecture: the read path can be cached globally and
served without ever consulting a database or an identity provider, which is why it is fast from
anywhere and survives the failure of almost everything behind it.
