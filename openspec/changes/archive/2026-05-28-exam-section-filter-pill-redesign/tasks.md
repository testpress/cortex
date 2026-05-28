## 1. Clean Up SectionsTabBar Widget

- [x] 1.1 Remove `isExpanded` and `onExpandChanged` parameters from `SectionsTabBar`
- [x] 1.2 Delete the collapsed-state branch (`if (!isExpanded)` block) entirely
- [x] 1.3 Remove the `ShaderMask` + `ListView.builder` scroll implementation
- [x] 1.4 Replace the scroll area with a `SingleChildScrollView` (horizontal) containing a `Row`

## 2. Restyle Pill Chips in SectionsTabBar

- [x] 2.1 Replace the inner `GestureDetector` + `Container` pill with `AppSemantics.button` + `AppFocusable` wrappers
- [x] 2.2 Use `AnimatedContainer` (200 ms, `design.motion.easeOut`) for the pill body
- [x] 2.3 Set inactive pill: background `design.colors.surfaceVariant`, text `design.colors.textPrimary`
- [x] 2.4 Set active pill: background `design.colors.textPrimary`, text `design.colors.card`
- [x] 2.5 Apply `design.radius.pill` border-radius (no explicit `Border`)
- [x] 2.6 Switch pill text from `AppText.body` to `AppText.label`
- [x] 2.7 Remove the fixed `50 px` container height — let the pill row size to content

## 3. Remove Collapse Toggle Button

- [x] 3.1 Delete the chevron-up `GestureDetector` / `Container` at the trailing edge of the expanded row
- [x] 3.2 Remove the `Row` wrapper that held the scrollable + chevron; replace with the bare `SingleChildScrollView`

## 4. Clean Up TestDetailScreen

- [x] 4.1 Remove `_isSectionsTabBarExpanded` state field from `_TestDetailScreenState`
- [x] 4.2 Remove `isExpanded` and `onExpandChanged` props from the `SectionsTabBar(...)` call in `build()`
