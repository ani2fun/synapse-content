---
title: "Animated system design"
summary: "Three sequences a static architecture diagram cannot show — a leader failing over, a system outgrowing itself, and a deploy that rolls back."
---

# Animated system design

An architecture diagram shows a system at rest. These three show one changing, and each is a thing
the still version genuinely cannot say:

- **failover** happens over *time*, and the interesting part is the gap between the failure and
  anyone noticing;
- **growth** is a sequence of decisions, and the point is which bottleneck forced which one;
- **a deploy** is only interesting if you also draw the rollback.

Each one is shown as a **player**: press ▶, or step it with the arrows. The `bash` block above each
is the authoring form — a base diagram and one short delta per frame, exactly as the files sit on
disk. The transports, the four rules and the stability gate are in
[Animating a diagram](/synapse/synapse-features/d2-component-library/animating-a-diagram).

## Leader failover

Six frames, one node loss, start to finish. The role each node is playing is carried by **colour**
rather than by its label — `hot` is the leader, `active` a healthy follower, `pruned` unreachable —
which is what lets a promotion cost one line and move nothing on screen.

Naming the boxes "Primary" and "Replica" would have made that impossible: the label would be a lie
for half the sequence.

```bash
# leader-failover.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · LEADER FAILOVER ──────────────────────────────────────────
# animation-mode: highlight
# lesson: animated-system-design
# caption: A leader failing over, start to finish
# A failure over TIME, which is the one thing a static architecture diagram cannot show
# at all. The boxes never move; what changes is which node is the leader, and that is
# carried entirely by colour:
#
#   hot     the leader — the node accepting writes right now
#   active  a healthy follower
#   pruned  unreachable
#   current the node this frame is about
#
# Because the ROLE is a colour and not a label, promotion costs one line in a frame file
# and moves nothing on screen. Naming the nodes "Primary" and "Replica" would have made
# that impossible — the label would be a lie for half the sequence.
#
# Knobs: the node count (three is the smallest quorum that tolerates one loss) and the
# detection window, which is the number every follow-up question is really about.

...@../../../lib/theme

direction: right

title: "leader failover · one node loss, start to finish" { near: top-center; shape: text; width: 980; style: { font-size: 20; bold: true } }

client: "Writers" { class: [client; dim] }
router: "Router / proxy\nsends writes to the leader" { class: [edge; dim] }

cluster: "Replica set" { class: panel
  a: "Node A" { class: [data; dim]; shape: cylinder }
  b: "Node B" { class: [data; dim]; shape: cylinder }
  c: "Node C" { class: [data; dim]; shape: cylinder }
}

client -> router: "write" { class: dim; style.stroke-width: 2 }
router -> cluster.a: "" { class: dim; style.stroke-width: 2 }
router -> cluster.b: "" { class: dim; style.stroke-width: 2 }
cluster.a -> cluster.b: "replicate" { class: dim; style.stroke-width: 2 }
cluster.a -> cluster.c: "replicate" { class: dim; style.stroke-width: 2 }
cluster.b <-> cluster.c: "heartbeat · 2s" { class: dim; style.stroke-width: 2 }

# ── 01-healthy.d2 ─────────────────────────────────
# Frame 1 — steady state. A is the leader; every write goes through it and fans out.
...@./base
title: "1 · steady state — A is the leader"
client.class: [client; active]
router.class: [edge; active]
cluster.a.class: [data; hot]
cluster.b.class: [data; active]
cluster.c.class: [data; active]
(client -> router)[0].class: step
(router -> cluster.a)[0].class: step
(cluster.a -> cluster.b)[0].class: hint
(cluster.a -> cluster.c)[0].class: hint

# ── 02-loss.d2 ─────────────────────────────────
# Frame 2 — A is gone. Nothing knows it yet: the writer is still sending, the router is
# still routing, and the write is being lost.
...@./base
title: "2 · A dies — and for now, nobody knows"
client.class: [client; active]
router.class: [edge; active]
cluster.a.class: [data; pruned]
cluster.b.class: [data; active]
cluster.c.class: [data; active]
(client -> router)[0].class: step
(router -> cluster.a)[0].class: pruned

# ── 03-detect.d2 ─────────────────────────────────
# Frame 3 — detection. The gap between frame 2 and frame 3 is your availability budget,
# and it is bounded by the heartbeat interval, not by how fast the node failed.
...@./base
title: "3 · missed heartbeats — B and C notice"
cluster.a.class: [data; pruned]
cluster.b.class: [data; current]
cluster.c.class: [data; current]
(cluster.b <-> cluster.c)[0].class: step
(cluster.a -> cluster.b)[0].class: pruned
(cluster.a -> cluster.c)[0].class: pruned

# ── 04-elect.d2 ─────────────────────────────────
# Frame 4 — the election. Two survivors out of three is a majority, which is the whole
# reason the cluster has an odd number of nodes.
...@./base
title: "4 · election — B and C are a majority of 3"
cluster.a.class: [data; pruned]
cluster.b.class: [data; current]
cluster.c.class: [data; active]
(cluster.b <-> cluster.c)[0].class: step

# ── 05-promote.d2 ─────────────────────────────────
# Frame 5 — B is the leader. Note what did NOT happen: no box moved, no arrow was added.
# The role is a colour, so promotion is a recolour.
...@./base
title: "5 · B is promoted — writes have somewhere to go again"
router.class: [edge; current]
cluster.a.class: [data; pruned]
cluster.b.class: [data; hot]
cluster.c.class: [data; active]
(router -> cluster.b)[0].class: step
(cluster.b <-> cluster.c)[0].class: hint

# ── 06-recovered.d2 ─────────────────────────────────
# Frame 6 — recovered, and smaller. Two nodes tolerate ZERO further failures, so the
# incident is not over until A (or a replacement) rejoins.
...@./base
title: "6 · serving again — on two nodes, tolerating zero more losses"
client.class: [client; active]
router.class: [edge; active]
cluster.a.class: [data; pruned]
cluster.b.class: [data; hot]
cluster.c.class: [data; active]
(client -> router)[0].class: step
(router -> cluster.b)[0].class: step
(cluster.b <-> cluster.c)[0].class: hint
```

