# presentation-craft

Agent skill for building slide decks that do not look like a template and do not smell
like AI slop. Research-driven: the agent searches for references, derives a design system
from the topic, builds three probe slides, gets the direction approved, and only then
assembles the full deck.

## What it solves

Most generated decks share the same tells: rounded cards with icons, rows of equal stat
tiles, an accent bar above every headline, cream backgrounds, one layout repeated on every
slide. This skill replaces the default with a process:

1. **Brief** — audience, venue, duration, constraints.
2. **Research** — 2–4 directions with palette roles, type pairings, grid and one motif,
   each tied to the subject and backed by references.
3. **Probes** — three slides per direction (cover, dense content, number/quote), rendered
   as PNG and shown for a decision.
4. **Build** — design system block, 10–16 slides, 5+ page archetypes, one focal element.
5. **QA** — every slide rendered and inspected; content, visual and technical passes.

## Install

OpenCode / Claude Code:

```bash
git clone https://github.com/RacFor4k/presentation-craft.git \
  ~/.config/opencode/skills/presentation-craft
```

Claude Code uses `~/.claude/skills/` instead; the layout is identical.

## Use

Ask for a deck, a talk, a defence, a pitch. The skill triggers on presentation requests
and on complaints that a deck looks generic.

## Structure

```
SKILL.md                       workflow, smell test, pitfalls
references/
  research-playbook.md         what and where to search, extraction worksheet
  style-vocabulary.md          names for design families (labels, not presets)
  patterns-catalog.md          slide patterns worth borrowing and ones to avoid
  anti-ai-checklist.md         the tells and their countermeasures
  deck-qa.md                   three QA passes and known defects
  pptx-toolcraft.md            pptxgenjs + rendering recipes
scripts/
  render_windows.ps1           .pptx -> PNG via PowerPoint COM
  render_linux.sh              .pptx -> PNG via LibreOffice + Poppler
```

## Principles

- No hardcoded palettes: colour and type come from research, not from this repo.
- One accent, one motif, many page archetypes.
- If removing an element does not hurt the slide, it was decoration.
- If the design works for any topic, it is not designed for this one.

## License

MIT
