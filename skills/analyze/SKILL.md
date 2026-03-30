---
name: analyze
description: >
  Prototyper Step 1 — Analyze source code or Stitch UI to map all screens,
  user flows, visual styles, icons, animations, and assets. Outputs a
  structured summary ready for Step 2 (propose).
argument-hint: "[source-path]"
allowed-tools:
  - "Read"
  - "Glob"
  - "Grep"
  - "Agent"
---

# Prototyper: Analyze

Map the product's structure and output a summary for the demo flow proposal.

## Instructions

Launch up to 3 Explore agents in parallel to scan the source at `$ARGUMENTS`
(default: current directory).

| What to find | Where to look |
|--------------|---------------|
| All screens/pages | Routes, components, templates |
| User flow | Navigation, state machines, wizards, modals |
| Visual style | CSS/Tailwind, brand colors, fonts, shadows, border-radius |
| Icons | Lucide / Heroicons / FA — note which library and which icons |
| Animations | Spinners, progress bars, skeletons, transitions |
| Assets | `public/`, `static/`, `img/`, `assets/` — list image files |
| Mock data | Seed scripts, fixtures, constants, API mocks |

Framework hints:
- **React/Next.js/Vue/Angular** → `app/`, `pages/`, `components/`, `src/`
- **Flask/Django/Rails** → `templates/`, `static/`, URL routes
- **Flutter/React Native** → `lib/screens/`, `lib/widgets/`
- **Stitch HTML/CSS** → all `.html`/`.css` exported files
- **Static HTML** → `.html` files and linked CSS/JS

## Output format

Present a structured summary:

```
Product: [Name]
Framework: [React/Next.js/Vue/etc.]

Screens found (N total):
  1. [Screen name] — [brief description] — [key source file]
  2. ...

User flow:
  [Screen A] → [action] → [Screen B] → ...

Visual style:
  Primary color: #xxxxxx  (from [file])
  Accent color:  #xxxxxx
  Font: [font family]
  Border-radius: [value]
  Shadows: [sm/md/lg]

Icons: [library name] — icons used: [list]

Animations: [list what's found — spinners, skeletons, etc.]

Assets:
  Products/items: [N images at path]
  Results/output: [N images at path, if any]
  Person/avatar:  [path, if any]

Mock data: [products/items list with names and prices, if found]
```

Then say: "Run `/prototyper:propose` to continue to Step 2."
