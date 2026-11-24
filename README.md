# presentation-craft

Agent skill for building slide decks that do not look templated, poster-like or
AI-generated. Version 2.0 is material-first: photographs, artifacts, diagrams and
data carry the deck; typography and motion stay quiet and explain the relationships.

## What changed in 2.0

- **Material audit gate.** No palette, type or probe before `notes/material-audit.md`
  exists: sources, rights, resolution, crop and role for 5–10 real assets.
- **New documentary system.** `references/cinematic-documentary.md` records the
  calibrated black/white/signal-orange system, type scale and eleven-slide rhythm
  that produced a real deck from NASA imagery and a 1687 Principia page.
- **New material sourcing guide.** `references/material-sourcing.md` covers the NASA
  Images API, Internet Archive page scans, rights, resolution, circular planet
  cutouts and credits.
- **Motion is now first-class.** `references/morph-choreography.md` explains what
  PowerPoint Morph matches, why unshared slides need a fade, how to avoid white
  flashes and doubled titles, and how to verify transitions from an exported video.
- **Reusable PowerPoint toolkit.** `scripts/pptx_kit.js`, `add_morph.py`,
  `render_windows.ps1`, `render_video.ps1`, `export_pdf.ps1` and `prepare_image.py`.
- **QA now includes motion and credits.** `references/deck-qa.md` has four passes:
  content, visual, motion, technical.

## What it solves

Most generated decks share the same tells: rounded cards with icons, rows of equal
stat tiles, an accent bar above every headline, cream backgrounds, one layout
repeated on every slide, or the opposite failure — a giant word with decorative
orbits and no real content. This skill replaces both with a process:

1. **Brief** — audience, venue, duration, constraints, available material.
2. **Material audit** — real assets, rights, resolution, role. This is a gate.
3. **Research** — 2–3 directions with palette roles, type pairings, grid, motif,
   a specific material list and a motion idea.
4. **Probes** — three slides per direction built from the real material, rendered
   in PowerPoint and shown with a motion sample when relevant.
5. **Build** — 10–14 slides, 5+ archetypes, one focal element, speaker notes.
6. **Motion** — Morph only for objects that genuinely persist; fade for every other cut.
7. **QA** — every slide rendered and inspected; motion verified from video.
8. **Delivery** — pptx, PDF backup, MP4 preview, contact sheet, README with credits.

## Install

OpenCode / Claude Code:

```bash
git clone https://github.com/RacFor4k/presentation-craft.git \
  ~/.config/opencode/skills/presentation-craft
```

Claude Code uses `~/.claude/skills/` instead; the layout is identical.

## Use

Ask for a deck, a talk, a defence, a pitch, or say that a deck looks generic,
poster-like or AI-generated. The skill triggers on presentation requests and on
that complaint.

## Structure

```
SKILL.md                         workflow, gates, smell test, pitfalls
references/
  research-playbook.md           how to find a design system, not pictures
  material-sourcing.md           NASA, Internet Archive, rights, crops, credits
  cinematic-documentary.md       calibrated documentary system and slide rhythm
  morph-choreography.md          PowerPoint Morph, !! names, fade, video QA
  pptx-toolcraft.md              pptxgenjs, PowerPoint COM, render, PDF, video
  anti-ai-checklist.md           tells and countermeasures
  deck-qa.md                     content, visual, motion, technical
  patterns-catalog.md            slide archetypes worth borrowing
  style-vocabulary.md            names for design families (labels, not presets)
scripts/
  pptx_kit.js                    generic pptxgenjs helpers
  add_morph.py                   Morph + fade transitions in slide XML
  render_windows.ps1             .pptx -> PNG through PowerPoint COM
  render_video.ps1               .pptx -> MP4 through PowerPoint COM
  export_pdf.ps1                 .pptx -> PDF through PowerPoint COM
  prepare_image.py               16:9 crop, circular cutouts, resize
  render_linux.sh                LibreOffice fallback (fidelity caveat)
CHANGELOG.md
```

## Principles

- Real material first; type and motion only help it speak.
- No hardcoded palettes: colour and type come from the material and the venue.
- One accent, one motif, many page archetypes.
- If removing an element does not hurt the slide, it was decoration.
- If the design works for any topic, it is not designed for this one.
- Motion must explain a relationship; otherwise cut or fade.

## License

MIT
