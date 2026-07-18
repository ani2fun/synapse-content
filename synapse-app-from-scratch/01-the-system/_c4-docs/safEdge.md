---
title: Edge
kind: CDN
technology: Cloudflare
---

## Edge

The read path's actual capacity. Lesson JSON is served with `max-age=60, stale-while-revalidate=600`
and asset bundles with `immutable` for a year.

### Measured, from Paris

| Path | Time to first byte |
|---|---|
| In-cluster, no CDN | ~14 ms |
| Edge cache hit | ~48 ms (median of 12) |
| Origin through the CDN | ~208 ms (median of 12) |

So a cache hit is roughly **4× faster** than reaching the origin, and that gap widens with distance
— the origin is a single machine in one house, while the edge is wherever the reader is.

The sixty-second lifetime is not arbitrary: it matches the interval at which the content sidecar
polls for new prose. Caching longer than the content can change buys nothing but staleness.

### The rule that keeps it safe

Only two path prefixes are cacheable, and both serve identical bytes to every reader. Anything
user-specific — identity, submissions, admin — is explicitly outside the rule. A shared cache in
front of a per-user response is one of the most damaging mistakes available in web architecture, and
the narrowness of the rule is the defence.
