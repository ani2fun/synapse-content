---
title: "System design — primitives"
summary: "Every box a system-design diagram needs: 26 primitives with verified icons, the native shapes that beat an icon, and the boundaries that say what fails together."
---

# System design — primitives

A system-design diagram is mostly the same twenty-odd boxes, redrawn. This page is all of them,
grouped by tier, with the colour and the icon already decided — so drawing one is copying a line
rather than choosing a hex.

Every block below is one file under `synapse-features/_d2-blocks/system-design/`. Copy the whole
figure to start a diagram, or one line to add a box to a diagram you already have.

## The five roles

Colour carries the tier, not the technology. Two systems using entirely different products get the
same colours, and a reader who has seen one of your diagrams can read the next one.

| Role | Class | What wears it |
| --- | --- | --- |
| client | `client` | Browsers, apps, people, other companies' systems |
| edge | `edge` | DNS, CDN, load balancers, gateways, auth, rate limiting |
| service | `svc` | Anything running your code |
| data | `data` | Anything that holds state |
| async | `async` | Queues, topics, streams — anything that decouples in time |

Nothing here encodes a vendor. A Redis logo tells a reader which product you picked; the colour
tells them what the box is *for*, and only one of those two matters in a design review.

## Clients and callers

Everything that originates a request. Grey, because a caller is not part of your system.

```bash
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

web: "Web client\nbrowser" { class: client; icon: https://icons.d2lang.com/tech%2Fbrowser-2.svg }
mobile: "Mobile client\niOS · Android" { class: client; icon: https://icons.d2lang.com/tech%2F052-smartphone-3.svg }
desktop: "Desktop app" { class: client; icon: https://icons.d2lang.com/tech%2Fdesktop.svg }

# TODO: `person` is a native shape — no icon, no network, and it reads instantly.
person: "End user" { class: client; shape: person }
fleet: "User population\n10M MAU" { class: client; icon: https://icons.d2lang.com/essentials%2F359-users.svg }
partner: "Third-party API\nyou call out to" { class: client; icon: https://icons.d2lang.com/infra%2F010-data-sharing.svg }
```

```d2
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

web: "Web client\nbrowser" { class: client; icon: https://icons.d2lang.com/tech%2Fbrowser-2.svg }
mobile: "Mobile client\niOS · Android" { class: client; icon: https://icons.d2lang.com/tech%2F052-smartphone-3.svg }
desktop: "Desktop app" { class: client; icon: https://icons.d2lang.com/tech%2Fdesktop.svg }

# TODO: `person` is a native shape — no icon, no network, and it reads instantly.
person: "End user" { class: client; shape: person }
fleet: "User population\n10M MAU" { class: client; icon: https://icons.d2lang.com/essentials%2F359-users.svg }
partner: "Third-party API\nyou call out to" { class: client; icon: https://icons.d2lang.com/infra%2F010-data-sharing.svg }
```

`shape: person` needs no network and reads instantly — prefer it over an icon whenever the box is
a human rather than a machine.

## The edge

The tier between the internet and your code. These are the boxes that get skipped on a whiteboard
and then asked about: where TLS terminates, where a request is rejected, where a cache already
answered.

```bash
classes: {
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

dns: "DNS\nname → IP, TTL 60s" { class: edge; icon: https://icons.d2lang.com/essentials%2F140-internet.svg }
cdn: "CDN / edge cache\nstatic + cacheable GETs" { class: edge; icon: https://icons.d2lang.com/infra%2F040-global%20network.svg }
lb: "Load balancer\nL7, least-connections" { class: edge; icon: https://icons.d2lang.com/tech%2Frouter.svg }

gateway: "API gateway\nauthn · routing · quotas" { class: edge; icon: https://icons.d2lang.com/infra%2F025-plug-in.svg }
# TODO: a reverse proxy and a load balancer are drawn the same and decided differently —
# say which one you mean in the label.
proxy: "Reverse proxy\nTLS termination" { class: edge; icon: https://icons.d2lang.com/dev%2Fnginx.svg }
waf: "WAF / firewall\nIP + rule filtering" { class: edge; icon: https://icons.d2lang.com/infra%2F003-firewall.svg }
```

