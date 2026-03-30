---
name: prototyper
description: >
  Converts any product's source code or Stitch UI designs into a standalone
  interactive HTML demo. Generates `prototyper/` with vanilla HTML/CSS/JS
  featuring auto-play with simulated cursor, animations, and manual click
  interaction. Deploys to GitHub Pages for sharing.

  Use this skill whenever the user wants to: create a product demo, build an
  interactive prototype, make a clickable walkthrough, generate a demo page,
  showcase a product flow, convert an app into a static demo, create a sales
  demo, build a Prototyper, or turn Stitch designs into a demo. Works with
  ANY framework — React, Vue, Next.js, Flask, Rails, Flutter, static HTML,
  Stitch UI, or anything else.
argument-hint: "[source-path-or-stitch-url]"
allowed-tools:
  - "Read"
  - "Write"
  - "Edit"
  - "Glob"
  - "Grep"
  - "Bash"
  - "Agent"
---

# Prototyper

Build an interactive product demo from source code or Stitch UI designs.
Output: self-contained `prototyper/` (vanilla HTML/CSS/JS) — no build step,
no dependencies. Deployed to GitHub Pages for instant sharing.

```
┌─────────┐    ┌──────────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Step 1  │ →  │   Step 2     │ →  │  Step 3  │ →  │  Step 4  │ →  │  Step 5  │
│ Analyze  │    │ Propose flow │    │ Generate │    │ Verify   │    │ Deploy   │
│ source   │    │ user tunes   │    │ code     │    │ no errors│    │ & share  │
└─────────┘    └──────────────┘    └──────────┘    └──────────┘    └──────────┘
     ↑                                                                    │
     │  If Stitch UI: convert to                                          │
     │  code first (see §0)                                    gh-pages URL
```

Reference: https://github.com/mcailab/Prototyper

---

## Step 0: Stitch UI Pre-Processing (conditional)

> Skip this step if the user provides source code directly.

If the user provides **Stitch UI** (screenshots, exported HTML, Stitch project
URL, or `.stitch/` directory), convert it to structured code first:

1. **Stitch screenshots/images** → Read each image. Extract all screens, UI
   elements, colors, typography, layout structure. Describe each screen in
   detail as a spec.

2. **Stitch exported HTML/CSS** → Read the exported files. These are the
   "source code" — proceed to Step 1 using them directly. The HTML/CSS IS
   the source.

3. **Stitch project URL** → If the `stitch-design` skill is available, use it
   to fetch the project. Otherwise, ask the user to export the HTML/CSS and
   provide the files.

After conversion, treat the output as source code and continue to Step 1.

---

## Step 1: Analyze the Source

Launch up to 3 Explore agents in parallel to map the product:

| What to find | Where to look |
|--------------|---------------|
| All screens/pages | Routes, components, templates, Stitch screens |
| User flow | Navigation, state machines, wizards |
| Visual style | CSS/Tailwind, brand colors, fonts, shadows, radius |
| Icons | Lucide / Heroicons / FA — note which library |
| Animations | Spinners, progress bars, skeletons, transitions |
| Assets | `public/`, `static/`, `img/`, `assets/`, seeds |
| Mock data | Seed scripts, fixtures, API mocks |

Adapt to the framework:
- **React/Next.js/Vue/Angular** → components, route config, CSS/Tailwind
- **Flask/Django/Rails** → templates, static files, URL routes
- **Flutter/React Native** → screen widgets, navigation stack
- **Stitch HTML/CSS** → all exported .html/.css files
- **Static HTML** → .html files and linked CSS/JS

---

## Step 2: Propose Demo Flow (User Tunes It)

Present a **numbered demo timeline** to the user using `AskUserQuestion`.
This is the critical step — the user must approve the flow before generation.

### Format

```
Proposed demo flow for [Product Name]:

1. ⏳ Loading skeleton (1.5s)
2. 📱 Product grid appears — 5 items displayed
3. 👆 Cursor clicks [Gold Hoodie] → detail page
4. 🛒 User adds to cart → cart slides in
5. 💳 Checkout → payment form (PayMe selected)
6. ⏳ Payment processing animation (3s)
7. ✅ Success screen with receipt
8. 🔄 Return to home → loop

Estimated duration: ~30s at 1x speed
Layout: single-screen / split-screen (iPad + Phone)
```

### Questions to ask (2-4, pick most relevant)

