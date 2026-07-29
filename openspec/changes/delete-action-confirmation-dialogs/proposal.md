## Why

Currently, several delete and remove actions (like deleting downloaded attachments/videos, removing bookmarks, or closing doubts) happen immediately without user confirmation. This can lead to accidental data loss or unintended actions, resulting in a poor user experience. Adding a confirmation dialog ensures the user explicitly intends to perform these destructive actions.

## What Changes

- Add a confirmation dialog ("Are you sure you want to delete/remove this item?") before executing delete/remove operations.
- Apply this pattern consistently across the application for actions such as:
  - Deleting downloaded attachments
  - Deleting downloaded videos
  - Removing bookmarks
  - Closing doubts
  - Other similar destructive operations

## Capabilities

### New Capabilities

- `delete-confirmation`: Standardizes the requirement for a confirmation prompt across the application before performing any delete, remove, or close actions on user data or downloaded content.

### Modified Capabilities

- None

## Impact

- **UI/UX**: Users will see a dialog interrupting immediate deletion, requiring an extra tap (Delete/Cancel).
- **Code**: Modifies the action handlers (e.g., button `onPressed` callbacks) for all relevant destructive actions across domain packages (e.g., `packages/courses`, `packages/exams`, etc.) to wrap the deletion logic in a dialog prompt. May utilize a common dialog component from `packages/core`.
