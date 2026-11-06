# Evaluation protocol

Status: a preliminary one-task release pilot is recorded in [release-verification.md](release-verification.md). Agent-output improvements are not established by a benchmark. Example regression tests validate the example only.

## Paired runs

Use the same model/version, settings, prompt, starter files, tools, and output budget for each pair. Run one fresh context without lean-ui and one with it. Alternate order across pairs. Disable unrelated frontend skills in both conditions; record any unavoidable differences. Do not show this rubric or the worked example to the generation run. A separate review phase should score the resulting artifacts against the observable checks below.

Run each task at least three times per condition to expose variance. This is a small pilot, not a statistically conclusive benchmark. Keep generated artifacts and logs under a local `evals/runs/` directory if storing them here, and omit credentials or personal data. Use the same task-specific fixture API for both conditions.

## Task prompts and observable checks

### 1. Search

Prompt: “Build a React topic search form using the provided `search(query, signal)` function. Show matching topics.” Supply [the fixture contract](../examples/search.ts) without the worked components.

Check: visible associated input label; keyboard submit; pending feedback; distinct empty and error; retained query and recovery; latest submission wins under out-of-order fulfillment and rejection; stable IDs for results; no focus jump on arrival. Fixture: slow old request, faster new request; a rejected request; empty success.

### 2. Edit dialog

Prompt: “Add an Edit name dialog to a profile card. Save through the provided `saveName(name): Promise<void>` function.” Fixture: one rejected save, then success; long existing name; trigger remains in DOM.

Check: named dialog/input; intentional initial focus; modal background unavailable; Tab/Shift+Tab contained; Escape and visible Cancel close; focus returns to opener; pending saves resist duplicate activation; rejected save preserves input and offers recovery. Modal behavior must run in a real browser, not jsdom alone.

### 3. Responsive results

Prompt: “Build a filterable list of 200 products with name, price, thumbnail, and an expandable details action using the provided fixture.” Fixture: stable IDs, a long unbroken name, reorder/filter operation, fixed thumbnail dimensions.

Check: native named controls; expansion state exposed; editing filter preserves focus; reorder does not transfer expanded state to another ID; usable at 320 CSS pixels and zoom; no essential hover-only action; reduced motion preserves feedback; image space reserved. Profile filtering before claiming performance improvement. Do not require virtualization for 200 rows without evidence.

## Scoring and reporting

Each listed check scores 1 for observed pass, 0 for observed failure. Mark untested checks `U`; exclude them from the denominator and report their count so missing coverage cannot look like a perfect result. Keep each task's checks identical between conditions. Record concrete defects and reproduction steps; optionally use a blinded reviewer. Automated accessibility findings and manual keyboard/focus checks are separate evidence.

Record input/output tokens from the agent's usage report, including skill/reference reads; separately report cached tokens and tool output if available. Never compare whitespace word counts as if they were tokens. Report skill overhead, total task tokens, pass counts, untested counts, and median review/cleanup time. Use the same reviewer protocol and stopwatch boundaries (review start through agreed acceptance) in both conditions.

Use [results-template.md](results-template.md) for each pair. Success is fewer observed interaction/a11y defects without unacceptable token overhead; choose an overhead tolerance before running, and report raw results even when they disappoint. No single combined score should hide a keyboard blocker or a race-condition failure.
