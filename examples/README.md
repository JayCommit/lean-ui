# Search before and after

The deliberately flawed [TypicalSearch](TypicalSearch.tsx) and improved [LeanSearch](LeanSearch.tsx) accept the same typed search function. The [fixture](search.ts) runs locally. These are teaching components, not a component library or evidence of average agent behavior.

From this directory, with Node 22.12+ (or a compatible newer LTS):

```sh
npm ci
npm test
npm run build
npm run dev
```

Open the local URL printed by Vite. No backend or parent-repository setup is needed. Runtime packages are used only by these examples, never by the skill. The lockfile records exact resolutions.

| Behavior | Typical | Lean |
| --- | --- | --- |
| Input naming | Placeholder only | Visible associated label |
| Keyboard submit | Clickable div | Native form/button; Enter works |
| Pending | Silent | Mounted status region with progress text |
| Empty / error | Both look like an empty list | Distinct explanation and recovery |
| Repeated reads | Last response wins | Latest submission wins, prior read aborted |
| List identity | Array index | Stable data ID |
| Focus | No keyboard action target | Native focus behavior and visible indicator |

The lean version is longer because it implements more behavior. Token efficiency here means small skill overhead and targeted changes, not fewer lines at any cost. A real app may already provide request state and cancellation through its framework.

Manual checks: Tab through the lean form, submit with Enter, check slow/empty/error results, edit “error” to “focus” and recover, then submit “slow” followed by “focus”. Narrow the window to 320px, zoom, try long unbroken input, and enable reduced motion. Confirm results do not move focus. Check announcements with a screen reader; jsdom tests cannot establish announcement behavior, real reflow, contrast, or browser-native keyboard submission.

The two sections intentionally keep their own interactions, so the baseline remains inaccessible. For an automated accessibility scan of production-quality markup, isolate the lean section. Do not ship the baseline.
