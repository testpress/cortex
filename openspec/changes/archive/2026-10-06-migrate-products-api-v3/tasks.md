## 1. DTO Layer & Data Models

- [x] 1.1 Update `ProductDto` with single resolved `image`, `planIds`, `plans`, and `thumbnailUrl` getter
- [x] 1.2 Remove deprecated `hasCoupons` field from `ProductDto` and update mock fixtures/usages
- [x] 1.3 Add `SubscriptionPlanDto` and `PlanDetailDto` models
- [x] 1.4 Add `OrderItemDto` model and add `orderItems` to `OrderDto`
- [x] 1.5 Add `UserInstallmentPlanDto` and update `InstallmentDto.userInstallmentPlans` from `List<dynamic>` to `List<UserInstallmentPlanDto>`
- [x] 1.6 Update `StoreProductsResponseDto.fromJson` to parse v3 sideloaded `plans` and `plan_details`, resolving them into `ProductDto.plans`

## 2. API Endpoints & Data Source Layer

- [x] 2.1 Update `ApiEndpoints.products` and `ApiEndpoints.product(slug)` to point to `/api/v3/products/`
- [x] 2.2 Update `HttpDataSource.createOrder` signature and implementation to accept optional `planDetailId` and `installmentPlanId`
- [x] 2.3 Update `DataSource` interface and `StoreRepository` order creation methods with optional plan IDs

## 3. UI Layer & State Management Updates

- [x] 3.1 Update `ProductCard` and detail widgets to consume `product.thumbnailUrl` instead of `product.image`
- [x] 3.2 Remove `hasCoupons` conditional gate in product detail and store screens; ensure promo code entry is always accessible
- [x] 3.3 Add subscription tier selection UI in `ProductDetailScreen` when `product.plans` is non-empty
- [x] 3.4 Update `ProductDiscountNotifier` and checkout flow to pass selected `planDetailId` / `installmentPlanId` to order creation
- [x] 3.5 Update `ProductInstallmentSheet` to display "Pay Next Installment" CTA when active `userInstallmentPlans` are present
- [x] 3.6 Add auto-applied discount savings banner in checkout sheet using `orderItems.priceBeforeDiscounts` vs `price`

## 4. Verification & Testing

- [x] 4.1 Update store model unit tests and fixture JSONs for v3 schema
- [x] 4.2 Verify product list and product detail parsing with unit/widget tests
- [x] 4.3 Run `dart analyze` across packages to ensure zero compiler warnings or broken usages
