#!/usr/bin/env python3
"""Stack rendered blocks into one contact-sheet PNG.

Reviewing ninety diagrams one file at a time is how a misaligned column survives to
publication. A sheet puts a whole directory on one screen, captioned, at a scale where
overlapping labels and collapsed cells are obvious.

  ./render.sh sheet          -> build/sheet-dsa.png, build/sheet-system-design.png

Icons will be MISSING from a sheet built out of app-rendered SVGs: d2 leaves them as
remote <image href> and rsvg-convert does not fetch over the network. Judge icon
diagrams in a browser, not here.
"""
import base64, re, subprocess, sys, pathlib

W = 1500          # sheet width
CAP = 26          # caption band height
GAP = 14

def dims(svg):
    m = re.search(r'viewBox="([\d.\-]+) ([\d.\-]+) ([\d.\-]+) ([\d.\-]+)"', svg)
    return (float(m.group(3)), float(m.group(4))) if m else (600.0, 300.0)

def build(paths, out):
    parts, y = [], 0
    for p in paths:
        svg = pathlib.Path(p).read_text()
        w, h = dims(svg)
        scale = min(1.0, (W - 40) / w)
        dw, dh = w * scale, h * scale
        b64 = base64.b64encode(svg.encode()).decode()
        parts.append(
            f'<text x="20" y="{y + 18}" font-family="monospace" font-size="14" fill="#0f172a">{pathlib.Path(p).stem}</text>'
            f'<image x="20" y="{y + CAP}" width="{dw:.1f}" height="{dh:.1f}" href="data:image/svg+xml;base64,{b64}"/>'
            f'<line x1="0" y1="{y + CAP + dh + GAP/2:.1f}" x2="{W}" y2="{y + CAP + dh + GAP/2:.1f}" stroke="#e2e8f0"/>'
        )
        y += CAP + dh + GAP
    sheet = (f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" '
             f'width="{W}" height="{y:.0f}" viewBox="0 0 {W} {y:.0f}">'
             f'<rect width="{W}" height="{y:.0f}" fill="#ffffff"/>{"".join(parts)}</svg>')
    tmp = pathlib.Path("/tmp/_sheet.svg"); tmp.write_text(sheet)
    subprocess.run(["rsvg-convert", "-b", "white", str(tmp), "-o", out], check=True)
    print(out)

build(sys.argv[2:], sys.argv[1])