// Interactive Diagram (6 frames): A leader failing over, start to finish

![A leader failing over, start to finish — frame 1 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-1.svg)

![A leader failing over, start to finish — frame 2 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-2.svg)

![A leader failing over, start to finish — frame 3 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-3.svg)

![A leader failing over, start to finish — frame 4 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-4.svg)

![A leader failing over, start to finish — frame 5 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-5.svg)

![A leader failing over, start to finish — frame 6 of 6](/media/synapse-features/animated-system-design/leader-failover/frame-6.svg)

The frame worth pausing on is the second one: A is already dead, and the writer, the router and the
other two nodes all still believe otherwise. The gap between frame 2 and frame 3 is your
availability budget, and it is bounded by the heartbeat interval — not by how fast the node failed.

The last frame is the one people forget. Two nodes tolerate zero further failures, so the incident
is not over when writes resume; it is over when A or a replacement rejoins.

## Outgrowing a system

The other animation mode. Here the layout **does** jump between frames, deliberately — the reader
is meant to watch the architecture get bigger.

Each frame chains its import from the previous one, so every file holds only what its step added.
Five files, one diagram, no repetition.

```bash
# scaling-story.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · SCALING, ONE BOTTLENECK AT A TIME ────────────────────────
# animation-mode: build
# lesson: animated-system-design
# caption: One system outgrowing itself, one bottleneck at a time
# The OTHER animation mode. Everywhere else in this library a frame recolours a fixed
# picture; here each frame ADDS to the last, and the diagram grows.
#
#   highlight mode   layout is frozen, colour moves         → a sequence of events
#   build mode       layout grows, boxes appear             → a system evolving
#
# The layout DOES jump between frames here, and that is the point — the reader is meant
# to see the architecture getting bigger. Use build mode only when growth is the subject.
#
# Chained imports are what keep it DRY: 02 spreads in 01, 03 spreads in 02, and so on, so
# every frame file holds only what that step added. Each one still compiles alone.
#
# One consequence to expect: flattened, the last frame carries EVERY step's `title:` line,
# in order. d2 takes the last one, so the figure is right — and the stack of them is a
# readable history of how the diagram got there.
#
# The other consequence: a chain can add, never remove. When a step RETIRES something —
# users stop talking to the app directly once a load balancer arrives — blank its label
# and set `style.opacity: 0`. It keeps its slot in the layout and disappears from view,
# which is exactly what you want; deleting it would move everything else.
#
# Knobs: this file is the naive starting point. Keep it genuinely naive — the animation
# is worthless if frame 1 is already a good design.

...@../../../lib/theme

direction: right

title: "scaling · one bottleneck at a time" { near: top-center; shape: text; width: 760; style: { font-size: 20; bold: true } }

users: "Users" { class: client; shape: person }
app: "One server\napp + database, same box" { class: svc }

users -> app: "everything"

# ── 01-split.d2 ─────────────────────────────────
# Frame 1 — split the tiers. The database stops competing with the application for the
# same CPU, and for the first time the two can be sized independently.
...@./base
title: "1 · split the tiers"
app: "App server" { class: svc }
db: "Database" { class: data; shape: cylinder }
app -> db: "queries"

# ── 02-scale-out.d2 ─────────────────────────────────
# Frame 2 — more app servers behind a load balancer. This works only because the app
# tier is stateless; if sessions lived on disk, this frame would be a bug.
...@./01-split
title: "2 · scale the app tier out — it is stateless, so this is easy"
lb: "Load balancer" { class: edge }
app: "App servers ×N" { class: svc }
users -> lb: "HTTPS"
lb -> app

# Build mode can ADD but never delete, and users no longer reach the app directly. Retire
# the edge instead: blank its label and set opacity to 0 THROUGH ITS INDEX. Writing
# `users -> app: ""` would declare a SECOND connection rather than change the first, and
# leave the original drawn.
(users -> app)[0].label: ""
(users -> app)[0].style.opacity: 0

# ── 03-cache.d2 ─────────────────────────────────
# Frame 3 — the database is now the bottleneck, and most reads are the same few rows.
# A cache is the cheapest thing that helps, and the first one that adds a consistency
# problem you have to think about.
...@./02-scale-out
title: "3 · cache the hot reads — the first consistency trade"
cache: "Cache\nhot keys, TTL" { class: [data; hot] }
app -> cache: "read first"

# ── 04-replicas.d2 ─────────────────────────────────
# Frame 4 — reads that miss the cache still land on one machine. Replicas spread them
# out, at the cost of serving data that is a little behind.
...@./03-cache
title: "4 · read replicas — reads scale, writes still do not"
replica: "Read replicas ×2\nlag ~80ms" { class: data; shape: cylinder }
db -> replica: "async replication" { class: hint }
app -> replica: "reads"

# ── 05-async.d2 ─────────────────────────────────
# Frame 5 — the write path is the last thing standing. Take the work that does not have
# to be synchronous off it, and only what genuinely must be durable-before-200 remains.
#
# TODO: the honest next frame after this one is sharding, and it is the expensive one.
# Do not draw it until the numbers say you need it.
...@./04-replicas
title: "5 · take work off the write path"
queue: "Queue" { class: async; shape: queue }
worker: "Workers" { class: [async; svc] }
app -> queue: "enqueue, return 202"
queue -> worker
worker -> db: "write later"
```

