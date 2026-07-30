# Two-stage build: compile the merged LikeC4 SPA from every .c4 in this repo, then
# serve it from nginx-unprivileged at the /c4/ subpath. Synapse's server reverse-
# proxies /c4/* to this image's Service in-cluster — no public Ingress on this image.
#
# This mirrors the dev compose service exactly: the repo root IS the LikeC4 project
# root (LikeC4 reads .c4 files recursively; the merged workspace carries exactly ONE
# `specification {}` — synapse-features/03-architecture-docs/client-server.c4 — which
# `npx likec4 validate` gates in dev). local-only/ books never reach this image: they
# are gitignored, so a CI checkout simply doesn't contain them.

FROM node:22-alpine AS builder
WORKDIR /c4
RUN npm install -g likec4@latest

COPY . /c4/

# --base /c4/: the viewer is served THROUGH the app's /c4 proxy, so its asset URLs
# must be /c4/assets/*. --no-use-dot: the WASM layouter (same as dev; alpine has no
# Graphviz `dot`, which `likec4 build` would otherwise auto-enable in a container).
RUN set -eu; \
    count=$(find /c4 -type f -name '*.c4' | wc -l); \
    if [ "$count" -eq 0 ]; then echo "ERROR: no .c4 sources in the checkout"; exit 1; fi; \
    echo "Building the merged LikeC4 SPA from $count source(s)"; \
    likec4 build --base /c4/ --no-use-dot --output /dist .

FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY --from=builder /dist /usr/share/nginx/html/c4/
RUN printf '%s\n' \
  'server {' \
  '  listen 8080;' \
  '  root /usr/share/nginx/html;' \
  '  location /c4/ { try_files $uri $uri/ /c4/index.html; }' \
  '  location / { return 404; }' \
  '}' > /etc/nginx/conf.d/default.conf
EXPOSE 8080
