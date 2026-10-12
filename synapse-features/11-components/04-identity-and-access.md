---
title: "Identity and access"
summary: "C4 level 3 for identity: how a token is verified without calling the identity provider, the four access lists that decide who may do what, and how deleting an account erases everything else first."
essential: true
---

# Identity and access

> **You'll be able to:** describe how the origin verifies a sign-in without a network call; name the
> four lists that grant access and what each one gates; and explain why an identity-provider outage
> returns 503 and not 401.

## Signing in

Sign-in is OpenID Connect against Keycloak, the realm `synapse`, using the authorization-code flow
with PKCE. The browser does that part with `keycloak-js`, loaded only when a reader signs in. Keycloak
offers GitHub as its upstream provider, so Synapse never sees a password. What reaches the origin is a
bearer token on each request that needs one.

```d2
direction: right

classes: {
  client: { style: { fill: "#f3f4f6"; stroke: "#6b7280"; font-color: "#111827" } }
  svc:    { style: { fill: "#dcfce7"; stroke: "#16a34a"; font-color: "#14532d" } }
  data:   { style: { fill: "#ffedd5"; stroke: "#ea580c"; font-color: "#7c2d12" } }
  external: { style: { fill: "#f8fafc"; stroke: "#94a3b8"; font-color: "#475569"; stroke-dash: 3 } }
}

browser: "Browser\n[keycloak-js]" { class: client }
idp: "Keycloak\n[realm synapse]" { class: external }
github: "GitHub\n[upstream sign-in]" { class: external }

origin: "Origin server" {
  verifier: "JwksTokenVerifier\n[TokenVerifier port]" { class: svc }
  service: "IdentityService" { class: svc }
  admin: "KeycloakAdminClient\n[KeycloakAdmin port]" { class: svc }
  gates: "other contexts\n[submission · authoring · catalog · admin routes]" { class: svc }
}

db: "Postgres\n[allowlists, readers]" { class: data; shape: cylinder }

browser -> idp: "authorization code + PKCE"
idp -> github: "sign in with GitHub"
browser -> origin.service: "Bearer token"
origin.service -> origin.verifier
origin.verifier -> idp: "JWKS (cached ~5 min)"
origin.gates -> origin.service: "who is this?"
origin.gates -> db: "is this name on the list?"
origin.admin -> idp: "delete user (scoped service account)"
```

## Verifying a token is local cryptography

`JwksTokenVerifier` (`identity/infrastructure/jwks.rs`) checks every bearer token without calling
Keycloak:

1. RS256 against the realm's signing keys. The key set is fetched lazily, cached for about five
   minutes, and refreshed **once** when a token names an unknown key id — which absorbs key rotation.
2. The issuer must match exactly; `exp` is checked with 60 s of leeway; `sub` and `exp` are required.
3. The audience: Keycloak's public clients carry `aud: ["account"]` and put the client in `azp`, so the
   rule is *`aud` contains `synapse-web`, or `azp` is `synapse-web`*.
4. The username leaves the verifier in **canonical lowercase**, applied once. Every later
   comparison — the admin check, every allowlist — is case-consistent by construction rather than by
   each caller remembering.

Two answers come out, and they are different on purpose. A bad token is `InvalidToken` → **401**. A
key set that cannot be fetched is `VerifierUnavailable` → **503**. "I cannot check" is not "you are
not allowed", and conflating them would lock out legitimate users during an outage. Reading and
running never verify a token at all, so a Keycloak outage does not stop anyone reading.

Other contexts call the identity **application service** and state their own 401 and 503 mapping.
They never reach into the identity context's HTTP adapter.

## Four lists decide access

Signing in proves who you are. These four lists decide what you may do:

| List | Stored in | Gates | Managed from |
| --- | --- | --- | --- |
| **Admins** | `ADMIN_USERS` env var (prod: `ani2fun`) | every `/api/admin/*` route and the `/admin` page | the deployment manifest — granting admin needs a commit |
| **Submit allowlist** | `submission_allowlist` | judged submissions, when `SUBMISSION_ALLOWLIST_ENFORCED` is on (it is in prod) | `/admin` |
| **Content editors** | `content_editor_allowlist` | Suggest an edit (`/api/edits`) | `/admin` |
| **Private-book readers** | `content_source_reader` | a private source's lessons, media and widgets | `/admin`, per source |

Each list takes a **canonical name** of the same type the verifier produces, so a grant and the gate
that checks it cannot disagree about case. The asymmetry in the first row is deliberate: everything
else can be granted from a screen in a second, but making someone an admin takes a reviewed change to
the deployment. [Trade-offs](/synapse/synapse-features/decisions/trade-offs) argues it.

## Deleting an account

`/account` offers four permanent actions behind confirm dialogs: reset progress, erase submissions,
erase all data, and delete the account. Deleting the account runs, **in the browser**:

1. erase submissions,
2. erase Think canvases,
3. erase notes,
4. reset progress,
5. `DELETE /api/me` — the origin deletes the Keycloak user,
6. sign out.

The orchestration sits on the client so that the identity context never depends on submissions,
notes or progress. Lesson views need no step, because they never recorded who read them.

The Keycloak call uses `KeycloakAdminClient`, which signs in as a **service account in Synapse's own
realm** (`synapse-admin`, client credentials) holding only `realm-management:manage-users`. It is
never the master-realm administrator, whose leaked credentials would mean a full identity-provider
takeover. A delete is two calls — get a token, then `DELETE /admin/realms/synapse/users/{sub}` — and
both 204 and 404 count as success, because a user who is already gone is the outcome that was asked
for.
