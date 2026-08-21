#!/usr/bin/env bash
# ── THE GATE ──────────────────────────────────────────────────────────────────
# Renders every block in this library and proves the published form of each one still
# compiles. Nothing here ships until this exits 0.
#
#   ./render.sh          render every block   → build/<same-path>.svg   (+ flat source)
#   ./render.sh png      the same, plus PNGs  → build/<same-path>.png   (to eyeball)
#   ./render.sh fence <path>  the ```bash + ```d2 pair for a lesson, on stdout
#   ./render.sh sheet    one captioned PNG per directory → build/sheet-<dir>.png
#   ./render.sh icons    every icon URL answers 200
#   ./render.sh app      draw the LESSON fences with the app's own engine
#   ./render.sh all      icons + render + app
#
# Two engines, deliberately. `d2` here is whatever you have installed; the app draws with
# a pinned WASM build (v0.7.0 at the time of writing) through dev-tools/render-d2.mjs, and
# they are NOT the same — v0.8.1 inlines icon bytes, v0.7.0 leaves them as remote URLs.
# `./render.sh app` is the one that speaks for the reader.
#
# Layout is ELK and padding is 20 because that is what the app uses
# (web/src/lib/islands/diagram/d2.ts: LAYOUT = "elk", pad: 20). The CLI defaults to dagre
# and pad 100 — gate with those and you are eyeballing a picture no reader ever sees.
set -uo pipefail
cd "$(dirname "$0")"

SYNAPSE="${SYNAPSE_REPO:-$HOME/Development/homelab/synapse}"
BUILD=build
fail=0
green() { printf '\033[32m%s\033[0m\n' "$1"; }
red() { printf '\033[31m%s\033[0m\n' "$1"; }

blocks() { find demo dsa system-design -name '*.d2' 2>/dev/null | sort; }

