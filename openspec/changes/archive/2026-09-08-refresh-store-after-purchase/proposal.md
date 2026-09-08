## Why

When a user completes a course purchase or installment payment, returning to the Store screen still displays the course as available for purchase until the page is manually refreshed. This occurs because `storeProductsProvider` and `storeCategoriesProvider` are not invalidated upon checkout completion, and `StoreRepository` retains the cached products in memory. Furthermore, newly purchased courses need to be immediately synchronized to local storage and the Study library.

## What Changes

- Invalidate `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` upon successful payment in `ProductDetailScreen` and `ProductInstallmentSheet`.
- Clear `StoreRepository` in-memory caches (`clearAll()`) upon successful payment.
- Refresh study courses via `courseListProvider.notifier.refresh()` on payment success so that newly enrolled courses appear immediately in the user's Study library.

## Capabilities

### New Capabilities

### Modified Capabilities
- `store-store`: Add requirement for automatic cache invalidation, store content refresh, and study courses synchronization following a successful product purchase or installment payment.

## Impact

- Affected packages: `packages/courses` (`ProductDetailScreen`, `ProductInstallmentSheet`, store providers), `packages/core` (`PaymentResult`, `PaymentProcessingScreen`).
- Affected tests: `packages/courses/test/screens/store/product_detail_screen_test.dart` and `packages/courses/test/widgets/store/product_installment_sheet_test.dart`.
