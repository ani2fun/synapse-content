---
title: "Trade-offs and the decision record"
summary: "The deliberate asymmetries: fail fast on the database but degrade on the identity provider, admin by commit but access by row, and one replica as a correctness requirement rather than a compromise."
essential: true
---

# Trade-offs and the decision record

> **You'll be able to:** decide per-dependency whether to fail fast or degrade, and defend the
> asymmetry; distinguish a constraint you chose from one you backed into; and read a scaling limit
> as a design statement rather than an oversight.

## Dependencies are not equal

The platform depends on Postgres, Keycloak, go-judge and a git checkout. A uniform policy for all
four would be wrong, because they do not support the same things:

| Dependency | If it is down | Policy |
|---|---|---|
| Postgres | the app **exits** | fail fast |
| Keycloak | reading and running still work; sign-in fails | degrade |
| go-judge | running and submitting fail; reading works | degrade |
| Content on disk | nothing works, but nothing is *wrong* | fail fast at boot |

The asymmetry between the first two is the interesting one, and it is not about which service is more
important. It is about **what the application can still honestly do**.

Without Postgres, the app cannot record a submission, cannot check the allowlist, and cannot read
back a verdict. It could still serve lessons — but it would be a process whose readiness probe lies,
whose writes fail in ways callers cannot distinguish from rejection, and whose recovery is
unobservable. Exiting is louder and more honest: the pod restarts, the probe fails, and the
dependency failure is visible as a dependency failure.

Without Keycloak, ~99% of the platform is unaffected. Reading needs no identity at all. Verification
uses **cached** signing keys and local cryptography, so already-signed-in readers keep working
through an outage. Only new sign-ins fail. Taking the whole platform down for that would convert a
partial outage into a total one.

<div style="border-left:4px solid #195045;background:rgba(25,80,69,0.08);padding:0.6rem 1rem;border-radius:0 0.5rem 0.5rem 0;margin:1.25rem 0">

💡 **The right question is not "is this dependency critical?" but "what can I still do correctly
without it?"** If the answer is a meaningful subset of the product, degrade and say so. If the answer
is "serve confusing half-answers", fail fast.

</div>

### What fail-fast actually looked like

This is not theoretical. Earlier today the node hosting Postgres went down. The application — running
on a *different* node — did exactly what it was designed to do:

```
Error: pool timed out while waiting for an open connection
```

It exited. Kubernetes restarted it. It failed again. **Thirty-two restarts over roughly ninety
minutes**, until the database node returned at 16:34 and the next restart succeeded two minutes
later.

That is the design working: no silent half-service, no lying readiness probe, and a failure whose
cause is one line in a log. It is also, unmistakably, ninety minutes of downtime — which is the
subject of the [case study](/synapse/synapse-app-from-scratch/running-it/the-homelab-case-study),
and the point at which "correct behaviour" and "good availability" turn out to be different goals.

## Two ways to grant power, deliberately different

| Capability | Changed by | Takes effect | Rationale |
|---|---|---|---|
| **Admin** | a commit to the infrastructure repository | after a rollout | rare, auditable, reviewable |
| **Submit access** | a row in the allowlist table | next request | routine, reversible, self-service-ish |

Admin membership is configuration. Changing it means a commit, a review, a deploy — slow on purpose,
because admin is the power that grants other power. Allowlist grants are data: an admin adds a row and it
is live immediately, with no restart.

The asymmetry produces a specific security property: **a compromised admin session can widen who may
submit, but cannot mint another admin.** Escalation requires repository access, which is a different
credential with a different audit trail. Putting both in the database would make one stolen session
sufficient for permanent, self-renewing access.

The cost is that emergency admin changes are slow. On a personal platform that is the correct
trade — and on a larger one it is exactly the trade you would still want, with a break-glass path
added deliberately rather than by leaving the door open.

## `replicas: 1` is a requirement, not a shortcut

The application runs as a single replica, and it is worth being precise about why: **the rate limiter
holds per-process state.** Two replicas mean two independent counters, so the effective limit doubles
and the policy silently stops meaning what it says.

That makes the single replica a *correctness* constraint, not a resource compromise. Scaling out is
not "add replicas" — it is "move the rate limiter's state somewhere shared, then add replicas".

Naming it is what turns it from a landmine into a decision. The startup reconciler leans on it too:
with one replica a crash *is* a restart, so abandoned submissions are swept within seconds. With two
replicas a crash of one is not a restart of anything, and the sweep has to become periodic.

Both are written down in the chapters that own them, which means the multi-replica change has a known
checklist rather than a set of surprises.