```d2
classes: {
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

dns: "DNS\nname → IP, TTL 60s" { class: edge; icon: https://icons.d2lang.com/essentials%2F140-internet.svg }
cdn: "CDN / edge cache\nstatic + cacheable GETs" { class: edge; icon: https://icons.d2lang.com/infra%2F040-global%20network.svg }
lb: "Load balancer\nL7, least-connections" { class: edge; icon: https://icons.d2lang.com/tech%2Frouter.svg }

gateway: "API gateway\nauthn · routing · quotas" { class: edge; icon: https://icons.d2lang.com/infra%2F025-plug-in.svg }
# TODO: a reverse proxy and a load balancer are drawn the same and decided differently —
# say which one you mean in the label.
proxy: "Reverse proxy\nTLS termination" { class: edge; icon: https://icons.d2lang.com/dev%2Fnginx.svg }
waf: "WAF / firewall\nIP + rule filtering" { class: edge; icon: https://icons.d2lang.com/infra%2F003-firewall.svg }
```

Each label carries the **decision** its box makes. Keep those when you adapt the block — an
unlabelled gateway is a box, a gateway labelled `authn · routing · quotas` is an answer.

## Compute

Anything running your code. The distinction worth drawing is not the runtime, it is whether a box
is on the request path — whether a user is waiting.

```bash
classes: {
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

app: "App server\nstateless · 12 instances" { class: svc; icon: https://icons.d2lang.com/tech%2F022-server.svg }
service: "Microservice\nowns one bounded context" { class: svc; icon: https://icons.d2lang.com/infra%2F022-hosting.svg }
farm: "Server fleet\nautoscaling group" { class: svc; icon: https://icons.d2lang.com/tech%2Fservers.svg }

# TODO: off the request path — nobody is waiting on these. Label the trigger.
worker: "Background worker\npulls from the queue" { class: svc; icon: https://icons.d2lang.com/essentials%2F204-settings.svg }
cron: "Scheduled job\nnightly rollup" { class: svc; icon: https://icons.d2lang.com/essentials%2F226-alarm%20clock.svg }
runtime: "Container\none image, N replicas" { class: svc; icon: https://icons.d2lang.com/dev%2Fdocker.svg }
```

```d2
classes: {
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

app: "App server\nstateless · 12 instances" { class: svc; icon: https://icons.d2lang.com/tech%2F022-server.svg }
service: "Microservice\nowns one bounded context" { class: svc; icon: https://icons.d2lang.com/infra%2F022-hosting.svg }
farm: "Server fleet\nautoscaling group" { class: svc; icon: https://icons.d2lang.com/tech%2Fservers.svg }

# TODO: off the request path — nobody is waiting on these. Label the trigger.
worker: "Background worker\npulls from the queue" { class: svc; icon: https://icons.d2lang.com/essentials%2F204-settings.svg }
cron: "Scheduled job\nnightly rollup" { class: svc; icon: https://icons.d2lang.com/essentials%2F226-alarm%20clock.svg }
runtime: "Container\none image, N replicas" { class: svc; icon: https://icons.d2lang.com/dev%2Fdocker.svg }
```

## Data stores

Where state lives, and the one tier where the native shape genuinely beats an icon: `cylinder`
says *database* with no fetch and no ambiguity.

```bash
classes: {
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

primary: "Primary\nwrites · strong reads" { class: data; shape: cylinder }
replica: "Read replica\nasync · lags ~100ms" { class: data; shape: cylinder }
# TODO: say what you sharded ON. A shard key with no rationale is the follow-up question.
shards: "Sharded store\nby user_id, 16 shards" { class: data; icon: https://icons.d2lang.com/infra%2F011-data-storage.svg }

cache: "Cache\nhot keys · TTL 5m" { class: data; icon: https://icons.d2lang.com/dev%2Fredis.svg }
nosql: "Document store\nkey lookups, no joins" { class: data; icon: https://icons.d2lang.com/dev%2Fmongodb.svg }
blob: "Object storage\nblobs · pay per GB" { class: data; icon: https://icons.d2lang.com/essentials%2F304-archive.svg }
```

