## Why

The store page currently lacks a way for users to manually refresh its content. Adding a pull-to-refresh mechanism ensures users can easily fetch the latest products and store data without having to navigate away and back, creating a more seamless and consistent experience.

## What Changes

- Wrap the main store page scroll view with a pull-to-refresh indicator.
- Reuse the existing `AppRefreshIndicator` widget to maintain consistency with other sections (e.g., Study, Exams).
- Ensure that the refresh action triggers a reload of the store data from the backend.

## Capabilities

### New Capabilities


### Modified Capabilities
- `store-store`: Updating the store page layout to support manual refresh gestures and reloading data on pull.

## Impact

- **UI/UX**: Store page will feature a pull-to-refresh indicator.
- **Data Flow**: Store provider/repository will need a refresh method if it doesn't already have one exposed to the UI, or we will just trigger the existing load/refresh method.
- **Components**: The main store screen widget will be updated to include the `AppRefreshIndicator` wrapper.
