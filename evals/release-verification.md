# Release verification — 6 November 2026

## Audit and changes

Found: an outdated/vague Codex install location, missing license and explicit limitations, a packaging check that rejected CRLF frontmatter, and no recorded install/browser/pilot evidence. Existing documentation did not claim measured improvements or WCAG compliance.

Added MIT licensing, exact whole-folder install/check commands, limitations, and this record. Normalized line endings in the checker; excluded local verification artifacts. Tightened three core rules around mounted status regions, modal focus, narrow layout, stable keys, and effect dependencies. Fixed the example's singular result wording. The core is 443 whitespace-delimited words (including frontmatter), below the existing 600-word budget; word/byte counts are not token measurements. No new shipped components, instructional references, or dependencies.

## Installation and automated checks

Environment: Windows, Node 26.12.1, npm 11.20.0, Codex CLI 0.166.0-alpha.6; Chromium 158.0.8127.18 through Playwright.

- Copied release files without dependencies/build outputs into a fresh project's `.agents/skills/lean-ui`, using the documented PowerShell copy pattern. No parent-repository imports or setup needed.
- Codex discovered the copied skill and explicitly invoked `$lean-ui`. A heading-only smoke task read `SKILL.md` and no references. Three search generations read only `references/interactions.md`; none read the worked example, scoring rubric, or other references. This verifies observed routing, not a guarantee about future agents.
- From the clean installation: local Markdown-target checks, `npm ci`, seven example tests, and TypeScript/production build passed. The checker also passed with CRLF frontmatter. External links and Markdown anchors are not validated by that script.
- Ran the built comparison in Chromium. Automated keyboard Enter submission, pending feedback, success, empty, failure/correction, focus preservation, rapid request replacement, 320px reflow with long text, and emulated reduced motion passed for the lean version.
- The baseline did not submit with Enter, had no native action button, and silently rendered failure as an empty list. These are real behavioral differences in the teaching example, not measured differences in typical agent output.
- A scoped axe WCAG A/AA scan found zero violations in **both** sections. It did not detect the baseline's missing keyboard interaction. No compliance conclusion follows.

## Agent-output pilot

One task from the protocol, three runs per condition. Prompt: build a React topic search form using `search(query, signal)`, export `SearchForm` with a `search` prop, edit only that component, add no dependencies. Both conditions received the same local fixture and component-only constraint. Only the skill condition added `Use $lean-ui for this task.`

Requested model/settings: `gpt-6.1-sol`, medium reasoning, default output budget, user config/rules and bundled skills disabled, fresh Git workspace and ephemeral context per run. No generated code was corrected before scoring. Forty-two temporary jsdom assertions passed across the six outputs; real-browser Enter submission and focus checks passed for each. Source inspection confirmed stable `item.id` keys.

| Search rubric check | Without (runs 1, 4, 5) | With (runs 2, 3, 6) |
| --- | --- | --- |
| Visible associated label | 3/3 | 3/3 |
| Keyboard submit | 3/3 | 3/3 |
| Pending feedback | 3/3 | 3/3 |
| Distinct empty/error | 3/3 | 3/3 |
| Retained query and recovery | 3/3 | 3/3 |
| Latest query wins: late success and rejection | 3/3 | 3/3 |
| Stable result IDs | 3/3 | 3/3 |
| No focus jump on result | 3/3 | 3/3 |

All scored checks passed in both conditions; no untested rubric checks. Skill outputs consistently added actionable recovery text and wrapping styles. A supplemental 320px long-query check found overflow in baseline run 1; the other five outputs passed. This was outside the search rubric and is not included in its score. No runtime performance gain was measured.

| Run | Condition | Input tokens | Cached subset | Output tokens |
| --- | --- | ---: | ---: | ---: |
| 1 | Without | 58,788 | 54,528 | 1,603 |
| 2 | With | 84,859 | 72,832 | 2,883 |
| 3 | With | 86,625 | 77,312 | 2,002 |
| 4 | Without | 59,636 | 52,992 | 1,468 |
| 5 | Without | 59,702 | 52,736 | 1,397 |
| 6 | With | 85,180 | 76,160 | 2,145 |

CLI-reported median input + output was 61,099 without and 87,742 with the skill (+43.6%). This includes repeated agent/tool context; it is neither isolated skill overhead nor a billing estimate. Reference-read token costs were not separately available. There is no demonstrated token saving or improvement on the eight search checks.

Pilot deviations: runs overlapped instead of strictly alternating; run 2 used the shared CLI daemon while the others used standalone mode. Initial Windows workspace-sandbox failures produced no artifacts and were excluded; successful runs used the same unrestricted sandbox setting. Review was not blinded, cleanup time was not measured, and no overhead tolerance was preregistered. These limitations prevent a controlled benchmark or acceptance claim. Local generated artifacts, browser scripts/results, screenshots, and JSONL traces are retained under ignored `.verification/`; they are not required by the released skill.

## Manual inspection and remaining limits

Inspected generated source and desktop/320px example screenshots. Keyboard actions above were browser automation, not a human assistive-technology test. Screen-reader announcements, actual browser zoom, touch/virtual keyboard behavior, other browsers/OSes, Next.js integration, runtime profiling, and GitHub-hosted CI were not tested. Consumers still need manual browser and screen-reader checks for their own UI. This pilot establishes installability and example behavior; general agent-output improvements remain unproven.

## Public launch verification — 2026-11-06

This section is new evidence for the public repository. It does not re-approve the 6 November 2026 Windows/Codex/Chromium record above, and it does not copy that pilot forward as this launch's approval. The unpublished go-live checklist was followed only for checks that could actually be run here, then removed before publication. The example manifest stays a private `0.1.0` fixture. The GitHub release tag for this publication is `v0.0.1`, not `v0.1.0`.

