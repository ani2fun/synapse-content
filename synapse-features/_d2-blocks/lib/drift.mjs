#!/usr/bin/env node
// ── HAS A LESSON DRIFTED FROM ITS BLOCK? ──────────────────────────────────────
// Every figure in this chapter is generated — `./render.sh fence`, `anim`, `player` — and
// then pasted. Pasting is where the rot starts: edit `dsa/heap.d2`, forget the lesson, and
// the page keeps showing last week's diagram under this week's caption. Nothing else would
// notice, because the stale fence still compiles perfectly.
//
// So this asserts the whole set rather than tracking which lesson holds which block: every
// ```d2 fence in the chapter must be byte-identical to the flattened form of SOME file on
// disk, and every /media/ image a lesson references must exist. A fence that matches
// nothing is a fence somebody hand-edited or forgot to regenerate.
//
// Usage:  node lib/drift.mjs <lesson-dir>

import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { join, resolve } from "node:path";
import { flatten } from "./flatten.mjs";

const lessonDir = process.argv[2] ?? "../05-d2-component-library";
const repoRoot = resolve("../..");

/** Every .d2 under the library that a lesson could be showing. */
function blockFiles(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const path = join(dir, entry);
    if (statSync(path).isDirectory()) blockFiles(path, out);
    else if (entry.endsWith(".d2") && !entry.endsWith("-loop.d2")) out.push(path);
  }
  return out;
}

const known = new Map(); // flattened source → the file it came from
for (const dir of ["demo", "dsa", "system-design"]) {
  if (!existsSync(dir)) continue;
  for (const file of blockFiles(dir)) {
    try {
      known.set(flatten(resolve(file)).source.trimEnd(), file);
    } catch {
      /* a file that will not flatten fails the render gate, not this one */
    }
  }
}

let problems = 0;
let fences = 0;
let images = 0;

for (const name of readdirSync(lessonDir).filter((f) => f.endsWith(".md")).sort()) {
  const lines = readFileSync(join(lessonDir, name), "utf8").split("\n");
  let open = null;
  let body = [];
  let openedAt = 0;
  lines.forEach((line, i) => {
    if (open === null && line.startsWith("```")) {
      open = line.slice(3).trim();
      body = [];
      openedAt = i + 1;
    } else if (open !== null && line === "```") {
      if (open === "d2" || open.startsWith("d2 ")) {
        fences += 1;
        if (!known.has(body.join("\n").trimEnd())) {
          console.error(`${name}:${openedAt}: a \`\`\`${open} fence matches no block on disk — regenerate it`);
          problems += 1;
        }
      }
      open = null;
    } else if (open !== null) {
      body.push(line);
    } else {
      const image = /^!\[[^\]]*\]\((\/media\/[^)]+)\)/.exec(line);
      if (image) {
        images += 1;
        if (!existsSync(join(repoRoot, "_media", image[1].slice("/media/".length)))) {
          console.error(`${name}:${i + 1}: ${image[1]} does not exist — run ./render.sh media`);
          problems += 1;
        }
      }
    }
  });
  if (open !== null) {
    console.error(`${name}: a \`\`\`${open} fence opened at line ${openedAt} and never closed`);
    problems += 1;
  }
}

console.log(`  ${fences} fence(s) and ${images} image(s) across ${lessonDir}, against ${known.size} block(s)`);
process.exit(problems === 0 ? 0 : 1);
