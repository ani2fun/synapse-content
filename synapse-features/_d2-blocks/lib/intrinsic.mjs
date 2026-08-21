#!/usr/bin/env node
// ── GIVE A MEDIA SVG AN INTRINSIC SIZE ────────────────────────────────────────
// d2 writes `viewBox` on the outer <svg> and `width`/`height` only on the inner one. Inlined
// into a page that is fine — the fence figures are real DOM and CSS sizes them. Referenced
// from an `<img>` it is not: an SVG with a ratio but no intrinsic size falls back to the CSS
// default of 300px, and `.diagram--frames img { width: auto }` then renders a 942-wide
// diagram at 300.
//
// So every file this library publishes under _media/ gets width and height copied off its own
// viewBox. With `max-width: 100%` above it, the figure draws at its natural size on a wide
// screen and shrinks on a narrow one — the same behaviour an inlined fence figure has.
//
// Usage:  node lib/intrinsic.mjs <file.svg> [...]

import { readFileSync, writeFileSync } from "node:fs";

let touched = 0;
for (const file of process.argv.slice(2)) {
  const svg = readFileSync(file, "utf8");
  const open = svg.match(/<svg\b[^>]*>/);
  if (!open) continue;
  if (/\bwidth=/.test(open[0])) continue; // already sized
  const box = open[0].match(/viewBox="\s*([\d.+-]+)\s+([\d.+-]+)\s+([\d.+-]+)\s+([\d.+-]+)\s*"/);
  if (!box) continue;
  const sized = open[0].replace(
    /<svg\b/,
    `<svg width="${Math.round(Number(box[3]))}" height="${Math.round(Number(box[4]))}"`,
  );
  writeFileSync(file, svg.replace(open[0], sized));
  touched += 1;
}
process.stdout.write(`${touched}\n`);
