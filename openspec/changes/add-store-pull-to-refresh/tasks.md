## 1. UI Implementation

- [x] 1.1 Wrap the `CustomScrollView` in `StorePage` (`packages/courses/lib/screens/store/store_page.dart`) with `AppRefreshIndicator`.
- [x] 1.2 Implement the `onRefresh` callback to use `ref.refresh` on `storeProductsProvider.future`.
- [x] 1.3 Update the `onRefresh` callback to also use `ref.refresh` on `storeCategoriesProvider.future`.
- [x] 1.4 Test the pull-to-refresh gesture manually on the store screen to ensure data is re-fetched and UI updates.
- [x] 1.5 Add an automated widget test for `StorePage` to verify pull-to-refresh triggers repository calls.
