## Context

When a user completes a course purchase from `ProductDetailScreen` or an installment payment from `ProductInstallmentSheet`, only `productDetailProvider(slug)` is currently invalidated. Since `StorePage` is alive in the router stack underneath the product detail view, its active subscription to `storeProductsProvider` retains the pre-purchase list of products. Furthermore, `StoreRepository` retains in-memory cached responses in its `_productCache` map. As a result, when the user navigates back to the store, the purchased product is still visible until a manual pull-to-refresh is executed.

## Goals / Non-Goals

**Goals:**
- Automatically clear `StoreRepository` in-memory caches and invalidate `storeProductsProvider`, `storeCategoriesProvider`, and `productDetailProvider` upon successful purchase in both `ProductDetailScreen` and `ProductInstallmentSheet`.
- Explicitly refresh `courseListProvider` via `courseListProvider.notifier.refresh()` to ensure newly enrolled courses are synchronized from the network into local database and UI.
- Ensure automated widget tests verify the store cache clearing and study course sync on payment success.

**Non-Goals:**
- Modifying backend endpoints or changing payment gateway integration logic.
- Altering the UI presentation of the store list or product detail pages.

## Decisions

- **Direct Invalidation & Cache Eviction in Success Handlers via `refreshStoreAfterPurchase`**:
  - *Rationale*: Encapsulating `ref.read(storeRepositoryProvider).clearAll()`, `ref.invalidate(storeProductsProvider)`, `ref.invalidate(storeCategoriesProvider)`, `ref.invalidate(productDetailProvider(slug))`, and `ref.read(courseListProvider.notifier).refresh()` inside a shared helper `refreshStoreAfterPurchase(ref, productSlug: ...)` ensures immediate, deterministic cache clearing and keeps checkout call sites consistent.
  - *Alternatives considered*: Calling `ref.invalidate(courseListProvider)`. Rejected because `CourseList.build()` only watches local SQLite without re-fetching from the network API.
- **Payment Screen Navigation Decoupling**:
  - *Rationale*: Popping `PaymentProcessingScreen` with a `redirectRoute` in `PaymentResult` allows caller screens to execute eviction and invalidation before triggering top-level navigation (`context.go`).


## Risks / Trade-offs

- **[Risk] Re-fetching network data when returning to store**:
  - *Mitigation*: Re-fetching product data from the server upon store tab visit is the exact intended behavior to reflect the updated purchase state without stale cache.
