---
title: Identity provider
kind: Identity provider
technology: Keycloak
---

## Identity provider

Authorization-code flow with PKCE, and GitHub as an upstream provider — so the platform never sees a
password.

### It is not on the hot path

Per-request verification is **local cryptography**. Signing keys are fetched once, cached for five
minutes, and refreshed exactly once on an unknown key id to absorb rotation. Verifying a bearer token
is a signature check against a cached key, not a network call, which is why authentication adds no
meaningful latency and why an identity outage does not stop people reading.

### Two deliberate details

- **Usernames are canonicalised to lowercase once**, at the verifier. Every downstream comparison —
  the admin check, the allowlist lookup — is therefore case-consistent by construction rather than by
  each caller remembering.
- **Unreachable returns 503, not 401.** A failure to verify is not a failed verification.
