## 1. AppBadge Implementation

- [x] 1.1 Create `packages/core/lib/widgets/app_badge.dart`.
- [x] 1.2 Define an `AppBadge` stateless widget with required `String label` and optional `Color? backgroundColor`, `Color? foregroundColor`, and `StatusColors? semanticStatus`.
- [x] 1.3 In the widget `build` method, access `Design.of(context).statusColors` to resolve colors if `semanticStatus` is provided. If `semanticStatus` is null, fall back to the provided raw colors or a safe default.
- [x] 1.4 Style the text label with standard badge typography (bold text, tight letter spacing, small font size) and apply appropriate inner padding and border radius.

## 2. AppSearchBar Implementation

- [x] 2.1 Create `packages/core/lib/widgets/app_search_bar.dart`.
- [x] 2.2 Define an `AppSearchBar` stateless widget featuring properties for `String hintText`, `ValueChanged<String>? onChanged`, and an optional `TextEditingController`.
- [x] 2.3 Implement the UI using a `Container` with `design.colors.surface` background, an `Icon(Icons.search)` as a prefix icon, and a `TextField`.
- [x] 2.4 Apply rounded borders to the container and hide default `TextField` borders to ensure a seamless input design mimicking the design specs.

## 3. AppTabBar Implementation

- [x] 3.1 Create `packages/core/lib/widgets/app_tab_bar.dart`.
- [x] 3.2 Define an `AppTabItem` data class holding an `id`, `label`, and `IconData`.
- [x] 3.3 Define an `AppTabBar` stateless widget that accepts a `List<AppTabItem> items`, `String activeItemId`, and `ValueChanged<String> onTabChange`.
- [x] 3.4 In the `build` method, construct a bottom anchored row containing the tab items uniformly distributed.
- [x] 3.5 Style active items differently from inactive items (e.g., thicker stroke on icons and primary text color vs muted slate colors).

## 4. AppSubjectChip Implementation

- [x] 4.1 Create `packages/core/lib/widgets/app_subject_chip.dart`.
- [x] 4.2 Define an `AppSubjectChip` stateless widget with properties `String label`, `int subjectPaletteIndex`, `bool isActive`, `IconData? icon`, and `VoidCallback onTap`.
- [x] 4.3 In `build`, fetch `Design.of(context).subjectPalette.atIndex(subjectPaletteIndex)` to retrieve the subject-specific colors (`background`, `foreground`, `accent`).
- [x] 4.4 Structure the chip to display an optional solid background box for the icon (using the subject's background color) and text beside it.
- [x] 4.5 Apply conditional styling based on `isActive`: if active, apply shadows or scale effects; if inactive, use a muted white/surface background with subtle borders.

## 5. Export and Verification

- [x] 5.1 Open `packages/core/lib/core.dart` (or equivalent barrel file) and export `app_badge.dart`, `app_search_bar.dart`, `app_tab_bar.dart`, and `app_subject_chip.dart`.
- [x] 5.2 Run `flutter analyze` in `packages/core` to ensure there are zero syntax or linting errors.
- [x] 5.3 Ensure all new widgets compile successfully when integrated into a placeholder screen or a test suite.

## 6. Post-Implementation Refinements

- [x] 6.1 Centralize `lucide_icons` dependency within `packages/core` and export it via `core.dart` for unified access.
- [x] 6.2 Update `AppBadge` to accept `IconData? icon` and `bool isPill` arguments for custom Leaderboard & Blog tags.
- [x] 6.3 Update `AppTabItem` mapping logic to utilize an optional `IconData? activeIcon` to properly map `stroke` behaviors from the designs.
