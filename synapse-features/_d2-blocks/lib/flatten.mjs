#!/usr/bin/env node
// ── FLATTEN A BLOCK FOR PUBLICATION ───────────────────────────────────────────
// Turns `dsa/sliding-window-step.d2` into the self-contained source a lesson fence
// carries — because a fence has no filesystem. `...@lib/theme` resolves against the
// file on disk and against nothing at all inside a ```d2 block, so publishing a file
// verbatim would hand the reader source that silently loses every colour.
//
// Three transformations, in order:
//
//   1. the leading header comment is dropped — the lesson's prose already says what the
//      figure shows; every other comment (the `# TODO:` knobs especially) travels along
//   2. `...@lib/theme` becomes a `classes: {}` block holding ONLY the classes this file
//      actually names, in theme order, so a fence stays short enough to read
//   3. `...@lib/icons` disappears and every `${icon.foo}` becomes its literal URL
//
// Usage:  node lib/flatten.mjs <file.d2>        → flattened source on stdout
//         node lib/flatten.mjs --check <file>   → exit 1 if anything is unresolved

import { readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const LIB = dirname(fileURLToPath(import.meta.url));

/** Every `name: { … }` at the top level of a `classes` block, in declaration order.
 *  Theme classes are one line each by construction — a multi-line one throws here rather
 *  than silently emitting a truncated class. */
function readClasses(file) {
  const lines = readFileSync(file, "utf8").split("\n");
  const start = lines.findIndex((l) => /^\s*classes:\s*\{\s*$/.test(l));
  if (start === -1) throw new Error(`${file}: no classes block`);
  const out = new Map();
  for (let i = start + 1; i < lines.length; i += 1) {
    const line = lines[i];
    if (/^\s*\}\s*$/.test(line)) break;
    const match = line.match(/^\s{2,}([a-zA-Z][\w-]*):\s*\{/);
    if (!match) continue;
    const opens = (line.match(/\{/g) ?? []).length;
    const closes = (line.match(/\}/g) ?? []).length;
    if (opens !== closes) throw new Error(`${file}:${i + 1}: class "${match[1]}" must fit on one line`);
    out.set(match[1], line.replace(/^\s+/, "  "));
  }
  return out;
}

/** `vars.icon.*` from lib/icons.d2 — name → literal URL. */
function readIcons(file) {
  const out = new Map();
  for (const line of readFileSync(file, "utf8").split("\n")) {
    const match = line.match(/^\s{4,}([a-z][\w]*):\s*"(https:\/\/[^"]+)"/);
    if (match) out.set(match[1], match[2]);
  }
  return out;
}

/** Class names the source names, via `class: x` or `class: [x; y]`. */
function classesUsed(source) {
  const used = new Set();
  for (const match of source.matchAll(/\bclass:\s*(\[[^\]]*\]|[\w-]+)/g)) {
    const body = match[1].startsWith("[") ? match[1].slice(1, -1) : match[1];
    for (const name of body.split(/[;,]/)) {
      const trimmed = name.trim();
      if (trimmed) used.add(trimmed);
    }
  }
  return used;
}

/** Drop the file's leading comment block — its author-facing header — plus the blank
 *  line after it. A comment anywhere else is a knob and stays. */
function dropHeader(lines) {
  if (!lines[0]?.startsWith("#")) return lines;
  let i = 0;
  while (i < lines.length && lines[i].startsWith("#")) i += 1;
  while (i < lines.length && lines[i].trim() === "") i += 1;
  return lines.slice(i);
}

export function flatten(path) {
  const source = readFileSync(path, "utf8");
  const theme = readClasses(join(LIB, "theme.d2"));
  const icons = readIcons(join(LIB, "icons.d2"));
  const unresolved = [];

  let lines = dropHeader(source.split("\n"));

  const wantsTheme = lines.some((l) => /^\s*\.\.\.@(?:\.\.\/)*lib\/theme\s*$/.test(l));
  lines = lines.filter((l) => !/^\s*\.\.\.@(?:\.\.\/)*lib\/(?:theme|icons)\s*$/.test(l));
  while (lines.length && lines[0].trim() === "") lines.shift();

  let body = lines.join("\n").replace(/\$\{icon\.([\w]+)\}/g, (whole, name) => {
    const url = icons.get(name);
    if (!url) {
      unresolved.push(`unknown icon \`${name}\``);
      return whole;
    }
    return url;
  });

  if (wantsTheme) {
    const used = [...classesUsed(body)].filter((name) => theme.has(name));
    const missing = [...classesUsed(body)].filter((name) => !theme.has(name));
    // A class the file declares itself is fine; one it declares nowhere is a typo that
    // d2 accepts in silence, so it is reported here instead.
    const declared = new Set([...body.matchAll(/^\s{2,}([\w-]+):\s*\{/gm)].map((m) => m[1]));
    for (const name of missing) if (!declared.has(name)) unresolved.push(`unknown class \`${name}\``);
    if (used.length > 0) {
      const block = ["classes: {", ...[...theme.entries()].filter(([n]) => used.includes(n)).map(([, l]) => l), "}", ""];
      body = `${block.join("\n")}\n${body}`;
    }
  }

  return { source: body.replace(/\n+$/, "\n"), unresolved };
}

const args = process.argv.slice(2);
const check = args.includes("--check");
const file = args.find((a) => !a.startsWith("--"));
if (!file) {
  console.error("usage: flatten.mjs [--check] <file.d2>");
  process.exit(2);
}
const { source, unresolved } = flatten(resolve(file));
if (unresolved.length > 0) {
  for (const problem of unresolved) console.error(`${file}: ${problem}`);
  if (check) process.exit(1);
}
if (!check) process.stdout.write(source);