1. **Flow** — "Does this flow look right? Steps to add/remove/reorder?"
2. **Images** — "Found images in [path]. Use them? Or have others?"
3. **Layout** — Single-screen or split-screen? (recommend based on product)
4. **Audience** — "Who watches this? (sales demo / investor / internal)"

### User tuning

The user may adjust: "skip checkout", "add upload step", "make step 3 longer",
"use images from /img/". Revise and re-confirm if changes are significant.

---

## Step 3: Generate the Prototyper

### Output structure

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

### Technical constraints

Non-negotiable for `file://` compatibility:

- **Vanilla JS** — IIFEs with global vars. No ES modules, no npm.
- **No CDN** — inline SVGs, system fonts. Zero external requests (except
  logos the product already loads externally).
- **Self-contained** — copy all images into `prototyper/assets/`.
- **Load order** — `data.js` → `icons.js` → `screens.js` → `autoplay.js` → `app.js`

### Architecture

Read `references/patterns.md` for full code templates. Key patterns:

- **Screen renderers** (`screens.js`) — pure functions returning HTML strings
- **State machine** (`app.js`) — switch on screen name, innerHTML swap, rebind
- **Auto-play** (`autoplay.js`) — `[{ label, run(done) }]` step array with cursor
- **CSS vars** — extract brand colors into `:root { --brand-primary: #xxx; }`

### Visual fidelity

Read `resources/visual-checklist.md`. The demo must look like the real product,
not a wireframe. Brand colors, border-radius, shadows, icons, animations —
all must match the source.

### Interaction design

Support BOTH auto-play AND manual interaction:

- **Auto-play**: 36px cursor SVG, click ripples, floating annotations,
  speed control (0.5x/1x/2x), pause/resume/skip/reset
- **Manual**: all elements clickable, "Simulate X →" buttons for backend
  actions, navigation works (back/home buttons)
- **Control bar**: `⏸ Pause │ Step 3/15 │ 1x ▾ │ ⏭ Skip │ ↻ Reset`

### Build sequence

1. Create dirs, copy images to `assets/`
2. `data.js` → `icons.js` → `styles.css` → `screens.js`
3. `index.html` (layout + script tags + control bar + cursor SVG)
4. `app.js` → `autoplay.js`

---

## Step 4: Verify (No Errors)

### 4.1 Syntax check

Run on every JS file — fix any errors immediately:
```bash
node -e "new Function(require('fs').readFileSync('FILE','utf8'))"
```

### 4.2 Serve locally

```bash
npx -y serve prototyper -p 3333 -s &
```

Tell user: "Demo running at http://localhost:3333 — check auto-play runs
through. Let me know if anything needs fixing."

### 4.3 Fix loop

If user reports issues → fix → re-verify. Repeat until clean playthrough.

---

## Step 5: Deploy to GitHub Pages

Once the user confirms the demo works:

### 5.1 Commit & push

```bash
git add prototyper/
git commit -m "feat: add interactive product demo (Prototyper)"
git push
```

### 5.2 Determine the URL

```bash
GH_USER=$(gh api user -q '.login')
REPO=$(basename $(git rev-parse --show-toplevel))
echo "https://${GH_USER}.github.io/${REPO}/prototyper/index.html"
```

### 5.3 Present to user

```
Demo deployed!

🖥  Local:   http://localhost:3333
🌐 Public:  https://<user>.github.io/<repo>/prototyper/index.html

Share the public URL — anyone can view the interactive demo.
Auto-plays on open; viewers can pause and click through manually.

Note: GitHub Pages may take 1-2 minutes to propagate on first deploy.
```

---

## Common Pitfalls

| Issue | Cause | Fix |
|-------|-------|-----|
| `undefined` in rendered HTML | IIFE var not exported in `return {}` | Double-check all exports |
| Phone header fills entire screen | `flex: 1` on header element | Use `.mobile-screen-wrap` with `flex-shrink: 0` on header |
| Progress bar ignores pause | `requestAnimationFrame` loop missing `paused` check | Add `if (paused) { raf(tick); return; }` |
| Broken images | Path relative to wrong root | Always relative to `index.html`, copy to `assets/` |
| Cursor targets missing | Elements not in DOM yet | Use `data-*` attrs, query after `innerHTML` swap |
| GitHub Pages 404 | `prototyper` starts with dot | May need `docs/prototyper/` or adjust path — check repo settings |
