## 1. AppTabBar Update

- [x] 1.1 Update `AppTabBar` in `packages/core/lib/widgets/app_tab_bar.dart` to apply margin, rounded borders, and shadow.
- [x] 1.2 Remove the top border and adjust background colors inside `AppTabBar` to fit the floating style.

## 2. AppShell Update

- [x] 2.1 Refactor `AppShell` in `packages/core/lib/shell/app_shell.dart` to use a `Stack` instead of a `Column` for portrait mode.
- [x] 2.2 Wrap the `bottomNavigationBar` with an `Align(alignment: Alignment.bottomCenter)` within the `Stack`.
- [x] 2.3 Adjust the SafeAreas or bottom padding for the child view to ensure bottom-most content is reachable.
