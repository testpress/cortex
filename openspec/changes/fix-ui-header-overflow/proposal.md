## Why

The destination screens (Downloads, Bookmarks, Ask Doubt, Announcements) have an awkward back button alignment because the full `screenPadding` pushes the back arrow too far inwards. Additionally, the "Ask Doubt" screen suffers from a right overflow error (e.g., 17-pixel overflow) on items with long lesson titles. Fixing these issues will improve the overall UI polish and prevent visual bugs.

## What Changes

- **Header Padding**: Reduce the left padding for the back button on destination screen headers so it sits closer to the left edge of the screen rather than using the full `screenPadding`.
- **Ask Doubt Card Layout**: Restructure the doubt item card layout so that the timeline text (e.g., "3 weeks ago") sits on the same line as the status badge. This frees up the second line entirely for the lesson title, preventing overflow.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
None (These are UI/layout fixes only; core functional requirements do not change).

## Impact

- Header widgets across feature packages (e.g., `DownloadsHeader` in `packages/courses`, and similar headers in discussions/bookmarks).
- The Doubt item card widget in the `packages/discussions` package (Ask Doubt screen).
- No impact on APIs, data models, or core business logic.
