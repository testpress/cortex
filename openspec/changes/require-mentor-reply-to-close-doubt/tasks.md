## 1. Restrict Doubt Close Action

- [x] 1.1 Add `canCloseDoubt` static method in `DoubtDetailScreen` checking if any reply has `isMentor == true`
- [x] 1.2 Update the header action in `DoubtDetailScreen` to only show the action menu when `canClose` is true and status is not closed
- [x] 1.3 Guard `_buildActionSheet` so the close doubt action dismisses the sheet and cannot be triggered if `canClose` is false

## 2. Testing and Verification

- [x] 2.1 Add unit tests for `DoubtDetailScreen.canCloseDoubt`
- [x] 2.2 Add widget tests for `DoubtDetailScreen` verifying the close menu is hidden/shown based on mentor replies and stream updates
- [x] 2.3 Run `flutter analyze` and tests in `packages/discussions` to verify all tests pass
