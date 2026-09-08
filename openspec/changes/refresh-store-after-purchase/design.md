## Context

When a user completes a course purchase from `ProductDetailScreen` or an installment payment from `ProductInstallmentSheet`, only `productDetailProvider(slug)` is currently invalidated. Since `StorePage` is alive in the router stack underneath the product detail view, its active subscription to `storeProductsProvider` retains the pre-purchase list of products. Furthermore, `StoreRepository` retains in-memory cached responses in its `_productCache` map. As a result, when the user navigates back to the store, the purchased product is still visible until a manual pull-to-refresh is executed.

## Goals / Non-Goals

**Goals:**
- Automatically clear `StoreRepository` in-memory caches and invalidate `storeProductsProvider` and `storeCategoriesProvider` upon successful purchase in both `ProductDetailScreen` and `ProductInstallmentSheet`.
- Invalidate `courseListProvider` to ensure enrolled study courses are synchronized.
- Ensure automated widget tests verify the cache clearing and provider invalidation on payment success.

**Non-Goals:**
- Modifying backend endpoints or changing payment gateway integration logic.
- Altering the UI presentation of the store list or product detail pages.

## Decisions

- **Direct Invalidation & Cache Eviction in Success Handlers**:
  - *Rationale*: Calling `ref.read(storeRepositoryProvider).clearAll()`, `ref.invalidate(storeProductsProvider)`, and `ref.invalidate(storeCategoriesProvider)` directly inside the `PaymentResultStatus.success` block ensures immediate and deterministic cache clearing.
  - *Alternatives considered*: Adding a global event bus or stream listener for payment events. Rejected as unnecessary indirection since payments are triggered explicitly in these two locations.
- **Payment Screen Navigation Decoupling**:
  - *Rationale*: Popping `PaymentProcessingScreen` with a `redirectRoute` in `PaymentResult` allows caller screens to execute eviction and invalidation before triggering top-level navigation (`context.go`).


## Risks / Trade-offs

- **[Risk] Re-fetching network data when returning to store**:
  - *Mitigation*: Re-fetching product data from the server upon store tab visit is the exact intended behavior to reflect the updated purchase state without stale cache.
