---
name: verify
description: >
  Prototyper Step 4 — Verify the generated prototyper/ demo runs without
  errors. Runs JS syntax checks on all files and serves locally for review.
argument-hint: ""
allowed-tools:
  - "Read"
  - "Bash"
---

# Prototyper: Verify

Check the `prototyper/` demo for errors and serve it locally.

## Step 4.1 — Syntax check

Run on every JS file. Fix any errors immediately before continuing.

```bash
for f in prototyper/js/*.js; do
  node -e "new Function(require('fs').readFileSync('$f','utf8'))" && echo "OK: $f" || echo "ERROR: $f"
done
```

Common issues to fix:
- IIFE var not in `return {}` → `undefined` in rendered HTML
- Missing closing `})()` on IIFE
- `var` used before `DemoData`/`Icons`/`Screens` declared (wrong load order)
- Unclosed string or template literal

## Step 4.2 — Serve locally

```bash
npx -y serve prototyper -p 3333 -s &
```

Tell the user:
> "Demo running at **http://localhost:3333**
> Check that auto-play runs through all steps.
> Let me know if anything needs fixing."

## Step 4.3 — Fix loop

If the user reports issues: fix → re-run syntax check → confirm.
Repeat until clean playthrough.

Once confirmed working, say:
"Verified. Run `/prototyper:deploy` to push to GitHub Pages."
