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

1. **Header Padding**: We will replace `design.spacing.screenPadding` with a smaller value (`design.spacing.md`) for the left padding of the back button in `DownloadsHeader` and similar custom headers (Bookmarks, Forum, Announcements, App Settings, Analytics).
2. **Ask Doubt Layout**: We will separate the metadata into distinct rows to prevent overflow: Topic Name on the second row, Timeline on the third row, and Status Badge on the fourth row.
3. **App Drawer Cleanup**: We will remove the "Reports" option from the DashboardDrawer.

## Risks / Trade-offs

- **Risk**: Inconsistent headers across the app. 
- **Mitigation**: We are only fixing the currently reported screens. A larger unification to a standard `AppHeader` could be done as a separate technical debt task.
