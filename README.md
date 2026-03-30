# Prototyper — Claude Code Plugin

Convert any product's source code or Stitch UI designs into a **standalone interactive HTML demo** with auto-play, simulated cursor, and animations. No build step, no dependencies — works with `file://` or GitHub Pages.

## What it does

```
source code / Stitch UI
        ↓
   /prototyper:analyze    →  maps all screens, styles, assets
   /prototyper:propose    →  proposes demo flow, user tunes it
   /prototyper:generate   →  builds prototyper/ (HTML/CSS/JS)
   /prototyper:verify     →  syntax check + local preview
   /prototyper:deploy     →  git push → GitHub Pages URL
```

Run all steps at once:
```
/prototyper:prototyper
```

Or run each step individually for more control.

---

## Install

**From GitHub:**
```bash
git clone https://github.com/your-username/prototyper-plugin
claude --plugin-dir ./prototyper-plugin
```

**As a standalone skill (no plugin):**
```bash
cp -r skills/prototyper ~/.claude/skills/prototyper
# then use: /prototyper
```

---

## Commands

| Command | What it does |
|---------|-------------|
| `/prototyper:prototyper` | Full workflow — analyze → propose → generate → verify → deploy |
| `/prototyper:analyze` | Step 1 — Map screens, styles, icons, assets from source code |
| `/prototyper:propose` | Step 2 — Present a numbered demo timeline for user approval |
| `/prototyper:generate` | Step 3 — Build `prototyper/` (vanilla HTML/CSS/JS) |
| `/prototyper:verify` | Step 4 — Syntax check all JS + serve locally at port 3333 |
| `/prototyper:deploy` | Step 5 — `git push` + output GitHub Pages URL |

---

## Sample Prompts

**Full workflow:**
```
/prototyper:prototyper .
```
```
Build a prototyper for this app
```
```
Create an interactive demo of this Next.js e-commerce store
```
```
Make a sales demo for this project — focus on the checkout flow
```

**Step by step:**
```
/prototyper:analyze ./my-app
```
```
/prototyper:propose skip login, focus on dashboard and reports
```
```
/prototyper:generate
```
```
/prototyper:verify
```
```
/prototyper:deploy
```

**From Stitch UI:**
```
/prototyper:prototyper https://stitch.claude.ai/projects/abc123
```
```
Turn these Stitch screenshots in ./designs/ into a clickable prototype
```

**With direction:**
```
Build a prototyper for investors — highlight the AI processing step with a 3s animation
```
```
Create a split-screen demo showing the iPad kiosk and mobile phone side by side
```
```
Make a demo, skip the login screen, loop back after checkout success
```

---

## Output

```
prototyper/
├── index.html          # Single entry point — open directly in browser
├── css/styles.css      # Brand colors, layout, animations, controls
├── js/
│   ├── data.js         # Mock data (IIFE global)
│   ├── icons.js        # Inline SVG icons (IIFE global)
│   ├── screens.js      # Screen renderers — pure HTML string functions
│   ├── autoplay.js     # Auto-play engine + step script
│   └── app.js          # State machine + event bindings
└── assets/             # Copied product images
```

---

## Features

- **Auto-play** on open — 36px simulated cursor, click ripples, floating annotations
- **Manual interaction** — pause auto-play and click through yourself
- **Speed control** — 0.5x / 1x / 2x
- **Split-screen** — iPad + Phone dual-device layout (for mobile + kiosk apps)
- **Visual fidelity** — brand colors, icons, animations matched to source product
- **`file://` compatible** — open `index.html` directly, no server required

---

## Supports

- React / Next.js / Vue / Angular
- Flask / Django / Rails
- Flutter / React Native
- Stitch UI (screenshots or exported HTML)
- Static HTML

---

## License

MIT
