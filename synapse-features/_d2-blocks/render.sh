#!/usr/bin/env bash
# ── THE GATE ──────────────────────────────────────────────────────────────────
# Renders every block in this library and proves the published form of each one still
# compiles. Nothing here ships until this exits 0.
#
#   ./render.sh          render every block   → build/<same-path>.svg   (+ flat source)
#   ./render.sh png      the same, plus PNGs  → build/<same-path>.png   (to eyeball)
#   ./render.sh fence <path>       the ```bash + ```d2 pair for a lesson, on stdout
#   ./render.sh anim   <anim-dir>  the ```bash + N consecutive ```d2 fences of a stepper
#   ./render.sh player <anim-dir>  the ```bash + the frame run of a player
#   ./render.sh stable             every highlight-mode animation is layout-stable
#   ./render.sh drift              no lesson shows a figure its block no longer draws
#   ./render.sh media              the two figures that ship as FILES, into _media/
#   ./render.sh sheet    one captioned PNG per directory → build/sheet-<dir>.png
#   ./render.sh icons    every icon URL answers 200
#   ./render.sh app      draw the LESSON fences with the app's own engine
#   ./render.sh all      icons + lib + blocks + stability + sheets + app
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
# Where the two file-based figures land. `animating-a-diagram` is the lesson that carries
# them; media paths follow /media/<book-slug>/<lesson-slug>/ (authoring contract A4).
MEDIA_ROOT=../../_media/synapse-features
LOOP_MS=1600
fail=0
green() { printf '\033[32m%s\033[0m\n' "$1"; }
red() { printf '\033[31m%s\033[0m\n' "$1"; }

# A block is any .d2 that draws ONE figure. The two multi-board kinds are excluded: d2
# writes a DIRECTORY of boards for those, so the ordinary render path would silently
# create `build/foo.svg/` and call it a success.
blocks() { find demo dsa system-design -name '*.d2' ! -name '*-loop.d2' ! -name '*-boards.d2' 2>/dev/null | sort; }
anims() { find dsa system-design -type d -name '*.anim' 2>/dev/null | sort; }
# One animation's frames, in order. `base.d2` is frame zero and is rendered as a block,
# but it is not a frame of the published sequence.
frames() { find "$1" -name '[0-9]*.d2' | sort; }
mode_of() { sed -n 's/^# animation-mode: *//p' "$1/base.d2" | head -1; }
lesson_of() { sed -n 's/^# lesson: *//p' "$1/base.d2" | head -1; }
caption_of() { sed -n 's/^# caption: *//p' "$1/base.d2" | head -1; }

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

# ── the multi-board pair ─────────────────────────────────────────────────────
# `*-loop.d2` compiles to ONE self-animating svg (`--animate-interval`); `*-boards.d2`
# compiles to a directory of boards the walkthrough viewer navigates. Neither goes
# through `render`, and neither is a fence the app draws from source.
render_boards() {
  local n=0
  for file in $(find system-design dsa -name '*-loop.d2' 2>/dev/null | sort); do
    n=$((n + 1))
    local out="$BUILD/${file%.d2}.svg"
    mkdir -p "$(dirname "$out")"
    if ! d2 --layout elk --pad 20 --target '*' --animate-interval "$LOOP_MS" "$file" "$out" >/dev/null 2>&1; then
      red "  ✗ $file (animated)"; fail=1; continue
    fi
    # An animated svg that carries no keyframes is a still picture with extra steps.
    if ! grep -q '@keyframes' "$out"; then
      red "  ✗ $file rendered without keyframes — is there a steps: block?"; fail=1
    fi
  done
  for file in $(find system-design dsa -name '*-boards.d2' 2>/dev/null | sort); do
    n=$((n + 1))
    local out="$BUILD/${file%.d2}"
    rm -rf "$out"; mkdir -p "$out"
    if ! d2 --layout elk --pad 20 "$file" "$out/board.svg" >/dev/null 2>&1; then
      red "  ✗ $file (boards)"; fail=1; continue
    fi
    # A walkthrough with one board is a walkthrough that lost its links.
    local boards; boards=$(find "$out" -name '*.svg' | wc -l | tr -d ' ')
    if [[ "$boards" -lt 2 ]]; then
      red "  ✗ $file drew $boards board(s) — layers: missing, or every link was dropped"; fail=1
    fi
  done
  green "  $n multi-board source(s)"
}

