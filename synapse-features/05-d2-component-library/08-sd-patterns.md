---
title: "System design — patterns"
summary: "Nine composed architectures — three-tier, cache-aside, write-behind, CQRS, event-driven, replicas and shards, multi-region, rate limiting, and one end-to-end sequence."
---

# System design — patterns

The [primitives](/synapse/synapse-features/d2-component-library/sd-primitives) are boxes. These are
the nine arrangements of them worth being able to draw without thinking — the ones that come up in
almost every design conversation, with the trade-off written into the figure rather than left in
your head.

Each one is a file under `synapse-features/_d2-blocks/system-design/patterns/`. Copy it, rename the
boxes, and the argument comes with it.

## Three tiers

The diagram every answer starts from. Draw it in the first two minutes and earn the rest of the
whiteboard by breaking one tier at a time.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

browser: "Browser" { class: client; shape: person }

edge: "Edge" { class: panel
  cdn: "CDN\nstatic assets, cached HTML" { class: edge }
  lb: "Load balancer\nTLS, health checks" { class: edge }
}

# TODO: stateless is the whole point — no sessions on disk, no local files. If a box
# cannot be killed mid-request without a user noticing, this tier is a lie.
app: "App tier · stateless ×N" { class: panel
  web: "Web servers\nrender + API" { class: svc }
}

store: "Data tier" { class: panel
  db: "Primary\nsingle writer" { class: data; shape: cylinder }
  cache: "Cache\nsessions, hot reads" { class: data }
}

browser -> edge.cdn: "1. GET /"
edge.cdn -> edge.lb: "2. miss → origin"
edge.lb -> app.web: "3. round-robin"
app.web -> store.cache: "4. read-through"
app.web -> store.db: "5. on miss"
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

browser: "Browser" { class: client; shape: person }

edge: "Edge" { class: panel
  cdn: "CDN\nstatic assets, cached HTML" { class: edge }
  lb: "Load balancer\nTLS, health checks" { class: edge }
}

# TODO: stateless is the whole point — no sessions on disk, no local files. If a box
# cannot be killed mid-request without a user noticing, this tier is a lie.
app: "App tier · stateless ×N" { class: panel
  web: "Web servers\nrender + API" { class: svc }
}

store: "Data tier" { class: panel
  db: "Primary\nsingle writer" { class: data; shape: cylinder }
  cache: "Cache\nsessions, hot reads" { class: data }
}

browser -> edge.cdn: "1. GET /"
edge.cdn -> edge.lb: "2. miss → origin"
edge.lb -> app.web: "3. round-robin"
app.web -> store.cache: "4. read-through"
app.web -> store.db: "5. on miss"
```

What makes it a good *opening* answer is the stateless middle: the app tier holds nothing, so it
scales by adding boxes, and every hard problem is pushed down into the tier below — which is
exactly where the interesting conversation is.

## Cache-aside

The default caching strategy, and the one to be able to draw from memory. The **application** owns
the cache: it looks, it misses, it loads, it fills. The cache knows nothing about the database.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

app: "Application\nowns the cache logic" { class: svc }
cache: "Cache · TTL 5m\nkey: user:{id}" { class: [data; hot] }
db: "Database" { class: [data; cold]; shape: cylinder }

app -> cache: "1. GET user:42"
cache -> app: "2a. HIT → return" { class: step }

# TODO: the miss path. Three edges, always in this order — read, then fill, then return.
cache -> app: "2b. MISS" { class: hint }
app -> db: "3. SELECT * FROM users WHERE id=42"
db -> app: "4. row"
app -> cache: "5. SET user:42, EX 300" { class: hint }

note: |md
  **Ask before you leave this diagram**

  - stampede — one hot key expiring, N misses at once
  - invalidation — who deletes `user:42` when the row changes?
  - what a cache outage costs: every read becomes a database read
| { class: panel; near: bottom-center }
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  cold:    { style: { fill: "#eff6ff"; stroke: "#93c5fd"; font-color: "#64748b" } }   # rare — cache miss, cold path
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

app: "Application\nowns the cache logic" { class: svc }
cache: "Cache · TTL 5m\nkey: user:{id}" { class: [data; hot] }
db: "Database" { class: [data; cold]; shape: cylinder }

app -> cache: "1. GET user:42"
cache -> app: "2a. HIT → return" { class: step }

# TODO: the miss path. Three edges, always in this order — read, then fill, then return.
cache -> app: "2b. MISS" { class: hint }
app -> db: "3. SELECT * FROM users WHERE id=42"
db -> app: "4. row"
app -> cache: "5. SET user:42, EX 300" { class: hint }

note: |md
  **Ask before you leave this diagram**

  - stampede — one hot key expiring, N misses at once
  - invalidation — who deletes `user:42` when the row changes?
  - what a cache outage costs: every read becomes a database read
| { class: panel; near: bottom-center }
```

