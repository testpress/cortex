## 1. Core Primitive Implementation (packages/core)

- [x] 1.1 Convert `AppSearchBar` to a `StatefulWidget` supporting internal fallback and external `TextEditingController` management.
- [x] 1.2 Implement listener attachment and safe disposal in `didUpdateWidget` and `dispose` to prevent memory leaks during controller swaps.
- [x] 1.3 Add a trailing clear button (`LucideIcons.x`) conditioned on `_effectiveController.text.isNotEmpty`.
- [x] 1.4 Wire the clear button tap handler to clear text, invoke `onChanged?.call('')`, and call the optional `onClear?.call()`.
- [x] 1.5 Wrap the clear button in `ConstrainedBox(constraints: BoxConstraints(minWidth: 48))` with `padding: EdgeInsets.only(left: design.spacing.md, right: hasText ? 0 : design.spacing.md)`.

## 2. Accessibility & Localization (packages/core)

- [x] 2.1 Add `commonClearSearchSemantic` localization key to ARB files (`app_en.arb`, `app_ta.arb`, `app_ml.arb`, `app_ar.arb`) and generated localization classes.
- [x] 2.2 Add `clearSemanticLabel` parameter to `AppSearchBar` defaulting to `L10n.of(context).commonClearSearchSemantic`.
- [x] 2.3 Wrap the clear button in `AppSemantics.button` and set `excludeFromSemantics: true` on the inner `GestureDetector` to eliminate duplicate announcements.

## 3. Testing & Verification (packages/core)

- [x] 3.1 Add widget tests in `app_search_bar_test.dart` asserting that the clear button is hidden when empty and shown when text is entered.
- [x] 3.2 Add widget tests verifying that tapping the clear button resets text and triggers `onChanged('')` and `onClear()`.
- [x] 3.3 Add widget tests verifying `clearSemanticLabel` and localized screen reader accessibility.
- [x] 3.4 Add widget tests verifying controller swapping lifecycle and internal controller fallback.
