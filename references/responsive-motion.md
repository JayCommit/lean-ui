# Responsive behavior and motion

Let content determine layout. Prefer flexible grids, wrapping controls, and bounded readable widths over fixed viewport assumptions. Give shrinking grid/flex children `min-width: 0` when needed. Wrap long user content without clipping essential information. Restrict horizontal scrolling to genuinely two-dimensional content such as a wide table, with a usable scroll affordance.

Check at 320 CSS pixels wide, at 200% zoom, and with long labels/content. Check reflow at an equivalent 320 CSS pixel viewport (often a 1280px desktop viewport at 400% zoom). Controls, errors, and actions must remain reachable. Do not disable browser zoom. Keep DOM order meaningful when layout changes; avoid CSS reordering that contradicts keyboard order.

Hover can enhance an interaction but must not be its sole entry point. Offer equivalent focus and touch behavior. Keep touch targets comfortably sized; WCAG 2.2 target-size minimum is 24 by 24 CSS pixels subject to exceptions, not a universal mandate to shrink every target to 24px. Prefer larger controls where practical.

Use motion to clarify change without delaying action. Under `prefers-reduced-motion: reduce`, remove nonessential transforms, parallax, looping effects, and smooth scrolling. Provide a static text equivalent for animated progress. Scope overrides to the effects you own; avoid universal duration hacks that break transition-dependent behavior. Preserve essential feedback when animation is removed.

Reserve space for async content where practical, but do not hide errors in fixed-height clipped containers. Ensure sticky/fixed UI does not cover focused controls, including with a virtual keyboard open.

Sources: W3C [reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html), [target size](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html), and [animation from interactions](https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html).