Both paths are drawn, because the miss path is where every follow-up lives: the TTL, the stampede
when 10,000 requests miss one hot key at once, and who deletes the entry on a write.

There is a [step-by-step version of this one](/synapse/synapse-features/d2-component-library/animating-a-diagram) that
plays the read path one frame at a time.

## Write-behind

The write returns before the durable store has it. That is the trade in one sentence, and the
figure exists to make the consequences visible.

```bash
classes: {
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

client: "Client" { class: client }
api: "Write API" { class: svc }
queue: "Durable queue\nreplicated, ordered per key" { class: async; shape: queue }
worker: "Consumer\nbatches of 500" { class: [async; svc] }
db: "Store of record" { class: data; shape: cylinder }
dlq: "Dead-letter queue" { class: async; shape: queue }

client -> api: "1. POST /events"
api -> queue: "2. enqueue"
# TODO: THE line. Move it and you have changed the durability guarantee, not the layout.
api -> client: "3. 202 Accepted\n← durable in the QUEUE, not the DB" { class: step }
queue -> worker: "4. poll"
worker -> db: "5. batch insert · lag ~2s"
worker -> dlq: "6. after 3 failed attempts" { class: hint }
```

```d2
classes: {
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

client: "Client" { class: client }
api: "Write API" { class: svc }
queue: "Durable queue\nreplicated, ordered per key" { class: async; shape: queue }
worker: "Consumer\nbatches of 500" { class: [async; svc] }
db: "Store of record" { class: data; shape: cylinder }
dlq: "Dead-letter queue" { class: async; shape: queue }

client -> api: "1. POST /events"
api -> queue: "2. enqueue"
# TODO: THE line. Move it and you have changed the durability guarantee, not the layout.
api -> client: "3. 202 Accepted\n← durable in the QUEUE, not the DB" { class: step }
queue -> worker: "4. poll"
worker -> db: "5. batch insert · lag ~2s"
worker -> dlq: "6. after 3 failed attempts" { class: hint }
```

The `202 Accepted` edge is load-bearing. Move it one box to the right and you have changed the
durability guarantee, not the layout. What you buy is a p99 that no longer depends on the slowest
store in the chain; what you pay is a window where a write is acknowledged and not yet durable.

## CQRS and event sourcing

Two patterns named in one breath, and separable. **CQRS**: the write model and the read model are
different models. **Event sourcing**: the write model stores the events, not the current state.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

cmd: "Command\nPlaceOrder" { class: client }
handler: "Command handler\nvalidates invariants" { class: svc }

# TODO: append-only. No UPDATE, no DELETE — that constraint is the pattern.
log: "Event store\nOrderPlaced, OrderPaid, …\nappend-only" { class: async; shape: stored_data }

projector: "Projector\none per read model" { class: [async; svc] }

reads: "Read models" { class: panel
  orders: "Order summary\nfor the order page" { class: data; shape: cylinder }
  search: "Search index\nfor the list page" { class: data }
  metrics: "Daily rollup\nfor the dashboard" { class: data; shape: cylinder }
}

query: "Query\nGET /orders/42" { class: client }

cmd -> handler: "1."
handler -> log: "2. append event"
log -> projector: "3. subscribe"
projector -> reads.orders: "4. project"
projector -> reads.search
projector -> reads.metrics
reads.orders -> query: "5. read · eventually consistent" { class: hint }
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

cmd: "Command\nPlaceOrder" { class: client }
handler: "Command handler\nvalidates invariants" { class: svc }

# TODO: append-only. No UPDATE, no DELETE — that constraint is the pattern.
log: "Event store\nOrderPlaced, OrderPaid, …\nappend-only" { class: async; shape: stored_data }

projector: "Projector\none per read model" { class: [async; svc] }

