# Performance decisions

Fix a concrete cost: duplicate requests, typing lag, expensive repeated calculation, layout shift, or excessive client code. A rerender is not inherently a bug. Measure the affected interaction with the tools already available; do not introduce optimization dependencies preemptively.

- Keep transient state local. Derive cheap filtered values during render instead of copying props into state with an effect.
- Use persistent data IDs for changing lists. Index keys are unsuitable when items reorder, insert, or disappear; random keys remount items and can lose input/focus.
- Effects synchronize external systems. User-triggered mutations belong in action handlers or the framework's action mechanism. Supply honest dependencies and cleanup; do not silence dependency warnings to hide a loop.
- Use existing caches/loaders to avoid request waterfalls. Debounce expensive search-as-you-type when warranted; manual submit does not need debouncing. Cancellation alone is insufficient protection against stale commits.
- Add `memo`, `useMemo`, or `useCallback` only for observed expensive work or a consumer that benefits from stable identity. Account for existing compiler optimizations. Do not blanket-wrap components.
- Bound large result sets through pagination or, where justified, virtualization. Check keyboard navigation and focus preservation if items unmount.
- Reserve image/media space; choose appropriately sized assets. Lazy-load below-fold work, avoiding delay for immediately visible critical content.

For Next.js App Router, retain server rendering for data/static content where possible and place client boundaries around interactive parts. Avoid marking an entire page client-side for one button. Keep secrets and server-only modules off the client. Follow the project's router and framework version rather than migrating architecture for a UI fix.

For other frameworks, translate the invariants: stable identity, bounded work, local reactive state, disposed side effects, and minimal browser payload. React-specific hooks are examples, not requirements.

Sources: React [effect guidance](https://react.dev/learn/you-might-not-need-an-effect), [list identity](https://react.dev/learn/rendering-lists#keeping-list-items-in-order-with-key), and Next.js [server/client components](https://nextjs.org/docs/app/getting-started/server-and-client-components).
