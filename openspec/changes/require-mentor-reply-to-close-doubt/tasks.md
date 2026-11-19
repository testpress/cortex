## 1. Restrict Doubt Close Action

- [x] 1.1 Add `hasMentorReply` evaluation in `DoubtDetailScreen` checking if any reply has `isMentor == true`
- [x] 1.2 Update the header action in `DoubtDetailScreen` to only show the action menu when `hasMentorReply` is true and status is not closed
- [x] 1.3 Guard `_buildActionSheet` so the close doubt action cannot be triggered if `hasMentorReply` is false

## 2. Testing and Verification

- [x] 2.1 Add widget tests for `DoubtDetailScreen` verifying the close menu is hidden when no mentor replies exist
- [x] 2.2 Add widget tests for `DoubtDetailScreen` verifying the close menu is displayed when a mentor reply exists
- [x] 2.3 Run `flutter analyze` and tests in `packages/discussions` to verify all tests pass