```d2
classes: {
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

primary: "Primary\nwrites · strong reads" { class: data; shape: cylinder }
replica: "Read replica\nasync · lags ~100ms" { class: data; shape: cylinder }
# TODO: say what you sharded ON. A shard key with no rationale is the follow-up question.
shards: "Sharded store\nby user_id, 16 shards" { class: data; icon: https://icons.d2lang.com/infra%2F011-data-storage.svg }

cache: "Cache\nhot keys · TTL 5m" { class: data; icon: https://icons.d2lang.com/dev%2Fredis.svg }
nosql: "Document store\nkey lookups, no joins" { class: data; icon: https://icons.d2lang.com/dev%2Fmongodb.svg }
blob: "Object storage\nblobs · pay per GB" { class: data; icon: https://icons.d2lang.com/essentials%2F304-archive.svg }
```

Each label names the access pattern the store was chosen **for**. That is the answer to "why this
store?", and writing it into the box means never having to remember it.

## Async and messaging

The purple tier: everything that decouples a caller from a callee in *time*. A request that
crosses one of these stops being synchronous, and every guarantee changes with it.

```bash
classes: {
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

queue: "Work queue\nat-least-once · one consumer" { class: async; shape: queue }
topic: "Pub/sub topic\nfan-out to N subscribers" { class: async; icon: https://icons.d2lang.com/essentials%2F108-megaphone.svg }
stream: "Event stream\nordered, replayable log" { class: async; icon: https://icons.d2lang.com/infra%2F013-transfer.svg }

# TODO: a dead-letter queue is where you put the message you could not process. Draw it
# every time you draw a consumer — the design is incomplete without one.
dlq: "Dead-letter queue\npoison messages land here" { class: async; shape: queue }
hook: "Webhook\nyou push, they receive" { class: async; icon: https://icons.d2lang.com/essentials%2F287-link.svg }
socket: "WebSocket\nlong-lived, server push" { class: async; icon: https://icons.d2lang.com/essentials%2F103-wireless%20internet.svg }
```

```d2
classes: {
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

queue: "Work queue\nat-least-once · one consumer" { class: async; shape: queue }
topic: "Pub/sub topic\nfan-out to N subscribers" { class: async; icon: https://icons.d2lang.com/essentials%2F108-megaphone.svg }
stream: "Event stream\nordered, replayable log" { class: async; icon: https://icons.d2lang.com/infra%2F013-transfer.svg }

# TODO: a dead-letter queue is where you put the message you could not process. Draw it
# every time you draw a consumer — the design is incomplete without one.
dlq: "Dead-letter queue\npoison messages land here" { class: async; shape: queue }
hook: "Webhook\nyou push, they receive" { class: async; icon: https://icons.d2lang.com/essentials%2F287-link.svg }
socket: "WebSocket\nlong-lived, server push" { class: async; icon: https://icons.d2lang.com/essentials%2F103-wireless%20internet.svg }
```

The delivery semantics in those labels are not decoration. "At-least-once" is the reason a
consumer has to be idempotent, and it is the follow-up question every time.

## Platform and cross-cutting

The boxes that serve every other box — forgotten by candidates, and the ones operators care most
about.