// Interactive Diagram (5 frames): One system outgrowing itself, one bottleneck at a time

![One system outgrowing itself, one bottleneck at a time — frame 1 of 5](/media/synapse-features/animated-system-design/scaling-story/frame-1.svg)

![One system outgrowing itself, one bottleneck at a time — frame 2 of 5](/media/synapse-features/animated-system-design/scaling-story/frame-2.svg)

![One system outgrowing itself, one bottleneck at a time — frame 3 of 5](/media/synapse-features/animated-system-design/scaling-story/frame-3.svg)

![One system outgrowing itself, one bottleneck at a time — frame 4 of 5](/media/synapse-features/animated-system-design/scaling-story/frame-4.svg)

![One system outgrowing itself, one bottleneck at a time — frame 5 of 5](/media/synapse-features/animated-system-design/scaling-story/frame-5.svg)

Read it as a sequence of forced moves. Splitting the tiers lets the two be sized separately.
Scaling the app tier out works *only* because it is stateless — if sessions lived on disk, frame 2
would be a bug rather than a step. The cache is the first move that buys speed by giving up
freshness. Replicas scale the reads that miss it. And the last frame takes work off the write path,
which is the only thing still standing.

The honest next frame is sharding, and it is deliberately not drawn: it is the expensive one, and
a diagram that shows it as just another step is teaching the wrong lesson.

