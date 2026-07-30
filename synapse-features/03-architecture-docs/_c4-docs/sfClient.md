---
title: Client
kind: Container
technology: Browser SPA
---

## Client

The **Client** is the single-page app that runs in the user's browser: it renders the UI, holds view state, and
turns clicks into API calls.

**Responsibilities**

- Render the interface and react to user input.
- Call the **Server & DB** over HTTP for anything it can't do locally — data, authentication, persistence.
- Keep the experience fast: cache what it can, show optimistic UI, and avoid a round-trip when it doesn't need one.

**Where it breaks first.** A pure client can't be the source of truth — two browsers can't see each other's writes
until the server tells them. The moment you need shared, durable state, you need the box it points to.
