---
title: User
kind: Actor
technology: Web browser
---

## User

The **User** is the person the app exists for — someone opening it in a web browser to get something done.

In C4 terms this is an **actor**: a role that lives *outside* the system's boundary. The user never talks to the
server directly; everything they do goes through the **Client** (the box this one points to).

**What to notice**

- The arrow **User → Client** is labelled *uses (HTTPS)* — every interaction is a request sent from the browser.
- The user has no idea whether there's one server or a thousand behind the Client. That's the whole point of a
  boundary: the architecture inside can change completely without changing what the user sees.
