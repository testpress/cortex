## Why

The current home dashboard contains several minor UX friction points that degrade the user experience. Specifically, the hero banner auto-scroll conflicts with manual user swipes, the "Recently completed" list has an unnecessary opacity effect that makes items look disabled, and horizontal item lists (like carousels) use a step-by-step paginated scroll instead of a smooth, fluid, and infinite scroll. Addressing these will result in a more polished and responsive dashboard.

## What Changes

- **Hero Banner Interactivity**: The hero banner's auto-play timer will be paused when the user interacts with the carousel (e.g., swiping or holding) and will resume when the interaction ends.
- **Recently Completed List Styling**: The opacity effect applied to items in the "Recently completed" list will be removed, ensuring they are fully visible and clear.
- **Horizontal Scrolling**: Horizontal lists (carousels) will be updated to support smooth, continuous scrolling rather than step-by-step page snapping, allowing the user to seamlessly scroll to the end of the list.

## Capabilities

### New Capabilities

*(No new capabilities are being introduced; this is an enhancement to existing ones.)*

### Modified Capabilities

- `lms-home-paid-active`: Requirements updated for hero banner interaction (pause auto-play on drag) and horizontal carousel scrolling behavior (smooth continuous scrolling instead of snapping).
- `dashboard-recently-completed`: Requirements updated to remove the opacity/faded styling on the list items.

## Impact

- **UI/UX**: Improved smoothness and responsiveness of the dashboard.
- **Affected Components**: `HeroBannerCarousel`, "Recently Completed" list widgets, and other horizontal `ListView` or `PageView` carousels on the dashboard.
- No breaking API changes or dependency changes.
