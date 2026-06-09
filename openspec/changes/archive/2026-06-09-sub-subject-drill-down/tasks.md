## 1. SubjectAnalyticsScreen — Conditional Tabs

- [x] 1.1 Wrap the Tabs Row in `if (widget.parentId == null)` to hide it when viewing a child subject
- [x] 1.2 Verify the `OverallReportsView` is shown by default when `parentId != null`

## 2. OverallReportsView — Tappable Bar Rows

- [x] 2.1 Add `import 'package:go_router/go_router.dart'`
- [x] 2.2 Wrap non-leaf `BarRow` items in `AppFocusable` with `context.push` navigation
- [x] 2.3 Leave leaf `BarRow` items as plain, non-interactive widgets

## 3. IndividualReportsView — Tappable Table Cells and Chevron

- [x] 3.1 Add `import 'package:go_router/go_router.dart'`
- [x] 3.2 Wrap the subject name cell in `GestureDetector` with `onTap` set for non-leaf rows
- [x] 3.3 Wrap the Correct, Incorrect, and Unanswered cells in `GestureDetector` with `onTap` set for non-leaf rows
- [x] 3.4 Wrap the chevron cell in `GestureDetector` with `onTap` set for non-leaf rows
- [x] 3.5 Set `onTap: null` for all cells where `subject.leaf == true`

## 4. Tests

- [x] 4.1 Add widget test: `SubjectAnalyticsScreen` with `parentId` hides tabs and shows `OverallReportsView` only
- [x] 4.2 Add cleanup (`pumpWidget(SizedBox.shrink())` + `pumpAndSettle`) to prevent timer leak in test teardown