```bash
classes: {
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

search: "Search index\ninverted · eventually consistent" { class: data; icon: https://icons.d2lang.com/essentials%2F313-search.svg }
warehouse: "Data warehouse\ncolumnar · analytics" { class: data; icon: https://icons.d2lang.com/infra%2F012-data.svg }
lake: "Cold storage\nraw events, cheap" { class: data; shape: stored_data }

auth: "Identity provider\nOIDC · issues tokens" { class: edge; icon: https://icons.d2lang.com/essentials%2F216-key.svg }
limiter: "Rate limiter\ntoken bucket, per key" { class: edge; icon: https://icons.d2lang.com/essentials%2F215-funnel.svg }
# TODO: name the three signals you actually collect — metrics, logs, traces.
telemetry: "Observability\nmetrics · logs · traces" { class: svc; icon: https://icons.d2lang.com/essentials%2F089-data%20analysis.svg }
```

```d2
classes: {
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

search: "Search index\ninverted · eventually consistent" { class: data; icon: https://icons.d2lang.com/essentials%2F313-search.svg }
warehouse: "Data warehouse\ncolumnar · analytics" { class: data; icon: https://icons.d2lang.com/infra%2F012-data.svg }
lake: "Cold storage\nraw events, cheap" { class: data; shape: stored_data }

auth: "Identity provider\nOIDC · issues tokens" { class: edge; icon: https://icons.d2lang.com/essentials%2F216-key.svg }
limiter: "Rate limiter\ntoken bucket, per key" { class: edge; icon: https://icons.d2lang.com/essentials%2F215-funnel.svg }
# TODO: name the three signals you actually collect — metrics, logs, traces.
telemetry: "Observability\nmetrics · logs · traces" { class: svc; icon: https://icons.d2lang.com/essentials%2F089-data%20analysis.svg }
```

## Service-to-service plumbing

What sits *between* your services once there are more than about five of them. The sidecar is
drawn as a container wrapping the service it proxies, because that nesting is the whole idea.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

