---
name: lean-ui
description: Build or refine frontend interactions with accessible controls, complete async states, responsive behavior, and practical performance checks. Use for UI implementation or quality review, especially React and Next.js; excludes branding, visual direction, and backend work.
---

# lean-ui

Ship the smallest change that makes the requested interaction work reliably. Keep the existing stack, styling, and component conventions. Reuse suitable primitives already present; do not introduce a UI library for a small fix.

## Working loop

1. Identify the user action and its observable outcome. Inspect nearby components and existing checks before editing.
2. Cover relevant states: idle, pending, success, empty, and failure. Preserve entered data on failure, provide a recovery action, and prevent duplicate mutations. Ignore obsolete async results; clean up subscriptions and timers.
3. Use native controls and visible associated labels. Support keyboard activation, visible focus, and logical tab order. Connect field errors to inputs; update a mounted status region for async outcomes without moving focus. For modal overlays, set initial focus, contain it, support dismissal, and restore focus on close.
4. Keep content usable at 320 CSS pixels, zoom, and with long text. Disable nonessential motion under `prefers-reduced-motion`. Do not make hover, animation, or color the only way to understand or operate the UI.
5. Keep state close to its consumers, derive cheap values during render, and use persistent data IDs for changing lists. Avoid redundant effects and requests; keep effect dependencies honest. Add memoization, virtualization, or code splitting when a concrete cost justifies it.
6. Verify the changed flow: keyboard, pending/failure/retry, narrow viewport, and relevant automated checks. Report what ran and any remaining gaps; do not claim accessibility compliance from a lint or automated scan alone.

Apply only checks relevant to the change. Do not expand a small task into a full-site audit, redesign, new abstraction, or exhaustive test suite.

## Read only when needed

| Task | Reference |
| --- | --- |
| Requests, forms, race conditions, recovery | [Interaction states](references/interactions.md) |
| Labels, validation, keyboard, overlays, focus | [Accessibility](references/accessibility.md) |
| React rendering, lists, Next.js boundaries, delivery cost | [Performance](references/performance.md) |
| Reflow, touch, zoom, motion | [Responsive behavior](references/responsive-motion.md) |

Read only the reference needed for the current uncertainty. Keep these details out of routine responses. Use [the example comparison](examples/README.md) when a concrete implementation helps; use [the evaluation protocol](evals/README.md) when measuring the skill itself.

## Completion evidence

Briefly state the behavior improved, the checks performed, and any unverified behavior. Prefer observable evidence (for example, a failed request retains the query and a retry succeeds) over a generic quality checklist. Never replace working product behavior with a static mock to satisfy a check.
