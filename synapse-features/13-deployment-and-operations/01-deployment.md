---
title: "Deployment"
summary: "The C4 deployment view: which node each container runs on, how a request reaches it, and how a push to main becomes a new image in production with no button to press."
essential: true
---

# Deployment

> **You'll be able to:** draw where every Synapse container runs in production; trace a request from
> the reader's browser to the pod; and follow a commit from `main` to a running image.

C4's deployment diagram maps the [containers](/synapse/synapse-features/containers/containers) onto
real infrastructure. For Synapse that is a four-node k3s cluster joined over WireGuard: one rented VPS
at the edge and three machines at home. The cluster and its history are the subject of
[the homelab case study](/synapse/synapse-features/deployment-and-operations/the-homelab-case-study);
this page is the map.

## Where the containers run

Every manifest lives in the infrastructure repository (`ani2fun/infra`, `deploy/apps/`):

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  node:   { style: { fill: "#fbfcfe"; stroke: "#94a3b8"; stroke-dash: 3; font-color: "#475569" } }
}

reader: "Reader" { class: client; shape: person }
cf: "Cloudflare\n[CDN · DNS]" { class: edge }

edge1: "ctb-edge-1 · rented VPS" {
  class: node
  traefik: "Traefik ingress\n[TLS: cert-manager, Let's Encrypt]" { class: edge }
}

wk1: "wk-1 · home worker" {
  class: node
  pod: "synapse pod" {
    style.fill: "#ffffff"
    origin: "origin + Astro\n[ghcr.io/ani2fun/synapse-rs]" { class: svc }
    d2: "d2-render sidecar\n[ghcr.io/ani2fun/synapse-d2-render]" { class: svc }
  }
  sync: "content-sync\n[git-sync]" { class: svc }
  judge: "synapse-go-judge\n[egress denied]" { class: svc }
  pvc: "content volume\n[local-path PVC]" { class: data; shape: cylinder }
}

pg: "PostgreSQL\n[databases-prod namespace]" { class: data; shape: cylinder }
kc: "Keycloak\n[keycloak.kakde.eu]" { class: edge }

reader -> cf: "synapse.kakde.eu"
cf -> edge1.traefik: "HTTPS"
edge1.traefik -> wk1.pod.origin: "over WireGuard"
wk1.pod.origin -> wk1.pod.d2
wk1.pod.origin -> wk1.judge
wk1.pod.origin -> pg
wk1.pod.origin -> kc: "JWKS"
wk1.sync -> wk1.pvc
wk1.pod.origin -> wk1.pvc: "reads /content/current"
```

| Workload | Kind | Placement | Notes |
| --- | --- | --- | --- |
| `synapse` | Deployment, `replicas: 1` | pinned to `wk-1` | two containers: the app (origin + Astro, port 8080) and the d2-render sidecar (port 8390) |
| `content-sync` | Deployment | pinned to `wk-1` | git-sync v4.4.0 every 60 s into the content volume |
| `synapse-go-judge` | Deployment, own Argo app | pinned to `wk-1` | requests 250m / 512 MiB, limits 2 CPU / 2 GiB, privileged, network policy denies all egress |
| PostgreSQL | shared cluster database | `databases-prod` namespace | database `synapse` |
| Keycloak | its own deployment | `keycloak.kakde.eu` | realm `synapse` |

Everything that Synapse owns is pinned to `wk-1` by hostname, because its volumes are node-local
(`local-path`). That is simple, and it concentrates risk on one machine — the case study measures what
that costs, and the scaling plan's first step is to spread it.

## A request's route

1. Cloudflare resolves `synapse.kakde.eu`, answers from its cache if it can, and otherwise forwards to
   the edge VPS's public address.
2. **Traefik** on `ctb-edge-1` terminates TLS with a certificate from cert-manager (Let's Encrypt,
   DNS-01) and routes the host to the `synapse` service.
3. The packet crosses the **WireGuard** mesh to `wk-1` — the cluster's node addresses *are* WireGuard
   addresses — and reaches the pod on port 8080.
4. The origin answers, or forwards a page to the Astro process in the same container.

The origin reads the real client IP from Cloudflare's `CF-Connecting-IP` header, but only on a request
that came through the edge; it is used for rate-limit budgets and nothing else.

## From `main` to production

There is no deploy button. Every push to `main` of the app repository that clears the gates ships:

```d2
direction: right

classes: {
  svc:  { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data: { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  gate: { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
}

push: "push to main\n[ani2fun/synapse]" { class: svc }
gates: "CI gates\n[conventions · clippy · tests · coverage · web · e2e · d2-render · go-judge ITs]" { class: gate }
build: "buildx → ghcr\n[:sha and :latest]" { class: data }
patch: "patch the image tag\n[ani2fun/infra kustomization]" { class: svc }
argo: "Argo CD\n[auto-sync · prune · self-heal]" { class: svc }
pod: "new synapse pod" { class: svc }

push -> gates -> build -> patch -> argo -> pod
```

- The release is a **job inside `ci.yml`**, not a separate workflow, so it can list every gate under
  `needs:`. A release that started before clippy finished would not be gated at all.
- `_build-push-promote.yml` builds the image, pushes it to GHCR tagged with the commit SHA and
  `latest`, then commits the new tag into the infrastructure repository's kustomization.
- Argo CD watches `deploy/apps/synapse/overlays/prod` on `main` with automated sync, prune and
  self-heal. Pushing the tag *is* the deploy.
- A docs-only commit skips the release, and the condition fails **open**: an unexpected filter result
  still ships, because shipping an identical tree costs five minutes while silently not shipping a
  code change leaves production disagreeing with `main`.
- The sandbox image has its own workflow (`go-judge-build-push-promote.yml`) and its own Argo app.

Content is not part of this path at all. A lesson reaches readers through git-sync and the satellite
sync loop, within a minute and with no image build — see
[The content pipeline](/synapse/synapse-features/containers/the-content-pipeline).

## Secrets

Three sealed secrets sit beside the production overlay: the database password, the GitHub token used
for satellite fetches and edit pull requests, and the Keycloak service-account secret used to delete
accounts. They are encrypted for the cluster's sealed-secrets controller, so the repository can be
public without exposing them, and they are injected as environment variables.