registry: "Service registry\nwho is healthy, right now" { class: svc; icon: https://icons.d2lang.com/infra%2F014-network.svg }

pod: "Pod" { class: panel
  sidecar: "Sidecar proxy\nmTLS · retries · timeouts" { class: edge; icon: https://icons.d2lang.com/infra%2F019-network.svg }
  svc: "Your service" { class: svc; icon: https://icons.d2lang.com/infra%2F022-hosting.svg }
  sidecar -> svc: "localhost"
}

# TODO: point this at whatever actually holds your config — Consul, etcd, a config map.
config: "Config / secrets\nrotated, never in the image" { class: data; icon: https://icons.d2lang.com/infra%2F033-protection.svg }

registry -> pod.sidecar: "resolve"
config -> pod.sidecar: "certs"
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

registry: "Service registry\nwho is healthy, right now" { class: svc; icon: https://icons.d2lang.com/infra%2F014-network.svg }

pod: "Pod" { class: panel
  sidecar: "Sidecar proxy\nmTLS · retries · timeouts" { class: edge; icon: https://icons.d2lang.com/infra%2F019-network.svg }
  svc: "Your service" { class: svc; icon: https://icons.d2lang.com/infra%2F022-hosting.svg }
  sidecar -> svc: "localhost"
}

# TODO: point this at whatever actually holds your config — Consul, etcd, a config map.
config: "Config / secrets\nrotated, never in the image" { class: data; icon: https://icons.d2lang.com/infra%2F033-protection.svg }

registry -> pod.sidecar: "resolve"
config -> pod.sidecar: "certs"
```

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Icons are a runtime dependency.** D2 leaves an `icon:` as a remote `<image href>` and never
inlines the bytes — the reader's browser fetches every one from `icons.d2lang.com` when the page
loads. A reader with no route there sees the box and the label and nothing else. `./render.sh
icons` probes all 45 URLs and fails on any non-200, because the CDN answers **403** for a path
that does not exist and D2 turns an icon it cannot fetch into an empty box without a word of
complaint.

</div>

## Native shapes

Six shapes D2 draws itself. Prefer them over an icon whenever they fit: no network, clean at any
size, and meaning that survives greyscale.

```bash
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

db: "cylinder\nany database" { class: data; shape: cylinder }
q: "queue\na buffer, a backlog" { class: async; shape: queue }
# TODO: `cloud` means "someone else runs this" — a managed service, another company's API.
ext: "cloud\nnot your problem" { class: client; shape: cloud }

who: "person\nan actor, not a system" { class: client; shape: person }
raw: "stored_data\nfiles, blobs, a lake" { class: data; shape: stored_data }
stage: "step\none stage of a pipeline" { class: svc; shape: step }
```

```d2
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

grid-rows: 2
grid-columns: 3
grid-gap: 40

db: "cylinder\nany database" { class: data; shape: cylinder }
q: "queue\na buffer, a backlog" { class: async; shape: queue }
# TODO: `cloud` means "someone else runs this" — a managed service, another company's API.
ext: "cloud\nnot your problem" { class: client; shape: cloud }

who: "person\nan actor, not a system" { class: client; shape: person }
raw: "stored_data\nfiles, blobs, a lake" { class: data; shape: stored_data }
stage: "step\none stage of a pipeline" { class: svc; shape: step }
```

Reach for an icon only when the *specific technology* matters — a Redis logo says something a
cylinder does not. Where the category is the point, these win.

## Schemas

`shape: sql_table` turns a node's keys into typed rows, and a connection between two **rows**
draws the foreign key.

```bash
direction: right

users: {
  shape: sql_table
  id: "bigint" { constraint: primary_key }
  email: "text" { constraint: unique }
  created_at: timestamptz
}

# TODO: the access pattern this table exists to serve, in one comment, right here.
# "list a user's orders, newest first" → index on (user_id, created_at desc).
orders: {
  shape: sql_table
  id: "bigint" { constraint: primary_key }
  user_id: "bigint" { constraint: foreign_key }
  status: "text  -- pending | paid | shipped"
  total_cents: bigint
  created_at: "timestamptz  -- idx (user_id, created_at)"
}

items: {
  shape: sql_table
  order_id: "bigint" { constraint: foreign_key }
  sku: text
  qty: int
}

orders.user_id -> users.id
items.order_id -> orders.id
```

```d2
direction: right

users: {
  shape: sql_table
  id: "bigint" { constraint: primary_key }
  email: "text" { constraint: unique }
  created_at: timestamptz
}

# TODO: the access pattern this table exists to serve, in one comment, right here.
# "list a user's orders, newest first" → index on (user_id, created_at desc).
orders: {
  shape: sql_table
  id: "bigint" { constraint: primary_key }
  user_id: "bigint" { constraint: foreign_key }
  status: "text  -- pending | paid | shipped"
  total_cents: bigint
  created_at: "timestamptz  -- idx (user_id, created_at)"
}

items: {
  shape: sql_table
  order_id: "bigint" { constraint: foreign_key }
  sku: text
  qty: int
}

orders.user_id -> users.id
items.order_id -> orders.id
```

<div style="border-left:4px solid #da5233;background:rgba(218,82,51,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

⚠️ **Do not put a palette class on a `sql_table`.** D2 reads `style.stroke` as the *row fill* and
`style.fill` as the *header* fill, and leaves the header text white. So `class: data` paints solid
orange rows, and a light header fill makes the title invisible. The default styling is already
good. This is the one place in the library where the five-role palette does not apply.

</div>

## Boundaries

A container is a **blast radius**. Nesting says what fails together — and an AZ that can go dark
without taking the region with it only counts if you drew the second copy.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

region: "us-east-1 · region" { class: panel
  style.stroke-dash: 3

  az_a: "az-1a" { class: panel
    app_a: "App ×4" { class: svc }
    db_a: "Primary" { class: data; shape: cylinder }
    app_a -> db_a
  }

  # TODO: a second AZ is the minimum that survives one going dark. A third is what a
  # quorum-based store (etcd, ZooKeeper, a Raft group) actually needs.
  az_b: "az-1b" { class: panel
    app_b: "App ×4" { class: svc }
    db_b: "Standby" { class: data; shape: cylinder }
    app_b -> db_b
  }

  # Fully-qualified: written as `db_a -> db_b` these would be TWO NEW EMPTY NODES at region
  # scope, drawn as stray boxes. d2 creates an undeclared key rather than complaining.
  az_a.db_a -> az_b.db_b: "sync replication\nRPO 0" { class: hint }
}

lb: "Load balancer\ncross-AZ, health-checked" { class: edge }
lb -> region.az_a.app_a
lb -> region.az_b.app_b
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

region: "us-east-1 · region" { class: panel
  style.stroke-dash: 3

  az_a: "az-1a" { class: panel
    app_a: "App ×4" { class: svc }
    db_a: "Primary" { class: data; shape: cylinder }
    app_a -> db_a
  }

  # TODO: a second AZ is the minimum that survives one going dark. A third is what a
  # quorum-based store (etcd, ZooKeeper, a Raft group) actually needs.
  az_b: "az-1b" { class: panel
    app_b: "App ×4" { class: svc }
    db_b: "Standby" { class: data; shape: cylinder }
    app_b -> db_b
  }

  # Fully-qualified: written as `db_a -> db_b` these would be TWO NEW EMPTY NODES at region
  # scope, drawn as stray boxes. d2 creates an undeclared key rather than complaining.
  az_a.db_a -> az_b.db_b: "sync replication\nRPO 0" { class: hint }
}

lb: "Load balancer\ncross-AZ, health-checked" { class: edge }
lb -> region.az_a.app_a
lb -> region.az_b.app_b
```

The replication edge is written `az_a.db_a -> az_b.db_b`, fully qualified. Written as
`db_a -> db_b` at region scope, D2 creates **two new empty nodes** with those names and draws them
— no error, no warning. An undeclared key is a declaration.

Network and trust are different boundaries, and drawing them differently is the point: the VPC
says what can *route*, the dashed red frame says where a request stops being believed.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

internet: "Internet\nuntrusted" { class: client; shape: cloud }

vpc: "VPC 10.0.0.0/16" { class: panel

  public: "Public subnet · 10.0.1.0/24" { class: panel
    style: { stroke: "#dc2626"; stroke-dash: 4 }
    lb: "Load balancer\nthe ONLY public IP" { class: edge }
  }

  # TODO: everything that holds state belongs here — no route to the internet, no
  # public address, reachable only from the subnet above.
  private: "Private subnet · 10.0.2.0/24 · no egress" { class: panel
    app: "App servers" { class: svc }
    db: "Primary" { class: data; shape: cylinder }
    app -> db
  }

  public.lb -> private.app: "mTLS\nsecurity group allows :8443 only"
}

internet -> vpc.public.lb: "TLS · WAF · rate limit" { class: step }
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

internet: "Internet\nuntrusted" { class: client; shape: cloud }

vpc: "VPC 10.0.0.0/16" { class: panel

  public: "Public subnet · 10.0.1.0/24" { class: panel
    style: { stroke: "#dc2626"; stroke-dash: 4 }
    lb: "Load balancer\nthe ONLY public IP" { class: edge }
  }

  # TODO: everything that holds state belongs here — no route to the internet, no
  # public address, reachable only from the subnet above.
  private: "Private subnet · 10.0.2.0/24 · no egress" { class: panel
    app: "App servers" { class: svc }
    db: "Primary" { class: data; shape: cylinder }
    app -> db
  }

  public.lb -> private.app: "mTLS\nsecurity group allows :8443 only"
}

internet -> vpc.public.lb: "TLS · WAF · rate limit" { class: step }
```

Every arrow crossing the trust boundary should be able to name what authenticates it. If one
cannot, that is the finding.

## Next

- [Patterns](/synapse/synapse-features/d2-component-library/sd-patterns) — the primitives composed into the nine architectures worth knowing by heart.
- [Animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram) — four ways to show a sequence, and the rules that keep one watchable.
