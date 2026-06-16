## Context

The current back buttons in feature screens (Downloads, Bookmarks, Ask Doubt) are aligned too far to the right due to using the full `screenPadding`. The Ask Doubt screen also suffers from text overflow on long titles because the title and timeline are grouped too tightly on the same line.

## Goals / Non-Goals

**Goals:**
- Align the back buttons closer to the left edge in feature headers.
- Prevent overflow in the Ask Doubt card layout.

**Non-Goals:**
- Do not rewrite the core `AppHeader` for this quick fix (though it's a good future refactor).
- Do not change any backend data or existing features.

## Decisions

1. **Header Padding**: We will replace `design.spacing.screenPadding` with a smaller value (e.g., `design.spacing.sm` or `8.0`) for the left padding of the back button in `DownloadsHeader` and similar custom headers.
2. **Ask Doubt Layout**: We will move the timeline text to the third row of the card, right next to the status badge, allowing the lesson title to occupy the full width of the second row.

## Risks / Trade-offs

- **Risk**: Inconsistent headers across the app. 
- **Mitigation**: We are only fixing the currently reported screens. A larger unification to a standard `AppHeader` could be done as a separate technical debt task.
