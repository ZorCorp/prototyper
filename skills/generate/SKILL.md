---
name: generate
description: >
  Prototyper Step 3 — Generate the full prototyper/ output (vanilla HTML/CSS/JS)
  based on the approved demo flow. Produces a self-contained interactive demo
  with auto-play cursor, animations, and manual click interaction.
argument-hint: "[approved-flow-description]"
allowed-tools:
  - "Read"
  - "Write"
  - "Edit"
  - "Glob"
  - "Grep"
  - "Bash"
  - "Agent"
---

# Prototyper: Generate

Build the `prototyper/` output from the approved demo flow.
Read `../prototyper/references/patterns.md` for full code templates before starting.

## Output structure

```
prototyper/
├── index.html              # Single entry point
├── css/
│   └── styles.css          # Brand colors, layout, animations, controls
├── js/
│   ├── data.js             # Mock data (IIFE global)
│   ├── icons.js            # Inline SVG icon functions (IIFE global)
│   ├── screens.js          # Screen renderers — pure functions (IIFE global)
│   ├── autoplay.js         # Auto-play engine + step script (IIFE global)
│   └── app.js              # State machine, events, init
└── assets/
    ├── products/           # Product images (copied from source)
    ├── results/            # Output/result images (if available)
    └── [other images]
```

## Technical constraints (non-negotiable for file:// compatibility)

- **Vanilla JS** — IIFEs with global vars. No ES modules, no npm.
- **No CDN** — inline SVGs, system fonts. Zero external requests.
- **Self-contained** — copy all images into `prototyper/assets/`.
- **Load order** — `data.js` → `icons.js` → `screens.js` → `autoplay.js` → `app.js`
- **IIFE exports** — every var used by another module MUST be in `return {}`

## Build sequence

1. Create dirs, copy images to `assets/`
2. `data.js` — mock data matching the approved flow
3. `icons.js` — extract SVG paths from the source product's icon library
4. `styles.css` — brand colors from source, all layouts, animations
5. `screens.js` — one renderer per screen, pure functions returning HTML strings
6. `index.html` — layout + script tags in load order + control bar + 36px cursor SVG
7. `autoplay.js` — step array matching approved flow exactly
8. `app.js` — state machine, event bindings, `Autoplay.start()` call

## Interaction design

Support BOTH auto-play AND manual interaction:

- **Auto-play**: 36px cursor SVG, click ripples, floating annotations,
  speed control (0.5x/1x/2x), pause/resume/skip/reset
- **Manual**: all elements clickable; `Autoplay.pause()` on any manual click;
  "Simulate X →" buttons for backend-dependent actions
- **Control bar**: `⏸ Pause │ Step N/N │ 1x ▾ │ ⏭ Skip │ ↻ Reset`

## Visual fidelity

> **⚠️ CRITICAL — 100% source-based design**
> Every visual decision MUST be extracted directly from the source code or
> website. Never invent or assume colors, fonts, layouts, spacing, icons, or
> component styles. If it is not in the source, ask the user before proceeding.
> The finished demo must be indistinguishable from the real product at a glance.

Read `../prototyper/resources/visual-checklist.md`.
The demo must look like the real product — brand colors, border-radius, shadows,
icons, and animations must all be extracted from the source exactly.

## After generation

Say: "Done. Run `/prototyper:verify` to check for errors."