## Decisions I would revisit

An honest decision record includes the ones that have aged least well.

**The database has no replica.** It runs on node-local storage on a single machine, which makes that
machine a single point of failure for every write path. Today's ninety-minute outage is exactly this
risk being realised. It is the largest single availability gap in the system, and it is a deliberate
deferral rather than an oversight — but the deferral has now been priced.

**The contract snapshot pins one endpoint.** A test diffs the generated API description against a
committed copy, so drift should be a red test. In practice that file documents a single endpoint out
of roughly twenty, so the guard has never actually guarded anything. A gate that cannot fail is worse
than no gate, because it produces confidence without coverage. Either regenerate it in full or retire
it — leaving it as decoration is the one option that should be off the table.

**Two development usernames are seeded into the allowlist migration.** Harmless on the real
deployment — the schema predates these migrations, so the seeds never ran — but wrong in principle:
production migrations should not carry development data, because the one time the assumption breaks
is the time it matters.

**The identity provider is heavyweight for the load.** Keycloak for a handful of users is a lot of
machinery. It is the right call while the alternative is inventing authentication, and the wrong
shape if the user count stays this small forever.

## Reading a decision record

Two habits make a record like this useful rather than decorative.

**Record the reasoning, not just the choice.** "We use Postgres" ages into folklore. "We fail fast on
Postgres because the app cannot honestly serve writes without it, unlike Keycloak where 99% of the
product still works" tells a future reader whether the decision still applies when the circumstances
change.

**Record what you gave up.** Every entry above names a cost. A decision record listing only benefits
is marketing, and its main effect is that the next person cannot tell which constraints are load
bearing.

## Check yourself

```quiz
{"prompt": "Why does the application exit when Postgres is unavailable but keep serving when Keycloak is?", "options": ["Because Postgres failures are permanent and Keycloak failures are transient", "Because without Postgres it cannot honestly serve any write path, while without Keycloak ~99% of the product (reading, running) still works correctly", "Because Keycloak has a built-in retry mechanism", "Because Postgres is on a different node"], "answer": "Because without Postgres it cannot honestly serve any write path, while without Keycloak ~99% of the product (reading, running) still works correctly"}
```

```quiz
{"prompt": "What security property comes from admin being config-only while allowlist grants are database rows?", "options": ["Admins can be changed faster in an emergency", "A compromised admin session can widen submit access but cannot create another admin — escalation requires repository access, a separate credential with its own audit trail", "The allowlist can be edited without authentication", "It reduces database load"], "answer": "A compromised admin session can widen submit access but cannot create another admin — escalation requires repository access, a separate credential with its own audit trail"}
```

```quiz
{"prompt": "Why is `replicas: 1` described as a correctness requirement rather than a resource decision?", "options": ["Because the container is too large to run twice", "Because the rate limiter keeps per-process state, so N replicas would silently multiply the effective limit by N", "Because Postgres allows only one connection", "Because the content sidecar cannot be shared"], "answer": "Because the rate limiter keeps per-process state, so N replicas would silently multiply the effective limit by N"}
```

<details>
<summary>The single-replica database caused ninety minutes of downtime today. Why not just add a replica?</summary>

Because a database replica is not one decision — it is a set of them, and each has a cost that has to
be worth paying.

**Synchronous or asynchronous?** Synchronous replication means every write waits for the replica, so
write latency now includes a network hop and a slow replica slows the primary. Asynchronous means
failover can lose recently committed transactions. Neither is free; the second one changes what
"committed" means.

**Who decides to fail over?** Automatic failover needs a quorum that can distinguish a dead primary
from an unreachable one. On a four-node cluster with home nodes behind a domestic connection,
partitions are common — and an automatic failover that triggers on a partition can produce two
primaries, which is worse than the outage it prevents. Manual failover avoids that and means the
outage lasts until a human notices.

**What is the actual exposure?** Ninety minutes of downtime for a personal learning platform with a
handful of readers, against permanent extra operational complexity and a new class of failure I would
have to understand deeply. That maths is genuinely close, and it currently comes out against.

The change I would make first is cheaper and addresses the real cause: **stop co-locating the
database with the thing most likely to reboot.** Today's outage was not caused by the absence of a
replica — it was caused by everything write-related depending on one node that reboots more than the
others. Anti-affinity and better node hygiene remove most of the exposure without adding a
distributed-systems problem.

Replication is the right answer at the point where downtime costs someone other than me, and the
honest current position is: the risk is understood, priced, and accepted for now.

</details>
