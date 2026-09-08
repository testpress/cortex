## 1. Store Refresh & Study Courses Sync

- [x] 1.1 Invalidate store providers (`storeProductsProvider`, `storeCategoriesProvider`, `productDetailProvider`), clear `StoreRepository` cache (`clearAll()`), and refresh study courses via `courseListProvider.notifier.refresh()` upon successful purchase in `packages/courses/lib/screens/store/product_detail_screen.dart`.
- [x] 1.2 Invalidate store providers (`storeProductsProvider`, `storeCategoriesProvider`, `productDetailProvider`), clear `StoreRepository` cache (`clearAll()`), and refresh study courses via `courseListProvider.notifier.refresh()` upon successful installment payment in `packages/courses/lib/widgets/store/product_installment_sheet.dart`.

## 2. Verification & Testing

- [x] 2.1 Update or add widget tests in `packages/courses/test/screens/store/product_detail_screen_test.dart` and `packages/courses/test/widgets/store/product_installment_sheet_test.dart` to verify store cache clearing and study course sync on successful payment.
- [x] 2.2 Run test suite in `packages/courses` and `flutter analyze` to ensure all tests pass and no regressions are introduced.

