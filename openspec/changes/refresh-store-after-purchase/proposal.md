## Why

When a user completes a course purchase or installment payment, returning to the Store screen still displays the course as available for purchase until the page is manually refreshed. This occurs because `storeProductsProvider` and `storeCategoriesProvider` are not invalidated upon checkout completion, and `StoreRepository` retains the cached products in memory.

## What Changes

- Invalidate `storeProductsProvider` and `storeCategoriesProvider` upon successful payment in `ProductDetailScreen` and `ProductInstallmentSheet`.
- Clear `StoreRepository` in-memory caches (`clearAll()`) upon successful payment.
- Invalidate `courseListProvider` / trigger study course sync on payment success so that newly enrolled courses appear immediately in the user's Study / My Courses library.

## Capabilities

### New Capabilities

### Modified Capabilities
- `store-store`: Add requirement for automatic cache invalidation and store content refresh following a successful product purchase or installment payment.

## Impact

- Affected packages: `packages/courses` (`ProductDetailScreen`, `ProductInstallmentSheet`, store providers), `packages/core` (`PaymentResult`, `PaymentProcessingScreen`).
- Affected tests: `packages/courses/test/screens/store/product_detail_screen_test.dart` and installment sheet tests.