### Environment

- Date: 2026-11-06
- OS: Linux x86_64, kernel 6.12.8+. Not macOS and not Windows.
- Node.js v22.23.3 and npm 10.9.9. This satisfies the documented Node 22.12+ floor. Node 24 was not installed here; the workflow file still targets Node 24 and was not edited.
- python3 3.10.22 was used only to request external URLs. The example was not run on Python.
- Headless Chromium for Testing 156.0.8078.4 (Playwright chromium v1248) for the interaction comparison below. No Firefox, WebKit, or other browser was launched.
- Codex was not installed. `$lean-ui` discovery and a fresh agent task were not run.

### Commands and results

From the repository root, before this folder was a Git repository:

- `node scripts/check.mjs` passed. Output: `SKILL.md: 443 whitespace-delimited words; 3145 UTF-8 bytes (not token counts).` Local Markdown links stayed inside the package. This is not a full YAML schema, external-link, or Markdown-anchor validator.
- `git diff --check` failed immediately because the directory was not a Git repository (exit 129). After `git init -b main`, `git diff --cached --check` on the staged publication tree produced no whitespace errors and exited 0. `git status --short --ignored` showed `examples/node_modules/` and `examples/dist/` ignored. No `.env`, coverage, `.verification/`, or `evals/runs/` files were present to stage. The unpublished go-live checklist was not staged.
- `cd examples && npm ci` added 102 packages from `examples/package-lock.json`.
- `npm test` (`vitest run --environment jsdom`) passed: 1 file, 7 tests. These are jsdom tests, not a browser or assistive-technology result.
- `npm run build` (`tsc --noEmit && vite build`) passed. Vite 8.3.6 emitted `dist/index.html`, one CSS asset, and one JS asset.
- `npm run dev` (`vite --host 127.0.0.1`) printed `http://127.0.0.1:5173/`. `curl` received HTTP 200 and the comparison document (`Content-Length: 368`, title `lean-ui interaction comparison`). `GET /main.tsx` and `GET /search.ts` also returned HTTP 200. The server was then stopped; a later connection to port 5173 was refused.

The dev server was started once more for the Chromium session and stopped afterward. It was not left running.

External HTTP GET requests on 2026-11-06 returned 200 for:

- https://learn.chatgpt.com/docs/build-skills
- https://react.dev/learn/you-might-not-need-an-effect
- https://react.dev/learn/rendering-lists (response body contains `keeping-list-items-in-order-with-key`)
- https://nextjs.org/docs/app/getting-started/server-and-client-components
- https://react.dev/reference/react/useEffect (response body contains `fetching-data-with-effects`)
- https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/
- https://www.w3.org/WAI/WCAG22/Techniques/html/H102
- https://www.w3.org/WAI/ARIA/apg/patterns/
- https://www.w3.org/WAI/WCAG22/Understanding/reflow.html
- https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html
- https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
- https://github.com/JayCommit/lean-ui

`LICENSE` contains the MIT terms and `Copyright (c) 2026 lean-ui contributors`.

### Headless Chromium comparison

Driven with Playwright against the Vite URL, not by a person and not with a screen reader. Viewport started at 1280×900 CSS pixels.

Lean section, real Chromium keyboard and timers:

- With a non-empty query, Tab order reached the typical text input, the lean search input, and the native Search button. Shift+Tab from that button returned to the lean search input. The typical Search control is a `div` and was not in the tab order. While the lean query was empty, the disabled Search button was skipped.
- The focused lean input and Search button computed `outline: solid 3px rgb(155, 53, 0)`.
- Enter on `focus` showed status `Searching for “focus”…` with `aria-busy=true`, then `1 result for “focus”.` and list text `Focus management`. Focus stayed on the search input.
- `nothing` showed `No results for “nothing”. Try a different topic.` with no alert and no list.
- `error` showed alert `Could not search for “error”. Your query is kept; select Search to retry or edit it.` The input value remained `error`. The status text was empty while the alert was showing. Replacing the query with `focus` and submitting again showed `1 result for “focus”.` and no alert.
- `slow` reached `Searching for “slow”…`. Submitting `focus` before that delay finished ended, after waiting past the slow timer, at `1 result for “focus”.` and list text `Focus management`, with no alert.

Typical baseline, same page:

- Enter on `focus` left the result list empty.
- Clicking the Search `div` for `focus` listed `Focus management`.
- Clicking it for `error` left the list empty, with no alert and no status region.

At a 320×800 CSS-pixel viewport, the lean input and Search button fit horizontally (input right edge 283; button width 84, left 37). Document `scrollWidth` was 321 against `clientWidth` 320. The Search button's top was 822, so it sat below that short viewport and needed vertical scrolling. This was not a 200% or 400% browser-zoom check.

`prefers-reduced-motion: reduce` was emulated with Playwright `emulateMedia`, then the page was reloaded. `matchMedia` reported true. During a `slow` search the busy region's computed `animationName` was `none` while the status text still said `Searching for “slow”…`. This was not an operating-system reduced-motion setting.

Ctrl and Equal did not change `devicePixelRatio` or `visualViewport.scale` (both stayed 1). Actual browser zoom was therefore not verified. Screen-reader announcements, touch and virtual keyboards, contrast measurement, Firefox, WebKit, macOS, Windows, and Next.js were not tested in this launch.

### Not observed yet at authoring time

A fresh public clone, copying the folder into a project's `.agents/skills/lean-ui`, Codex `$lean-ui` discovery, and the GitHub Actions **Check lean-ui** run were not completed when this section was written. Do not read this section as hosted CI being green.
