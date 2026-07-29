## 1. Discovery

- [x] 1.1 Identify all usages of delete/remove actions for downloaded attachments
- [x] 1.2 Identify all usages of delete actions for downloaded videos
- [x] 1.3 Identify all usages of remove actions for bookmarks
- [x] 1.4 Identify all usages of close actions for doubts

## 2. Core Implementation

- [x] 2.1 Locate or create a generic confirmation dialog helper in `packages/core`
- [x] 2.2 Update attachment deletion handlers to use the confirmation dialog
- [x] 2.3 Update video deletion handlers to use the confirmation dialog
- [x] 2.4 Update bookmark removal handlers to use the confirmation dialog
- [x] 2.5 Update doubt closing handlers to use the confirmation dialog
- [x] 2.6 Localize all dialog titles, contents, and buttons across English, Arabic, Malayalam, and Tamil (`.arb` files)

## 3. Verification

- [x] 3.1 Verify dialog appears for each action and tapping 'Cancel' aborts the action
- [x] 3.2 Verify tapping 'Confirm' executes the action as expected
