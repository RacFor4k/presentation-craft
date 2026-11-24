# Changelog

## 2.0.1 — 2026-11-24

- Fast motion defaults: fade 0.1 s, Morph 0.5 s only where it explains a
  relationship; otherwise fade.
- `add_morph.py` now defaults to `--dur 500 --fade-dur 100` and supports an
  explicit fade duration.
- Updated SKILL.md, morph choreography, toolcraft and QA duration rules.

## 2.0.0 — 2026-11-24

- Rewritten as a material-first workflow: `notes/material-audit.md` is now a gate
  before any style, palette or probe.
- Added `references/material-sourcing.md` (NASA Images API, Internet Archive,
  rights, resolution, crops, circular planet cutouts, credits).
- Added `references/cinematic-documentary.md`: the calibrated black/white/signal
  system, type scale, composition recipes and eleven-slide rhythm used for the
  «Тяготение» deck.
- Added `references/morph-choreography.md`: PowerPoint Morph matching, `!!` names,
  p159 XML, the black-gap failure, fade rule, duration, video verification.
- Added a reusable toolkit: `scripts/pptx_kit.js`, `add_morph.py`,
  `render_windows.ps1`, `render_video.ps1`, `export_pdf.ps1`, `prepare_image.py`.
- Expanded QA to four passes: content, visual, motion, technical.
- Updated the anti-AI checklist with poster, fake-material, full-bleed text and
  Morph-everywhere failures.
- Rewrote the patterns catalog around documentary archetypes: plate, artifact,
  object diagram, formula plate, data table, photo essay, bookend.
- Replaced the default Arial Black + Georgia advice with the calibrated
  Bahnschrift + Segoe UI + Cambria + Consolas stack and a font-verification rule.
- Calibrated on an 11-slide Newton deck using NASA/ESA photography and a 1687
  Principia title page.

## 1.0.0 — 2026-11-17

- Initial skill: research, three probes, build and QA.