# ── layout stability ─────────────────────────────────────────────────────────
# THE gate for animations, and the one nothing else would catch. A highlight-mode
# animation is watchable only because every frame has the same geometry; if one frame is
# 80px wider, the figure jumps under the reader on every step and the eye tracks the jump
# instead of the change. A build-mode animation grows on purpose and is exempt.
#
# Tolerance is 2%: a heavier stroke on a highlighted node genuinely does move the bounding
# box by a pixel or two, and failing on that would be noise.
check_stability() {
  local n=0
  for dir in $(anims); do
    local mode; mode=$(mode_of "$dir")
    if [[ "$mode" != highlight ]]; then
      printf '  ·  %-42s %s — exempt\n' "$dir" "${mode:-no mode declared}"
      [[ -z "$mode" ]] && { red "     ✗ base.d2 declares no '# animation-mode:'"; fail=1; }
      continue
    fi
    n=$((n + 1))
    local widths=() heights=() f
    for f in $(frames "$dir"); do
      local svg="$BUILD/${f%.d2}.svg" box
      box=$(grep -o 'viewBox="[^"]*"' "$svg" 2>/dev/null | head -1)
      [[ -z "$box" ]] && { red "     ✗ $f not rendered"; fail=1; continue; }
      widths+=("$(echo "$box" | awk '{print $3}')")
      heights+=("$(echo "$box" | awk '{print $4}' | tr -d '"')")
    done
    local report; report=$(printf '%s\n' "${widths[@]}" | sort -n | awk -v h="$(printf '%s\n' "${heights[@]}" | sort -n | tr '\n' ' ')" '
      NR==1{lo=$1} {hi=$1} END{
        split(h, hs, " "); hlo=hs[1]; hhi=hs[length(hs)]
        wdrift = lo>0 ? (hi-lo)*100/lo : 0
        hdrift = hlo>0 ? (hhi-hlo)*100/hlo : 0
        drift = wdrift > hdrift ? wdrift : hdrift
        printf "%dx%d–%dx%d  drift %.1f%%|%d", lo, hlo, hi, hhi, drift, (drift > 2)
      }')
    local bad="${report##*|}" text="${report%|*}"
    if [[ "$bad" == 1 ]]; then
      red "     ✗ $dir  $text — frames do not line up"
      fail=1
    else
      printf '  ✓  %-42s %s\n' "$dir" "$text"
    fi
  done
  green "  $n highlight-mode animation(s) checked"
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

# ── a stepper ────────────────────────────────────────────────────────────────
# An animation publishes as ONE ```bash fence — the AUTHORING form, base plus each
# frame's delta, which is what a reader would actually copy into their own library — then
# N CONSECUTIVE ```d2 fences, which the app groups into a stepper (‹ i/n ›).
#
# Consecutive is load-bearing: a ```bash fence between two ```d2 fences splits the run
# into two separate figures. Everything after the first d2 fence here is d2, deliberately.
emit_anim() {
  local dir="${1%/}" f
  printf '```bash\n# %s/base.d2 — declared once, spread into every frame\n%s\n' \
    "$(basename "$dir")" "$(cat "$dir/base.d2")"
  for f in $(frames "$dir"); do
    printf '\n# ── %s ─────────────────────────────────\n%s\n' "$(basename "$f")" "$(cat "$f")"
  done
  printf '```\n'
  # The newline before the closing fence is not cosmetic: `$(...)` strips trailing
  # newlines, so without it the backticks land on the end of the last line of source and
  # the fence never closes — swallowing the rest of the lesson into one broken diagram.
  for f in $(frames "$dir"); do
    printf '\n```d2\n%s\n```\n' "$(node lib/flatten.mjs "$f")"
  done
}

# ── the figures that ship as files ───────────────────────────────────────────
# Most of this library reaches a reader as source inside a fence. Animations mostly do
# NOT, and the reason is a runtime cost rather than a rendering one: a stepper (adjacent
# ```d2 fences) ships its later slides as SOURCE and the reader's browser compiles them,
# which means pulling the ~6 MB d2 engine the moment they press ›. A player — one image
# per frame, grouped by alt text — ships pre-drawn files served with a cache header, and
# costs the page a handful of URLs.
#
# So every animation is drawn to `_media/<book>/<lesson>/<name>/frame-N.svg`, and the
# lesson shows the authoring source in a ```bash fence beside it. Each base.d2 says which
# lesson it belongs to (`# lesson:`) and what the run is called (`# caption:`).
#
# The auto-loop is the other file-only figure: `--animate-interval` packs every board into
# one self-animating svg, and the app's renderer never passes that flag.
build_media() {
  local dir slug caption out i f n=0
  for dir in $(anims); do
    slug=$(lesson_of "$dir"); caption=$(caption_of "$dir")
    if [[ -z "$slug" || -z "$caption" ]]; then
      red "  ✗ $dir/base.d2 declares no '# lesson:' / '# caption:'"; fail=1; continue
    fi
    out="$MEDIA_ROOT/$slug/$(basename "${dir%.anim}")"
    rm -rf "$out"; mkdir -p "$out"
    i=0
    for f in $(frames "$dir"); do
      i=$((i + 1))
      d2 --layout elk --pad 20 "$f" "$out/frame-$i.svg" >/dev/null 2>&1 ||
        { red "  ✗ $f"; fail=1; }
    done
    # An <img> needs an intrinsic size; d2 leaves the outer <svg> with a viewBox and no
    # width, which renders a 942-wide diagram at the CSS default of 300px.
    node lib/intrinsic.mjs "$out"/frame-*.svg >/dev/null
    n=$((n + 1))
    printf '  ✓  %-40s → %s/frame-1..%d.svg\n' "$(basename "$dir")" "${out#"$MEDIA_ROOT"/}" "$i"
  done
  green "  $n animation(s) drawn under $MEDIA_ROOT"

  local loop=system-design/animated/cache-aside-loop.d2
  mkdir -p "$MEDIA_ROOT/animating-a-diagram"
  if d2 --layout elk --pad 20 --target '*' --animate-interval "$LOOP_MS" "$loop" "$MEDIA_ROOT/animating-a-diagram/cache-aside-loop.svg" >/dev/null 2>&1; then
    node lib/intrinsic.mjs "$MEDIA_ROOT/animating-a-diagram/cache-aside-loop.svg" >/dev/null
    green "  cache-aside-loop.svg  ($(wc -c < "$MEDIA_ROOT/animating-a-diagram/cache-aside-loop.svg" | tr -d ' ') bytes, ${LOOP_MS}ms)"
  else
    red "  ✗ $loop"; fail=1
  fi
}

# ── a player ─────────────────────────────────────────────────────────────────
# The ```bash authoring form, then the frame run. A run of consecutive images whose alt
# text ends `— frame i of N`, under a `// Interactive Diagram (N frames): …` marker line,
# collapses into ONE figure with play/pause, a scrubber and the arrow keys.
#
# The alt text is the only grouping signal, so the caption must be byte-identical in the
# marker and in every alt — which is why both come from base.d2 rather than being typed.
emit_player() {
  local dir="${1%/}" slug caption name total i=0 f
  slug=$(lesson_of "$dir"); caption=$(caption_of "$dir"); name=$(basename "${dir%.anim}")
  total=$(frames "$dir" | wc -l | tr -d ' ')
  printf '```bash\n# %s/base.d2 — declared once, spread into every frame\n%s\n' \
    "$(basename "$dir")" "$(cat "$dir/base.d2")"
  for f in $(frames "$dir"); do
    printf '\n# ── %s ─────────────────────────────────\n%s\n' "$(basename "$f")" "$(cat "$f")"
  done
  printf '```\n\n// Interactive Diagram (%d frames): %s\n' "$total" "$caption"
  for f in $(frames "$dir"); do
    i=$((i + 1))
    printf '\n![%s — frame %d of %d](/media/synapse-features/%s/%s/frame-%d.svg)\n' \
      "$caption" "$i" "$total" "$slug" "$name" "$i"
  done
}

# ── has a lesson drifted from its block? ─────────────────────────────────────
# Every figure in the chapter is generated and then pasted, and pasting is where the rot
# starts: edit a block, forget the lesson, and the page keeps showing last week's diagram
# under this week's caption — still compiling perfectly. See lib/drift.mjs.
check_drift() {
  if node lib/drift.mjs ../05-d2-component-library; then
    green "  every fence in the chapter still matches a block on disk"
  else
    red "  ✗ a lesson has drifted from its source"
    fail=1
  fi
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
  local dir
  for dir in $(anims); do
    local svgs; svgs=$(frames "$dir" | sed "s|^|$BUILD/|; s|\.d2$|.svg|")
    # shellcheck disable=SC2086
    python3 lib/sheet.py "$BUILD/sheet-anim-$(basename "${dir%.anim}").png" $svgs >/dev/null &&
      green "  build/sheet-anim-$(basename "${dir%.anim}").png" ||
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
  render) echo "→ lib"; validate_lib; echo "→ blocks (elk)"; render; echo "→ multi-board"; render_boards ;;
  png)    echo "→ lib"; validate_lib; echo "→ blocks (elk) + png"; render png; echo "→ multi-board"; render_boards ;;
  fence)  emit_fence "${2:?usage: ./render.sh fence dsa/array-strip.d2}"; exit 0 ;;
  anim)   emit_anim "${2:?usage: ./render.sh anim dsa/sliding-window.anim}"; exit 0 ;;
  player) emit_player "${2:?usage: ./render.sh player dsa/sliding-window.anim}"; exit 0 ;;
  stable) echo "→ blocks (elk)"; render; echo "→ layout stability"; check_stability ;;
  drift)  echo "→ lesson ↔ block drift"; check_drift ;;
  media)  echo "→ figures that ship as files"; build_media ;;
  sheet)  echo "→ lib"; validate_lib; echo "→ blocks (elk)"; render; echo "→ contact sheets"; sheets ;;
  icons)  echo "→ icon urls"; check_icons ;;
  app)    echo "→ the app's engine"; check_app ;;
  all)    echo "→ icon urls"; check_icons
          echo "→ lib"; validate_lib
          echo "→ blocks (elk)"; render
          echo "→ multi-board"; render_boards
          echo "→ layout stability"; check_stability
          echo "→ figures that ship as files"; build_media
          echo "→ lesson ↔ block drift"; check_drift
          echo "→ contact sheets"; sheets
          echo "→ the app's engine"; check_app ;;
  *) echo "usage: ./render.sh [render|png|sheet|fence <path>|anim <dir>|player <dir>|stable|drift|media|icons|app|all]" >&2; exit 2 ;;
esac

((fail)) && { red "FAILED"; exit 1; }
green "OK"
