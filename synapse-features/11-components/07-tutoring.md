---
title: "Tutoring"
summary: "C4 level 3 for the coach: a domain-free context whose only real logic is a system prompt, a single-hop proxy to any OpenAI-compatible model server, and a feature that is off in production by construction rather than by a flag."
essential: false
---

# Tutoring

> **You'll be able to:** describe the coach's request path end to end; explain why "disabled" means
> the route does not exist rather than a check that fails; and say what the coach is allowed to do and
> what it is never allowed to do.

The coach is the fourth tab on the problem page: a Socratic chat that answers with hints rather than
solutions. It is a **local-only** feature today. Production leaves `TUTOR_ENABLED` unset, so on the
live site the tab reads *"The coach is off — this feature is coming soon."*

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  external: { style: { fill: "#f8fafc"; stroke: "#94a3b8"; font-color: "#475569"; stroke-dash: 3 } }
}

pane: "Coach pane\n[problem page, 4th tab]" { class: client }
workbench: "Workbench\n[the reader's code]" { class: client }

origin: "Origin server" {
  config: "GET /api/tutor/config\n[always mounted]" { class: svc }
  chat: "POST /api/tutor/chat\n[mounted only when enabled]" { class: svc }
  service: "TutoringService\n[the system prompt]" { class: svc }
  client: "OllamaTutorClient\n[TutorClient port]" { class: svc }
}

model: "Model server\n[Ollama · llama3.1 by default]" { class: external }

workbench -> pane: "synapse:code-changed"
pane -> origin.config: "on mount"
pane -> origin.chat: "history + code snapshot"
origin.chat -> origin.service -> origin.client
origin.client -> model: "POST /v1/chat/completions"
```

## Three components and a prompt

| Component | File | Job |
| --- | --- | --- |
| HTTP | `tutoring/http/mod.rs` | `config` always answers; `chat` exists only when enabled |
| `TutoringService` | `tutoring/application/mod.rs` | adds the system prompt; passes the history through untouched |
| `OllamaTutorClient` | `tutoring/infrastructure/mod.rs` | one non-streaming `POST {base}/v1/chat/completions` |

There is no `domain/`. A chat turn's role and content *are* the whole model, so the context's only real
logic is the **system prompt**: steer with hints, never hand over a solution, and never score. The
coach cannot block a learner, because nothing it says is a verdict.

The adapter speaks the OpenAI-compatible chat API, so Ollama, LM Studio and vLLM all work behind it.
It forces HTTP/1.1 — local model servers are plain HTTP/1.1, and negotiating HTTP/2 against one that
does not support it stalls the connection, a lesson the go-judge adapter learned first. Timeouts are
60 s per request, because local CPU inference is slow, and 10 s to connect.

## Off means absent

When the coach is disabled, `/api/tutor/chat` is **never mounted**. There is no runtime check and no
`Disabled` error case — a request gets the router's ordinary 404. The pane fetches the config on
mount, and any failure at all falls to the *off* state, so a reader never sees a chat box that 404s.

This is the same pattern as the in-app editor (`CONTENT_FORGE=off`), the source registry and the d2
proxy: a route that exists but refuses is one misread boolean away from a route that exists and
accepts. A route that does not exist cannot be talked into anything.

## The code it sees

The coach answers about the reader's code, but islands cannot share state. So the workbench fires a
bubbling `synapse:code-changed` event whenever the editor changes, and the coach pane keeps only the
latest `(source, language)` snapshot in a ref. It reads that snapshot when the reader presses Send —
a snapshot, not a subscription. The transcript itself is page state and disappears on navigation;
nothing about a coaching session is stored.

<details>
<summary>What would it take to turn the coach on in production?</summary>

Configuration, for the code: `TUTOR_ENABLED`, `TUTOR_URL` and `TUTOR_MODEL`. The harder part is cost.
The decision record that made the coach local-only (ADR-S025) is carried forward in the scaling plan
(`docs/architecture/scaling-plan.md` in the app repository), which treats the coach as the one
feature whose spend grows with *engaged* users rather than with traffic. So it gets its own budget
before it ships: per-user daily quotas, a queue that shows the reader their position, and the rule
that the coach is the first thing shed under load.

</details>
