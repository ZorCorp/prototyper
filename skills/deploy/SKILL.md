---
name: deploy
description: >
  Prototyper Step 5 — Commit and push prototyper/ to GitHub, then output
  the GitHub Pages URL for sharing.
argument-hint: ""
allowed-tools:
  - "Bash"
---

# Prototyper: Deploy

Push the demo to GitHub and share the public URL.

## Step 5.1 — Commit & push

```bash
git add prototyper/
git commit -m "feat: add interactive product demo (Prototyper)"
git push
```

## Step 5.2 — Get the URL

```bash
GH_USER=$(gh api user -q '.login')
REPO=$(basename $(git rev-parse --show-toplevel))
echo "https://${GH_USER}.github.io/${REPO}/prototyper/index.html"
```

## Step 5.3 — Present to user

```
Demo deployed!

Local:   http://localhost:3333
Public:  https://<user>.github.io/<repo>/prototyper/index.html

Share the public URL — anyone can view the interactive demo.
Auto-plays on open; viewers can pause and click through manually.

Note: GitHub Pages takes 1–2 minutes to propagate on first deploy.
      Enable it at: repo Settings → Pages → Source: Deploy from branch → main → / (root)
```
