# Accessibility decisions

Start with semantic HTML: button for actions, anchor with a destination for navigation, form for submission, headings for structure. Give icon-only controls an accessible name. Use visible labels for inputs; placeholders disappear and are insufficient labels. Specify `type="button"` for non-submit buttons inside forms.

Keep focus order aligned with reading order. Avoid positive `tabIndex`, clickable containers, and removing outlines without a visible replacement. Native buttons already handle Enter and Space; do not duplicate handlers. Use appropriate autocomplete tokens and input types. Keep help/error IDs unique across repeated instances; connect them with `aria-describedby`, and set `aria-invalid` when invalidity is established.

For custom composite widgets (tabs, menu, combobox), reuse a proven existing primitive. Plain navigation links do not need menu semantics. If implementing a pattern, consult its actual keyboard contract rather than adding roles alone.

For a modal, prefer an existing accessible primitive or native `dialog` opened with `showModal()` where suitable. Give it an accessible name. Place initial focus intentionally; keep background content inert and keyboard focus contained while open. Provide a visible close/cancel action and Escape dismissal where appropriate. Return focus to the opener or a logical successor if it was removed. Avoid nested hand-built focus traps. Test both forward and backward tabbing. Only use `aria-modal` when the behavior is truly modal.

Loading and successful updates should usually preserve focus and announce via a polite status region. Use alerts sparingly. Validation should identify the field, explain the problem, and say how to correct it; color alone is insufficient.

Verify accessible names, keyboard-only operation, visible/unobscured focus, zoom, and contrast of changed content. Automated scans supplement these checks; manual screen-reader testing is needed to assess real announcements. Report missing coverage honestly.

Sources: WAI [modal keyboard/focus pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/), [native dialog technique](https://www.w3.org/WAI/WCAG22/Techniques/html/H102), and [widget patterns](https://www.w3.org/WAI/ARIA/apg/patterns/).
