# Visual Fidelity Checklist

The Prototyper demo must look like the real product, not a wireframe.
Check every item before showing to the user.

## Colors
- [ ] Brand primary color extracted exactly (hex match)
- [ ] Brand accent/secondary color correct
- [ ] Background colors match (page bg, card bg, sidebar bg)
- [ ] Text colors match hierarchy (headings, body, muted, links)
- [ ] Button colors match (primary, secondary, danger states)
- [ ] All colors defined as CSS custom properties in `:root {}`

## Typography
- [ ] Font family matches (or closest system font equivalent)
- [ ] Font weights correct (headings bold, body regular)
- [ ] Font sizes proportionally correct
- [ ] Line heights match

## Layout
- [ ] Grid columns match (2-col, 3-col, 4-col)
- [ ] Flex directions correct (row vs column)
- [ ] Spacing/gaps proportionally correct
- [ ] Max-width constraints match
- [ ] Responsive breakpoints handled

## Components
- [ ] Card border-radius matches (rounded-lg, rounded-2xl, etc.)
- [ ] Card box-shadow matches (sm, md, lg)
- [ ] Card padding matches
- [ ] Button border-radius correct
- [ ] Button padding and font-size correct
- [ ] Button hover states (color change, scale, shadow)
- [ ] Button active states (scale down)
- [ ] Input field styles match (bg, border, radius, padding)
- [ ] Navigation/header height and style match

## Icons
- [ ] Icon library identified (Lucide, Heroicons, FA, custom)
- [ ] All used icons extracted as inline SVG functions
- [ ] Icon sizes match source (16px, 20px, 24px)
- [ ] Icon colors correct (currentColor or explicit)

## Animations
- [ ] Spinner style matches (single ring, dual ring, dots)
- [ ] Spinner colors and speed match
- [ ] Progress bar style matches (height, color, radius)
- [ ] Skeleton shimmer matches (gradient direction, speed)
- [ ] Hover transitions match (duration, easing)
- [ ] Page transitions match (fade, slide, zoom)
- [ ] Success animations match (checkmark, confetti, ping)

## Images
- [ ] Product images are real (copied from source), not placeholders
- [ ] Result/output images included if available
- [ ] Person/avatar images included if available
- [ ] Logo references correct (local or external URL)
- [ ] Image aspect ratios preserved
- [ ] Image object-fit correct (contain vs cover)

## Overall
- [ ] Side-by-side comparison with source product shows visual match
- [ ] No grey placeholder boxes visible
- [ ] No broken image icons
- [ ] No unstyled text or default browser styles leaking through
