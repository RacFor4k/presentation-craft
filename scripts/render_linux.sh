#!/usr/bin/env bash
# Render a .pptx to PNG slides with LibreOffice + Poppler.
# Fidelity caveat: LibreOffice substitutes fonts and cannot verify PowerPoint Morph.
# Use PowerPoint on Windows for final typography and motion QA.
# Usage: bash render_linux.sh deck.pptx slides

set -euo pipefail

PPTX="${1:?usage: render_linux.sh deck.pptx [outdir]}"
OUT="${2:-slides}"

mkdir -p "$OUT"
rm -f "$OUT"/*.png "$OUT"/*.pdf

soffice --headless --convert-to pdf --outdir "$OUT" "$PPTX" >/dev/null
PDF="$OUT/$(basename "${PPTX%.*}").pdf"

pdftoppm -png -r 150 "$PDF" "$OUT/slide"

i=0
for f in $(ls "$OUT"/slide-*.png | sort); do
  i=$((i + 1))
  mv "$f" "$OUT/$(printf 's-%02d.png' "$i")"
done

echo "rendered $i slides into $OUT"