reads: "Read models" { class: panel
  orders: "Order summary\nfor the order page" { class: data; shape: cylinder }
  search: "Search index\nfor the list page" { class: data }
  metrics: "Daily rollup\nfor the dashboard" { class: data; shape: cylinder }
}

query: "Query\nGET /orders/42" { class: client }

cmd -> handler: "1."
handler -> log: "2. append event"
log -> projector: "3. subscribe"
projector -> reads.orders: "4. project"
projector -> reads.search
projector -> reads.metrics
reads.orders -> query: "5. read · eventually consistent" { class: hint }
```

You can do CQRS without event sourcing — a materialised view over an ordinary table. You should
not do event sourcing without CQRS: replaying a log to answer a `GET` is not a read path.

The append-only constraint is the pattern. What it buys is a complete audit trail and the ability
to build a *new* read model later by replaying history; what it costs is schema evolution on
events you can never rewrite.

## Event-driven services

One publisher, three subscribers, and nobody knows about anybody.

```bash
classes: {
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

order: "Order service\nthe producer" { class: svc }
topic: "topic: OrderPlaced\npartitioned by order_id" { class: async }

email: "Email service" { class: svc }
analytics: "Analytics sink" { class: svc }
fraud: "Fraud scoring" { class: svc }
dlq: "DLQ" { class: async; shape: queue }

order -> topic: "publish a FACT,\nnot a command" { class: step }
topic -> email: "consumer group A"
topic -> analytics: "group B"
topic -> fraud: "group C"
fraud -> dlq: "give up after N" { class: hint }

# TODO: every consumer here must survive the same message arriving twice. Write down
# the idempotency key you would use — order_id is usually it.
```

```d2
classes: {
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

direction: right

order: "Order service\nthe producer" { class: svc }
topic: "topic: OrderPlaced\npartitioned by order_id" { class: async }

email: "Email service" { class: svc }
analytics: "Analytics sink" { class: svc }
fraud: "Fraud scoring" { class: svc }
dlq: "DLQ" { class: async; shape: queue }

order -> topic: "publish a FACT,\nnot a command" { class: step }
topic -> email: "consumer group A"
topic -> analytics: "group B"
topic -> fraud: "group C"
fraud -> dlq: "give up after N" { class: hint }

# TODO: every consumer here must survive the same message arriving twice. Write down
# the idempotency key you would use — order_id is usually it.
```

The producer does not import a client for Email, Analytics or Fraud. It publishes a fact and stops
caring, which is why a fourth consumer can be added without touching it. The price is paid in
operations rather than in code: no single place shows the whole flow, ordering is per-partition at
best, and every consumer must be idempotent because at-least-once delivery *will* deliver twice.

Note the topic name — `OrderPlaced`, a past-tense fact, never `SendEmail`. A command dressed as an
event puts the producer back in charge of the consumer, and you have a distributed function call
with worse failure modes.

## Replicas and shards

The two ways to scale a database, side by side, because they solve different problems and get
reached for interchangeably under pressure.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

replicas: "Scale READS · replication" { class: panel
  w: "Writes" { class: svc }
  p: "Primary" { class: data; shape: cylinder }
  r1: "Replica 1\nlag ~80ms" { class: data; shape: cylinder }
  r2: "Replica 2\nlag ~80ms" { class: data; shape: cylinder }
  reads: "Reads" { class: svc }

  w -> p
  p -> r1: "async" { class: hint }
  p -> r2: "async" { class: hint }
  r1 -> reads: "stale by a beat" { class: hint }
  r2 -> reads: { class: hint }
}

shards: "Scale WRITES · partitioning" { class: panel
  router: "Router\nhash(user_id) % 16" { class: edge }
  s0: "Shard 0\nusers 0–4M" { class: data; shape: cylinder }
  s1: "Shard 1\nusers 4–8M" { class: data; shape: cylinder }
  s2: "Shard 2\nusers 8–12M" { class: data; shape: cylinder }

  router -> s0
  router -> s1
  router -> s2
}

# TODO: pick the shard key for the ACCESS PATTERN, not for the entity. Sharding orders
# by order_id spreads one customer's orders across every shard.
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

replicas: "Scale READS · replication" { class: panel
  w: "Writes" { class: svc }
  p: "Primary" { class: data; shape: cylinder }
  r1: "Replica 1\nlag ~80ms" { class: data; shape: cylinder }
  r2: "Replica 2\nlag ~80ms" { class: data; shape: cylinder }
  reads: "Reads" { class: svc }

  w -> p
  p -> r1: "async" { class: hint }
  p -> r2: "async" { class: hint }
  r1 -> reads: "stale by a beat" { class: hint }
  r2 -> reads: { class: hint }
}

shards: "Scale WRITES · partitioning" { class: panel
  router: "Router\nhash(user_id) % 16" { class: edge }
  s0: "Shard 0\nusers 0–4M" { class: data; shape: cylinder }
  s1: "Shard 1\nusers 4–8M" { class: data; shape: cylinder }
  s2: "Shard 2\nusers 8–12M" { class: data; shape: cylinder }

  router -> s0
  router -> s1
  router -> s2
}

# TODO: pick the shard key for the ACCESS PATTERN, not for the entity. Sharding orders
# by order_id spreads one customer's orders across every shard.
```

**Replicas scale reads.** Every replica holds all the data; writes do not get faster.
**Shards scale writes** and data size. Each shard holds a slice, and cross-shard queries and
transactions get much harder.

A read-heavy feed: replicas. A write-heavy ledger: shards. The shard key is the only decision on
this page that is expensive to change later — pick it for the access pattern, not for the entity.
Sharding orders by `order_id` spreads one customer's orders across every shard.

## Multi-region, active-active

Both regions serve writes. That single sentence is the entire difficulty: two writers, one
dataset, and the speed of light in between.

```bash
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

dns: "GeoDNS / anycast\nnearest healthy region" { class: edge }

us: "us-east-1 · ACTIVE" { class: panel
  app_us: "App tier" { class: svc }
  db_us: "Regional store\naccepts writes" { class: data; shape: cylinder }
  app_us -> db_us
}

eu: "eu-west-1 · ACTIVE" { class: panel
  app_eu: "App tier" { class: svc }
  db_eu: "Regional store\naccepts writes" { class: data; shape: cylinder }
  app_eu -> db_eu
}

dns -> us.app_us
dns -> eu.app_eu

# TODO: name the rule. Last-write-wins loses data silently; CRDTs and per-region key
# ownership do not. Whichever you pick, it belongs in the label.
us.db_us <-> eu.db_eu: "bi-directional replication · ~90ms\nconflicts: last-write-wins on updated_at" { class: step }
```

```d2
classes: {
  panel: { style: { fill: "#fbfcfe"; stroke: "#cbd5e1"; font-size: 15; font-color: "#475569" } }
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

dns: "GeoDNS / anycast\nnearest healthy region" { class: edge }

us: "us-east-1 · ACTIVE" { class: panel
  app_us: "App tier" { class: svc }
  db_us: "Regional store\naccepts writes" { class: data; shape: cylinder }
  app_us -> db_us
}

eu: "eu-west-1 · ACTIVE" { class: panel
  app_eu: "App tier" { class: svc }
  db_eu: "Regional store\naccepts writes" { class: data; shape: cylinder }
  app_eu -> db_eu
}

dns -> us.app_us
dns -> eu.app_eu

# TODO: name the rule. Last-write-wins loses data silently; CRDTs and per-region key
# ownership do not. Whichever you pick, it belongs in the label.
us.db_us <-> eu.db_eu: "bi-directional replication · ~90ms\nconflicts: last-write-wins on updated_at" { class: step }
```

Conflicts are now your problem, so the figure names the resolution rule instead of leaving it
implied. Two users editing the same row in two regions is not an edge case.

Active-**passive** is the honest default for most systems. Reach for this when the availability
target genuinely requires it, and say so out loud.

## Rate-limited public API

Where a request gets rejected, and by what. The order of the checks *is* the design: the cheapest
rejection comes first, so an abusive caller never reaches anything expensive.

```bash
classes: {
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

caller: "API caller\nkey: sk_live_…" { class: client }
waf: "WAF\nIP floods, bad signatures" { class: edge }
gw: "API gateway" { class: edge }
limiter: "Rate limiter\ntoken bucket · 1000 req/min/key" { class: edge }
counters: "Shared counters\nper key, per window" { class: [data; hot] }
api: "Your API" { class: svc }

caller -> waf: "1. request"
waf -> gw: "2. survived"
gw -> limiter: "3. authenticated → key"
limiter -> counters: "4. INCR + TTL" { class: hint }
limiter -> api: "5. under quota"
# TODO: return the budget in the response. A caller that can see its remaining quota
# backs off on its own; one that cannot, retries into the wall.
limiter -> caller: "429 + Retry-After\nX-RateLimit-Remaining: 0" { class: step }
```

```d2
classes: {
  hot:     { style: { fill: "#ffedd5"; stroke: "#ea580c" } }   # frequent — cache hit, high traffic
  step: { style: { stroke: "#0f172a"; stroke-width: 2; font-size: 15; bold: true } }
  hint: { style: { stroke: "#94a3b8"; stroke-dash: 3; font-size: 13; font-color: "#64748b" } }
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
}

direction: right

caller: "API caller\nkey: sk_live_…" { class: client }
waf: "WAF\nIP floods, bad signatures" { class: edge }
gw: "API gateway" { class: edge }
limiter: "Rate limiter\ntoken bucket · 1000 req/min/key" { class: edge }
counters: "Shared counters\nper key, per window" { class: [data; hot] }
api: "Your API" { class: svc }

caller -> waf: "1. request"
waf -> gw: "2. survived"
gw -> limiter: "3. authenticated → key"
limiter -> counters: "4. INCR + TTL" { class: hint }
limiter -> api: "5. under quota"
# TODO: return the budget in the response. A caller that can see its remaining quota
# backs off on its own; one that cannot, retries into the wall.
limiter -> caller: "429 + Retry-After\nX-RateLimit-Remaining: 0" { class: step }
```

The shared counter matters. A token bucket held in each gateway's memory lets a caller get N× their
quota by spreading requests across N gateways — a bug that only appears once you scale the tier
that was supposed to be enforcing the limit.

Returning the remaining budget is the other half: a caller that can see its quota backs off on its
own; one that cannot, retries into the wall.

## One request, end to end

`shape: sequence_diagram` reads the connections in order, top to bottom. Reach for it when the
question is "walk me through a request" — a box diagram shows what exists, this shows what happens
and in what order.

```bash
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

shape: sequence_diagram

client: "Client" { class: client }
gw: "API gateway" { class: edge }
svc: "Order service" { class: svc }
cache: "Cache" { class: data }
db: "Primary" { class: data }
bus: "Event bus" { class: async }

client -> gw: "POST /orders"
gw -> gw: "verify JWT"
gw -> svc: "createOrder()"

svc -> cache: "GET inventory:sku-9"
cache -> svc: "MISS"
svc -> db: "SELECT … FOR UPDATE"
db -> svc: "12 in stock"
svc -> db: "INSERT order · COMMIT"

svc -> bus: "publish OrderPlaced"
svc -> client: "201 Created"

# TODO: everything below this line is off the critical path — the user already has
# their 201. Keep it below, and say so.
bus -> svc: "async: email, analytics, fraud"
```

```d2
classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  edge:   { style: { fill: "#dbeafe"; stroke: "#2563eb"; font-color: "#1e3a8a" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  async:  { style: { fill: "#f3e8ff"; stroke: "#9333ea"; font-color: "#581c87" } }
}

shape: sequence_diagram

client: "Client" { class: client }
gw: "API gateway" { class: edge }
svc: "Order service" { class: svc }
cache: "Cache" { class: data }
db: "Primary" { class: data }
bus: "Event bus" { class: async }

client -> gw: "POST /orders"
gw -> gw: "verify JWT"
gw -> svc: "createOrder()"

svc -> cache: "GET inventory:sku-9"
cache -> svc: "MISS"
svc -> db: "SELECT … FOR UPDATE"
db -> svc: "12 in stock"
svc -> db: "INSERT order · COMMIT"

svc -> bus: "publish OrderPlaced"
svc -> client: "201 Created"

# TODO: everything below this line is off the critical path — the user already has
# their 201. Keep it below, and say so.
bus -> svc: "async: email, analytics, fraud"
```

The two things a box diagram cannot show and this can: which calls are on the critical path
(everything above the `201`) and which are not (everything below it).

## Next

- [Animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram) — four ways to show a sequence, and the rules that keep one watchable.
- [Animated system design](/synapse/synapse-features/d2-component-library/animated-system-design) — failover, growth and a deploy, one frame at a time.