# ── lib/ holds definitions, not diagrams ─────────────────────────────────────
# A file that is only a `classes` or `vars` block renders to nothing at all and still
# exits 0, so it is validated rather than rendered — otherwise the gate passes on a
# theme with a syntax error in it.
validate_lib() {
  for file in lib/*.d2; do
    if ! d2 validate "$file" >/dev/null 2>&1; then
      red "  ✗ $file does not parse"
      d2 validate "$file" 2>&1 | sed 's/^/      /'
      fail=1
    fi
  done
}

# ── render ───────────────────────────────────────────────────────────────────
# Each block twice: once as written (proving the import resolves) and once flattened
# (proving what the lesson publishes still compiles on its own). A block whose file is
# fine but whose flattened form is broken would ship a dead fence.
render() {
  local want_png="${1:-}" n=0
  for file in $(blocks); do
    n=$((n + 1))
    local out="$BUILD/${file%.d2}.svg" flat="$BUILD/${file%.d2}.flat.d2"
    mkdir -p "$(dirname "$out")"

    if ! d2 --layout elk --pad 20 "$file" "$out" >/dev/null 2>&1; then
      red "  ✗ $file"
      d2 --layout elk --pad 20 "$file" "$out" 2>&1 | tail -3 | sed 's/^/      /'
      fail=1
      continue
    fi
    # d2 exits 0 for a source that draws nothing; the file is the real evidence.
    if [[ ! -s "$out" ]]; then
      red "  ✗ $file compiled to an empty diagram"
      fail=1
      continue
    fi

    if ! node lib/flatten.mjs "$file" > "$flat" 2>/tmp/flatten.err; then
      red "  ✗ $file — flatten: $(cat /tmp/flatten.err)"
      fail=1
      continue
    fi
    if ! d2 --layout elk --pad 20 "$flat" /dev/null >/dev/null 2>&1; then
      red "  ✗ $file — the PUBLISHED form does not compile"
      d2 --layout elk --pad 20 "$flat" /dev/null 2>&1 | tail -3 | sed 's/^/      /'
      fail=1
      continue
    fi

    if [[ "$want_png" == png ]]; then
      rsvg-convert -z 1.5 -b white "$out" -o "${out%.svg}.png" 2>/dev/null ||
        red "  ! $file — no PNG (install librsvg to eyeball locally)"
    fi
  done
  green "  $n block(s) rendered to $BUILD/"
}

# ── a lesson's fence pair ────────────────────────────────────────────────────
# A lesson shows each block as source-then-figure: a ```bash fence a reader can read and
# copy, then a ```d2 fence the renderer draws. Both carry the FLATTENED source, because a
# ```d2 fence has no filesystem and `...@../lib/theme` would resolve to nothing in it.
#
# Generated, never hand-copied — a lesson holding a stale copy of a block is a figure that
# disagrees with its own caption, and nothing would catch it.
emit_fence() {
  local file="$1" flat
  flat=$(node lib/flatten.mjs "$file") || { red "✗ $file"; return 1; }
  printf '```bash\n%s\n```\n\n```d2\n%s\n```\n' "$flat" "$flat"
}

# ── contact sheets ───────────────────────────────────────────────────────────
# One PNG per top-level directory. Reviewing a library a file at a time is how a
# collapsed cell survives to publication; a sheet makes the bad one obvious.
sheets() {
  for dir in demo dsa system-design; do
    local svgs
    svgs=$(find "$BUILD/$dir" -name '*.svg' 2>/dev/null | sort)
    [[ -z "$svgs" ]] && continue
    # shellcheck disable=SC2086
    python3 lib/sheet.py "$BUILD/sheet-$(basename "$dir").png" $svgs >/dev/null &&
      green "  build/sheet-$(basename "$dir").png" ||
      { red "  ✗ contact sheet for $dir"; fail=1; }
  done
}

# ── icons ────────────────────────────────────────────────────────────────────
# The CDN answers 403, not 404, for a path that does not exist, and d2 turns an icon it
# cannot fetch into an empty box without a word of complaint. So every URL is probed.
check_icons() {
  local n=0 bad=0
  while read -r url; do
    n=$((n + 1))
    local code
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$url")
    if [[ "$code" != 200 ]]; then
      red "  ✗ $code  $url"
      bad=$((bad + 1))
    fi
  done < <(grep -oE 'https://icons\.d2lang\.com/[^"]+' lib/icons.d2 | sort -u)
  if ((bad > 0)); then
    fail=1
    red "  $bad of $n icon URL(s) do not resolve"
  else
    green "  $n icon URL(s) resolve"
  fi
}

# ── the app's own engine ─────────────────────────────────────────────────────
# Compiles every ```d2 fence in the lessons with the WASM build the app pins, which is a
# DIFFERENT d2 from the CLI above (v0.7.0 vs whatever you have installed). A fence the CLI
# accepts can still be rejected there, and the failure mode in production is silent — the
# page just falls back to compiling in the reader's browser.
#
# It draws into a throwaway root rather than the repo's own `_media/d2`, because
# committing those figures is CI's job (.github/workflows/render-d2.yml) and a local run
# would leave a pile of untracked SVGs behind. Pass APP_GATE_INPLACE=1 to draw them here
# for real — useful when you want the dev server to serve inlined figures immediately.
check_app() {
  local repo scratch root
  repo=$(cd ../.. && pwd)
  if [[ ! -f "$SYNAPSE/dev-tools/render-d2.mjs" ]]; then
    red "  ✗ no app checkout at $SYNAPSE (set SYNAPSE_REPO)"
    fail=1
    return
  fi

  if [[ "${APP_GATE_INPLACE:-}" == 1 ]]; then
    root="$repo"
  else
    scratch=$(mktemp -d)
    root="$scratch/content"
    mkdir -p "$root"
    # Only the lessons: the gate is about what the reader receives, and copying the whole
    # repo would redraw every book to prove nothing.
    ( cd "$repo" && find . -path ./node_modules -prune -o -name '*.md' -print |
        while read -r f; do mkdir -p "$root/$(dirname "$f")"; cp "$f" "$root/$f"; done )
  fi

  if ( cd "$SYNAPSE/web" && node ../dev-tools/render-d2.mjs "$root" ); then
    green "  every fence compiles under the app's engine"
  else
    red "  ✗ the app engine rejected a fence"
    fail=1
  fi
  [[ -n "${scratch:-}" ]] && rm -rf "$scratch"
  return 0
}

case "${1:-render}" in
  render) echo "→ lib"; validate_lib; echo "→ blocks (elk)"; render ;;
  png)    echo "→ lib"; validate_lib; echo "→ blocks (elk) + png"; render png ;;
  fence)  emit_fence "${2:?usage: ./render.sh fence dsa/array-strip.d2}"; exit 0 ;;
  sheet)  echo "→ lib"; validate_lib; echo "→ blocks (elk)"; render; echo "→ contact sheets"; sheets ;;
  icons)  echo "→ icon urls"; check_icons ;;
  app)    echo "→ the app's engine"; check_app ;;
  all)    echo "→ icon urls"; check_icons
          echo "→ lib"; validate_lib
          echo "→ blocks (elk)"; render
          echo "→ contact sheets"; sheets
          echo "→ the app's engine"; check_app ;;
  *) echo "usage: ./render.sh [render|png|sheet|fence <path>|icons|app|all]" >&2; exit 2 ;;
esac

((fail)) && { red "FAILED"; exit 1; }
green "OK"
