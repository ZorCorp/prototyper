---
name: propose
description: >
  Prototyper Step 2 — Propose a numbered demo flow timeline based on the
  analyzed product structure. Ask the user to review and tune it before
  generation begins.
argument-hint: "[product-name-or-notes]"
allowed-tools:
  - "Read"
  - "Glob"
  - "Grep"
  - "Agent"
---

# Prototyper: Propose

Present a demo flow for the user to review and tune. Do not generate any code yet.

## Instructions

If `/prototyper:analyze` was already run, use its output.
Otherwise, do a quick scan of the current directory to identify the main screens
and user flow.

### Present the proposed flow

Use `AskUserQuestion` to show the timeline and ask for feedback:

```
Proposed demo flow for [Product Name]:

1. ⏳ [Loading skeleton — Ns]
2. 📱 [First screen — brief description]
3. 👆 Cursor clicks [element] → [next screen]
4. ...
N. 🔄 Return to home → loop

Estimated duration: ~Xs at 1x speed
Layout: single-screen / split-screen ([Device A] + [Device B])
```

### Questions to ask (pick 2–4 most relevant)

1. **Flow** — "Does this flow look right? Steps to add, remove, or reorder?"
2. **Images** — "Found [N] images in [path]. Use them? Or do you have others?"
3. **Layout** — "Single-screen or split-screen? I'd recommend [X] because [reason]."
4. **Audience** — "Who is this demo for? (sales / investor / internal / conference)"
5. **Focus** — "Any screen you want to highlight or skip?"

### After user responds

Revise the flow if needed. Re-confirm with `AskUserQuestion` if changes are significant.

Once approved, say:
"Flow confirmed. Run `/prototyper:generate` to build the demo."
