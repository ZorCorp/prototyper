---
name: prototyper
description: >
  Converts any product's source code or Stitch UI designs into a standalone
  interactive HTML demo with auto-play, simulated cursor, and animations.
  Includes a built-in HKUST Souvenir Store virtual try-on kiosk demo.
  Works with React, Next.js, Vue, Flask, Rails, Flutter, static HTML, or
  anything with readable source files.
license: MIT
allowed-tools:
  - Bash(*)
  - Read(*)
  - Write(*)
  - Edit(*)
  - Glob(*)
  - Grep(*)
  - Agent(*)
metadata:
  version: "1.1.0"
  repository: https://github.com/ZorCorp/prototyper
  homepage: https://github.com/ZorCorp/prototyper
---

# Prototyper

Convert product source code or Stitch UI designs into a standalone interactive HTML demo.

## Workflow

```
source code / Stitch UI
        ↓
   /prototyper:analyze    →  maps all screens, styles, assets
   /prototyper:propose    →  proposes demo flow, user tunes it
   /prototyper:generate   →  builds prototyper/ (HTML/CSS/JS)
   /prototyper:verify     →  syntax check + local preview
   /prototyper:deploy     →  git push → GitHub Pages URL
```

Run all steps at once: `/prototyper:prototyper`

Special built-in: `/prototyper:uststore` — HKUST Store demo (pre-analyzed, skip to propose)

## Commands

| Command | What it does |
|---------|-------------|
| `/prototyper:prototyper` | Full workflow — analyze → propose → generate → verify → deploy |
| `/prototyper:uststore` | HKUST Store demo (pre-analyzed, starts at propose) |
| `/prototyper:analyze` | Step 1 — map screens, styles, icons, assets from source code |
| `/prototyper:propose` | Step 2 — present numbered demo timeline for user approval |
| `/prototyper:generate` | Step 3 — build `prototyper/` (vanilla HTML/CSS/JS) |
| `/prototyper:verify` | Step 4 — syntax check all JS + serve locally at port 3333 |
| `/prototyper:deploy` | Step 5 — `git push` + output GitHub Pages URL |

## Output

```
prototyper/
├── index.html          ← open directly in browser (no server needed)
├── css/styles.css
├── js/
│   ├── data.js
│   ├── icons.js
│   ├── screens.js
│   ├── autoplay.js
│   └── app.js
└── assets/
```

## Features

- Auto-play on open — 36px simulated cursor, click ripples, floating annotations
- Manual interaction — pause auto-play and click through yourself
- Speed control — 0.5x / 1x / 2x
- Split-screen — dual-device layout for kiosk + mobile apps
- `file://` compatible — open `index.html` directly, no server required
- Supports any framework with readable source files
