# Interaction states

Use the app's existing request/form mechanism. A small component may use local state; do not impose a global state machine or data library.

| State | Observable behavior |
| --- | --- |
| Idle | Clear action and any input requirements |
| Pending | Immediate textual feedback; duplicate mutation blocked; stable layout |
| Success | Result or confirmation visible and appropriately announced |
| Empty | A successful response with no results, distinct from loading and failure; useful next step |
| Failure | Actionable message, retained input, and retry or correction path |

Use mutually exclusive states when independent booleans could contradict each other. For refreshed data, explicitly choose whether to keep previous results visible and label them as previous while pending. Never show stale results as the answer to a newer query.

For replaceable reads, cancel prior work where supported and guard commits so an obsolete response cannot overwrite a newer result, even if the transport ignores cancellation. Clean up on unmount. Treat cancellation separately from failure. For mutations, disabling a button is only a UI guard: use an existing server idempotency mechanism when repeated execution matters; aborting a client request does not undo a server write.

Submit forms through `onSubmit` so Enter works. Keep a pending action understandable with text such as “Saving…”. Choose native disabled controls or guarded `aria-disabled` based on focus needs; the latter does not block activation by itself. Preserve values on failure. Identify invalid fields, associate their errors, and focus the first invalid field or a useful error summary after a failed submission. Avoid clearing form data before success.

Use polite status announcements for ordinary progress/results; reserve alerts for errors needing immediate attention. Keep the status region mounted before its text changes. Do not announce every keystroke. Avoid moving focus merely because results arrived.

Check slow success, empty success, rejection, correction/retry, rapid repeated actions, out-of-order responses, and leaving during pending work as applicable.

See React's [effect cleanup and async race guidance](https://react.dev/reference/react/useEffect#fetching-data-with-effects). Prefer the framework's existing data facilities when available.
