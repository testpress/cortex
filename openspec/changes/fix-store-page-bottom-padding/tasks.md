## 1. UI Implementation

- [x] 1.1 Add trailing `SliverToBoxAdapter(child: SizedBox(height: 120))` to `CustomScrollView.slivers` in `packages/courses/lib/screens/store/store_page.dart`.
- [x] 1.2 Standardize `ProductCard` title to use single-line ellipsis (`maxLines: 1, overflow: TextOverflow.ellipsis`) in `packages/courses/lib/widgets/store/product_card.dart`.
- [x] 1.3 Wrap price `FittedBox` in `SizedBox(height: design.spacing.lg)` (24dp) in `ProductCard` to ensure uniform card height across short and long prices.

## 2. Verification

- [x] 2.1 Update widget tests in `packages/courses/test/screens/store/store_page_test.dart` to verify the bottom spacer sliver exists.
- [x] 2.2 Update widget tests in `packages/courses/test/widgets/store/product_card_test.dart` to verify single-line title with ellipsis and fixed `design.spacing.lg` (24dp) price row height.
- [x] 2.3 Run courses package test suite and `flutter analyze` to verify all tests pass.