Notice what frame 2 does to the original `Users → App server` arrow. Build mode can add but never
delete, so the edge is retired in place — label blanked, opacity zero, slot kept. Deleting it would
have moved everything else.

## A deploy, and the rollback it exists for

Five frames. The version an instance is running is a colour, so promoting one and rolling it back
are the same kind of edit.

```bash
# rolling-deploy.anim/base.d2 — declared once, spread into every frame
# ── ANIMATION BASE · ROLLING DEPLOY, AND THE ROLLBACK ─────────────────────────
# animation-mode: highlight
# lesson: animated-system-design
# caption: A canary deploy and the rollback it exists for
# A deploy is a sequence, so a static picture of it is always the wrong picture: it shows
# one moment and the reader has to imagine the rest.
#
# The version an instance is running is carried by COLOUR, not by its label — `active` is
# the old build, `current` is the new one, `pruned` is one that is failing. That is what
# lets a frame promote or roll back an instance without touching the layout.
#
# The sequence deliberately ends in a rollback. A canary that only ever succeeds is not a
# canary, it is a slower deploy; the reason to route 1% first is to have somewhere cheap
# to fail.
#
# Knobs: the instance count, the traffic split in each title, and the metric that trips
# the rollback — that last one is the whole design.

...@../../../lib/theme

direction: right

title: "rolling deploy · canary, and the rollback it exists for" { near: top-center; shape: text; width: 1000; style: { font-size: 20; bold: true } }

lb: "Load balancer\nweighted routing" { class: [edge; dim] }

fleet: "Fleet" { class: panel
  i1: "instance 1" { class: [svc; dim] }
  i2: "instance 2" { class: [svc; dim] }
  i3: "instance 3" { class: [svc; dim] }
  i4: "instance 4" { class: [svc; dim] }
}

metrics: "Error rate\nSLO: < 0.5%" { class: [svc; dim] }

lb -> fleet.i1: "" { class: dim; style.stroke-width: 2 }
lb -> fleet.i2: "" { class: dim; style.stroke-width: 2 }
lb -> fleet.i3: "" { class: dim; style.stroke-width: 2 }
lb -> fleet.i4: "" { class: dim; style.stroke-width: 2 }
fleet -> metrics: "emit" { class: dim; style.stroke-width: 2 }

# ── 01-steady.d2 ─────────────────────────────────
# Frame 1 — all four on v1, all healthy, all taking traffic.
...@./base
title: "1 · v1 everywhere · 100% of traffic · errors 0.1%"
lb.class: [edge; active]
metrics.class: [svc; active]
fleet.i1.class: [svc; active]
fleet.i2.class: [svc; active]
fleet.i3.class: [svc; active]
fleet.i4.class: [svc; active]
(fleet -> metrics)[0].class: hint

# ── 02-canary.d2 ─────────────────────────────────
# Frame 2 — one instance takes v2 and 1% of traffic. One instance, because the cost of
# being wrong is what you are choosing here.
...@./base
title: "2 · instance 4 → v2 · 1% of traffic"
lb.class: [edge; active]
metrics.class: [svc; active]
fleet.i1.class: [svc; active]
fleet.i2.class: [svc; active]
fleet.i3.class: [svc; active]
fleet.i4.class: [svc; current]
(lb -> fleet.i4)[0].class: step
(fleet -> metrics)[0].class: hint

# ── 03-bake.d2 ─────────────────────────────────
# Frame 3 — the bake. Nothing is happening on purpose: you are buying enough traffic for
# a rare failure to show up before it is on every instance.
...@./base
title: "3 · bake for 10 minutes — watching, not deploying"
lb.class: [edge; active]
metrics.class: [svc; current]
fleet.i1.class: [svc; active]
fleet.i2.class: [svc; active]
fleet.i3.class: [svc; active]
fleet.i4.class: [svc; current]
(fleet -> metrics)[0].class: step

# ── 04-breach.d2 ─────────────────────────────────
# Frame 4 — v2 is failing. The whole point of frame 2 is that this costs 1% of requests
# rather than all of them.
...@./base
title: "4 · errors 4.2% on the canary — SLO breached"
lb.class: [edge; active]
metrics.class: [svc; pruned]
fleet.i1.class: [svc; active]
fleet.i2.class: [svc; active]
fleet.i3.class: [svc; active]
fleet.i4.class: [svc; pruned]
(fleet -> metrics)[0].class: step
(lb -> fleet.i4)[0].class: pruned

# ── 05-rollback.d2 ─────────────────────────────────
# Frame 5 — drained and rolled back. Recovery took one routing change, because nothing
# had been migrated, replaced or rewritten yet. That is the property you are paying for.
...@./base
title: "5 · rolled back · instance 4 drained, fleet is v1 again"
lb.class: [edge; active]
metrics.class: [svc; active]
fleet.i1.class: [svc; active]
fleet.i2.class: [svc; active]
fleet.i3.class: [svc; active]
fleet.i4.class: [svc; visited]
(lb -> fleet.i4)[0].class: hint
(fleet -> metrics)[0].class: hint
```

