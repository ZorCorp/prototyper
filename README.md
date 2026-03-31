# prototyper — Claude Code Plugin

Convert any product's source code or Stitch UI designs into a **standalone interactive HTML demo** with auto-play, simulated cursor, and animations.

Includes a **built-in demo** for the **HKUST Souvenir Store Virtual Try-On Kiosk** — split-screen iPad + Phone, no analysis step needed.

---

## Table of Contents

1. [What It Does](#what-it-does)
2. [Install](#install)
3. [Quick Start](#quick-start)
4. [Try It Yourself: Hands-On Tutorial](#try-it-yourself-hands-on-tutorial)
5. [Tutorial: Any Project](#tutorial-any-project-your-own-code)
6. [Commands Reference](#commands-reference)
7. [Output Structure](#output-structure)
8. [Features](#features)
9. [Supported Frameworks](#supported-frameworks)

---

## What It Does

```
source code / Stitch UI
        ↓
   /prototyper:analyze    →  maps all screens, styles, assets
   /prototyper:propose    →  proposes demo flow, user tunes it
   /prototyper:generate   →  builds prototyper/ (HTML/CSS/JS)
   /prototyper:verify     →  syntax check + local preview
   /prototyper:deploy     →  git push → GitHub Pages URL
```

**Special built-in:**
```
   /prototyper:uststore   →  HKUST Store demo (pre-analyzed, skip to propose)
```

Run all steps at once: `/prototyper:prototyper`

---

## Install

### Option A — Claude Code Plugin Marketplace

```
/plugin marketplace add ZorCorp/zorskill
/plugin install prototyper
```

### Option B — npm (all ZorCorp skills)

Installs prototyper together with all other ZorCorp skills and auto-symlinks into every agent on your machine.

```bash
npm install -g @zorcorp/zorskills
```

Update:

```bash
npm update -g @zorcorp/zorskills
```

### Option C — Git (manual)

```bash
git clone https://github.com/ZorCorp/prototyper
cd prototyper
node scripts/setup.js
```

Or point Claude Code at the directory directly:

```bash
claude --plugin-dir ./prototyper
```

---


---

## Quick Start

Open Claude Code in your project directory and run:

```
/prototyper:prototyper .
```

Claude will analyze your project, propose a demo flow for your approval, generate the `prototyper/` directory, verify it works, and deploy to GitHub Pages.

---

## Try It Yourself: Hands-On Tutorial

This tutorial uses the **bundled example project** (`examples/uststore/`) so you can try Prototyper immediately after install — no extra repos needed.

### What you'll build

A split-screen interactive demo of the HKUST Souvenir Store Virtual Try-On Kiosk:
- **Left panel**: iPad kiosk (product grid → QR code → AI processing → result)
- **Right panel**: Phone (photo upload → progress bar → thank you)
- **Auto-play**: A simulated cursor clicks through the entire flow on loop

### Step 1 — Open the example project

If you installed via **npm** or **git clone**:
```bash
cd ~/.agents/skills/prototyper/examples/uststore
claude
```

If you cloned manually:
```bash
cd prototyper/examples/uststore
claude
```

### Step 2 — Ask Claude to make a demo (pick one)

You can use **slash commands** or **natural language** — both work:

**Option A: Slash command (fastest)**
```
/prototyper:uststore
```

**Option B: Natural language**
```
Make me an interactive demo of this project
```

**Option C: Natural language with details**
```
I want to create a clickable HTML demo of this virtual try-on kiosk
for an investor presentation. Show the iPad and phone side by side.
```

> **Tip:** You don't need to know the slash commands. Just describe what you want
> in plain English — Claude will figure out which Prototyper steps to run.

### Step 3 — Review the proposed flow

Claude will analyze the source code and present a numbered timeline like this:

```
Proposed demo flow — HKUST Virtual Try-On Kiosk:

 1. Loading skeleton — both panels shimmer
 2. iPad: Product grid appears — 5 items
 3. Cursor clicks "HKUST Hoodie" — product selected
 4. iPad: QR code page — "scan to upload" instruction
 5. Phone: Upload page appears
 6. Phone cursor taps "select photo"
 7. Phone: Upload progress 0% → 100%
 8. Phone: Thank-you screen
 9. iPad: AI processing animation
10. iPad: Result — original photo + try-on side by side
11. Fade back to product grid → loop
```

Claude will then ask if this looks right. **Here's how to respond:**

| What you want to do | What to say |
|---------------------|-------------|
| Accept as-is | `looks good` or `proceed` |
| Remove a step | `skip the upload progress bar, go straight to thank-you` |
| Add a step | `add a 2-second pause on the result screen before looping` |
| Change the starting product | `start with the windbreaker instead of the hoodie` |
| Change the audience | `this is for investors, make it look polished` |
| Change the layout | `use a single panel instead of split-screen` |
| Speed up the demo | `make the whole loop finish in 20 seconds` |

### Step 4 — Watch Claude generate

After you approve, Claude builds the demo automatically. You'll see it creating files:

```
prototyper/
├── index.html              ← open this in your browser
├── css/styles.css
├── js/
│   ├── data.js             ← product data
│   ├── icons.js            ← SVG icons
│   ├── screens.js          ← screen renderers
│   ├── autoplay.js         ← auto-play script
│   └── app.js              ← state machine
└── assets/products/        ← product images
```

This takes **2–5 minutes**. You don't need to do anything — just wait.

### Step 5 — Preview and fix

Claude will verify the output and start a local server:

```
Demo running at http://localhost:3333
```

Open the URL in your browser. If something looks wrong, **just describe it:**

```
the product images are broken
```
```
the spinner doesn't show up on the processing screen
```
```
the phone panel is too tall, it's overlapping the control bar
```

Claude will fix the issue and re-serve. Repeat until it looks right.

### Step 6 — Deploy (optional)

When you're happy with the demo:

```
deploy this to GitHub Pages
```

Or use the slash command:
```
/prototyper:deploy
```

Claude will push and give you the public URL:
```
https://<your-username>.github.io/uststore/prototyper/index.html
```

---

## Tutorial: Any Project (Your Own Code)

Use these same steps on **your own codebase** — React, Next.js, Vue, Flask, anything.

### Step 1 — Open your project

```bash
cd /path/to/your/project
claude
```

### Step 2 — Ask Claude to make a demo

**Option A: One command does everything**
```
/prototyper:prototyper .
```

**Option B: Natural language**
```
Make an interactive HTML demo of this app
```

**Option C: Step by step (more control)**

| Step | Slash command | Or say... |
|------|--------------|-----------|
| Analyze | `/prototyper:analyze .` | `analyze this project for a demo` |
| Propose | `/prototyper:propose` | `propose a demo flow` |
| Generate | `/prototyper:generate` | `generate the demo` |
| Verify | `/prototyper:verify` | `check if the demo works` |
| Deploy | `/prototyper:deploy` | `deploy to GitHub Pages` |

### Example prompts for customization

```
analyze this project but focus only on the dashboard and settings pages
```
```
make the demo split-screen — desktop on the left, mobile on the right
```
```
this is for a sales pitch, make the transitions snappy and add a loading animation
```
```
skip the login flow, start directly on the main page
```
```
use the real product images from public/images/
```

---

## Commands Reference

| Command | What it does |
|---------|-------------|
| `/prototyper:prototyper` | Full workflow — analyze → propose → generate → verify → deploy |
| `/prototyper:uststore` | HKUST Store demo (pre-analyzed, starts at propose) |
| `/prototyper:analyze` | Step 1 — map screens, styles, icons, assets from source code |
| `/prototyper:propose` | Step 2 — present numbered demo timeline for user approval |
| `/prototyper:generate` | Step 3 — build `prototyper/` (vanilla HTML/CSS/JS) |
| `/prototyper:verify` | Step 4 — syntax check all JS + serve locally at port 3333 |
| `/prototyper:deploy` | Step 5 — `git push` + output GitHub Pages URL |

### With arguments

```
/prototyper:prototyper ./my-app
/prototyper:analyze ./src
/prototyper:propose skip login, focus on dashboard
/prototyper:uststore investor demo — highlight the AI step
```

---

## Output Structure

```
prototyper/
├── index.html          ← open directly in browser (no server needed)
├── css/
│   └── styles.css      ← brand colors, layout, animations, controls
├── js/
│   ├── data.js         ← mock data (IIFE global)
│   ├── icons.js        ← inline SVG icons (IIFE global)
│   ├── screens.js      ← screen renderers — pure HTML string functions
│   ├── autoplay.js     ← auto-play engine + step script
│   └── app.js          ← state machine + event bindings
└── assets/             ← copied product/result images
```

---

## Features

- **Auto-play** on open — 36px simulated cursor, click ripples, floating annotations
- **Manual interaction** — pause auto-play and click through yourself
- **Speed control** — 0.5x / 1x / 2x
- **Split-screen** — dual-device layout for kiosk + mobile apps
- **Visual fidelity** — brand colors, icons, animations matched to source
- **`file://` compatible** — open `index.html` directly, no server required
- **Chinese UI** — uststore demo fully localized in Traditional Chinese
- **Pre-analyzed** — uststore skill skips the analysis step entirely

---

## Supported Frameworks

- React / Next.js / Vue / Angular
- Flask / Django / Rails
- Flutter / React Native
- Stitch UI (screenshots or exported HTML)
- Static HTML
- Any codebase with readable source files

---

## License

MIT — [github.com/ZorCorp/prototyper](https://github.com/ZorCorp/prototyper)
