## Context

See `proposal.md — Why` for motivation. The existing store layer parses a v2.4 sideloaded envelope (`prices` + `courses`). The v3 envelope replaces `prices` with `plans` + `plan_details`, removes `has_coupons`, and changes the product image field from a flat string to a list of image objects. `OrderDto` does not model `order_items`, making auto-discount rendering impossible. `userInstallmentPlans` is stored untyped (`List<dynamic>`) and never read.

## Goals / Non-Goals

**Goals:**
- Swap product list and detail endpoints to v3 with full parser coverage
- Model all new sideloaded entities (`SubscriptionPlanDto`, `PlanDetailDto`, `UserInstallmentPlanDto`, `OrderItemDto`)
- Remove `hasCoupons` gating; make coupon input always available
- Enable subscription tier selection on Product Detail
- Enable "Pay Next Installment" CTA from typed `userInstallmentPlans`
- Surface auto-applied discount savings banner on checkout

**Non-Goals:**
- Migrating order or payment gateway endpoints (those are already on v3)
- Any changes to the categories endpoint (stays on `/api/v2.5/products/categories/`)
- Backend changes

## Decisions

### D1 — Thumbnail resolution: computed getter on `ProductDto`
`ProductCard` accesses `product.image` directly. Rather than refactoring the widget, add a `thumbnailUrl` computed getter to `ProductDto` that returns `images.firstOrNull?.medium ?? images.firstOrNull?.original`. Widgets switch from `product.image` to `product.thumbnailUrl`. This shields all consumers from the field rename.

**Alternative**: Keep `image` as a nullable field set at parse time — rejected because it adds a mutable field to an otherwise immutable DTO and duplicates data.

### D2 — Plan resolution: attach resolved objects to `ProductDto`
`StoreProductsResponseDto.fromJson` already resolves and attaches sideloaded `courses` and `prices` to each `ProductDto`. We extend this pattern: resolve `planIds → List<SubscriptionPlanDto>`, each carrying their resolved `List<PlanDetailDto>`. `ProductDto` gains `plans: List<SubscriptionPlanDto>` (empty for simple products).

**Alternative**: Resolve plans in the repository layer — rejected because the resolution is a pure data-mapping concern and the repository would need to re-read raw JSON.

### D3 — `createOrder` extended with optional parameters
`HttpDataSource.createOrder(String slug)` gains two optional named parameters: `planDetailId: int?` and `installmentPlanId: int?`. Both are omitted from the JSON body when null. The `DataSource` interface and `StoreRepository` signatures are updated accordingly. The `ProductDiscountNotifier` carries selected `planDetailId`/`installmentPlanId` state and passes them through at order creation.

**Alternative**: Separate methods for each order type — rejected because the endpoint is the same (`POST /api/v3/orders/`) and the only difference is payload fields; separate methods would duplicate boilerplate.

### D4 — `OrderItemDto` parsed from response
`OrderDto` gains `orderItems: List<OrderItemDto>` parsed from `json['order_items']`. `OrderItemDto` contains `id`, `product` (slug), `price`, and `priceBeforeDiscounts` (from `price_before_discounts`). The savings banner compares these two fields; if equal, no banner is shown.

### D5 — `userInstallmentPlans` typed as `List<UserInstallmentPlanDto>`
`UserInstallmentPlanDto` models the fields needed for the CTA: `id`, `installmentPlanId`, `paidInstallmentCount`, `nextDueAmount`, `status`. `ProductInstallmentSheet` checks `userInstallmentPlans.isNotEmpty` first; if true, renders the "Pay Next Installment" path.

## Risks / Trade-offs

- **[Risk] v3 list response envelope shape differs from current parser** → Ensure `StoreProductsResponseDto.fromJson` is updated atomically with the endpoint change. Do not swap the endpoint without updating the parser in the same commit — an endpoint-only swap will produce empty product lists silently.
- **[Risk] Tests use `hasCoupons: true/false` in fixtures** → Remove the field from all fixture constructors during the DTO change. The Dart compiler will flag mismatches; no runtime risk.
- **[Risk] Subscription tier selector is new UI with no prior pattern** → Keep it as a simple chip-row on the detail screen for this change. A dedicated bottom-sheet can follow later.

## Migration Plan

1. DTO layer changes (models only, no endpoint change) — safe to ship independently with no behavior change since v2.4 response is backward-compatible on overlapping fields.
2. Swap `ApiEndpoints.products` and `ApiEndpoints.product(slug)` to v3 — requires DTO changes to be shipped first.
3. UI changes (coupon visibility, subscription selector, discount banner) — require updated `OrderDto` / `ProductDto` fields to be in place.

Rollback: revert endpoint strings in `api_endpoints.dart` to v2.4 paths. No database or server-side changes.
