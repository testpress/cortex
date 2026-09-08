## Why

On the Store screen:
1. Bottom-most product cards are partially obscured behind the persistent floating bottom navigation bar when scrolled to the end because trailing bottom clearance is missing.
2. Multi-line course titles and disproportionately scaled price rows cause uneven card heights and misaligned baselines across the 2-column grid.

## What Changes

- Add trailing bottom clearance sliver (`SizedBox(height: 120)`) to `CustomScrollView` in `StorePage`, matching the clearance pattern in other tab screens.
- Standardize `ProductCard` title to use single-line ellipsis (`maxLines: 1, overflow: TextOverflow.ellipsis`), consistent with other monorepo card patterns.
- Enforce fixed 24dp vertical height (`SizedBox(height: 24)`) around the price `FittedBox` in `ProductCard`, preventing vertical card height collapse when long prices scale down horizontally.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `store-store`: Update Store page scrollable area requirements for floating navigation clearance and product card grid alignment uniformity.

## Impact

- **Affected Code**:
  - `packages/courses/lib/screens/store/store_page.dart`
  - `packages/courses/lib/widgets/store/product_card.dart`
- **Tests**:
  - `packages/courses/test/screens/store/store_page_test.dart`
  - `packages/courses/test/widgets/store/product_card_test.dart`