// Interactive Diagram (5 frames): A canary deploy and the rollback it exists for

![A canary deploy and the rollback it exists for — frame 1 of 5](/media/synapse-features/animated-system-design/rolling-deploy/frame-1.svg)

![A canary deploy and the rollback it exists for — frame 2 of 5](/media/synapse-features/animated-system-design/rolling-deploy/frame-2.svg)

![A canary deploy and the rollback it exists for — frame 3 of 5](/media/synapse-features/animated-system-design/rolling-deploy/frame-3.svg)

![A canary deploy and the rollback it exists for — frame 4 of 5](/media/synapse-features/animated-system-design/rolling-deploy/frame-4.svg)

![A canary deploy and the rollback it exists for — frame 5 of 5](/media/synapse-features/animated-system-design/rolling-deploy/frame-5.svg)

The sequence ends in a rollback on purpose. A canary that only ever succeeds is not a canary, it is
a slower deploy; the reason to route 1% of traffic first is to have somewhere cheap to fail. Frame
3 is the bake — nothing happens, and that is the step people cut.

Recovery in frame 5 is one routing change, because nothing had been migrated, replaced or rewritten
yet. That property is what you are buying, and it is why an irreversible migration should never
ride along with a canary deploy.

## Adapting one

Every animation is a directory under `synapse-features/_d2-blocks/`. To make your own:

1. Copy the nearest `.anim/` directory.
2. Rewrite `base.d2` with your boxes — **every** node and edge the sequence will show, all dimmed.
3. Set the three header lines: `# animation-mode:` (`highlight` if the layout should freeze,
   `build` if it should grow), `# lesson:` and `# caption:`. The last two are what
   `./render.sh media` uses to draw the frames and what `./render.sh player` writes into the alt
   text — and the alt text is the only thing that groups a run into one figure.
4. Rewrite the frames. Three or four lines each: a title, and the classes that change.
5. Run `./render.sh stable`, then `./render.sh media`.

## Next

- [Animated DSA](/synapse/synapse-features/d2-component-library/animated-dsa) — a sliding window, a binary search, a BFS frontier, and a DP table filling in.
- [Patterns](/synapse/synapse-features/d2-component-library/sd-patterns) — the static versions of these architectures.
