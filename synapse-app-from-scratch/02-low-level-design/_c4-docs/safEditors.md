---
title: content_editor_allowlist
kind: Component
technology: table
---

## `content_editor_allowlist`

```sql
create table content_editor_allowlist (
    username   text        primary key,
    note       text,
    granted_at timestamptz not null default now()
);
```

Who may propose a content change. Keyed by the lowercase IdP username, exactly like its sibling,
because the token verifier canonicalises once and every comparison downstream is apples-to-apples.

### Why this is not the submit allowlist

The two tables are byte-identical in shape and deliberately separate, which looks like duplication
until you read what each grant *means*:

| Grant | Permits | Blast radius |
|---|---|---|
| `submission_allowlist` | spend shared compute and storage saving judged attempts | this deployment |
| `content_editor_allowlist` | open pull requests against a **public repository** under the deployment's own token | a public repo, under my name |

Those are different decisions. Merging them would mean that granting someone the ability to save
their homework silently granted them the ability to push branches to a repository the world can see
— and, worse, that revoking one quietly revoked the other.

Keeping them apart makes the trust decision explicit at grant time rather than inherited from an
unrelated one. Two small tables is a cheap price for that.
