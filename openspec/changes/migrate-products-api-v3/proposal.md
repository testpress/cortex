## Why

The Products API is currently on `/api/v2.4/products/`, which uses a legacy `prices` + `has_coupons` model that no longer reflects the backend's actual discount and subscription plan architecture. `has_coupons` is backed by a deprecated `Offer` table and silently returns `false` for all modern discounts, meaning discount entry points are incorrectly hidden. Migrating to v3 aligns the app with the active data model and unblocks subscription tier selection, automatic user-specific discounts, and accurate installment CTA logic.

## What Changes

- **BREAKING**: Replace `/api/v2.4/products/` list and detail endpoints with `/api/v3/products/` and `/api/v3/products/{lookup}/`
- **BREAKING**: Remove `prices: List<PriceDto>` from `ProductDto`; replace with `planIds: List<int>` pointing to sideloaded `SubscriptionPlanDto`
- **BREAKING**: Remove `hasCoupons` from `ProductDto` (field not present in v3)
- Add `ProductImageDto` (structured `original`/`medium`/`small`); replace flat `image: String?` with `images: List<ProductImageDto>`
- Add `SubscriptionPlanDto` and `PlanDetailDto` models (sideloaded in v3 list response)
- Add `UserInstallmentPlanDto`; type `InstallmentPlansResponseDto.userInstallmentPlans` from `List<dynamic>` to `List<UserInstallmentPlanDto>`
- Add `OrderItemDto` with `price` and `priceBeforeDiscounts`; embed in `OrderDto.orderItems`
- Extend `createOrder` to accept optional `planDetailId` and `installmentPlanId`
- Update `StoreProductsResponseDto` to parse new sideloaded envelope (`categories`, `plans`, `plan_details`, `product_tags`, `subscription_plan_courses`)
- Coupon input on checkout: always visible (removing former `hasCoupons` gate)
- Add "Pay Next Installment" CTA branch when `userInstallmentPlans` has an active plan
- Add subscription duration selector UI (chips) on Product Detail for products with `planIds`
- Show auto-applied discount savings banner on checkout when `orderItem.priceBeforeDiscounts > orderItem.price`

## Capabilities

### New Capabilities
_(None — all affected features already have specs; changes are requirement updates to existing capabilities.)_

### Modified Capabilities
- `store-discovery`: Products list endpoint changes from `/api/v2.4/products/` to `/api/v3/products/`; sideloaded envelope shape changes
- `store-checkout`: `has_coupons` gate removed; coupon input always shown; auto-applied user discount banner added; `createOrder` payload extended for `plan_detail_id` / `installment_plan_id`
- `store-installments`: `userInstallmentPlans` now typed; "Pay Next Installment" CTA added when active plan exists
- `store-purchasing`: Subscription plan + tier selection is now wired to real `planIds` / `planDetailIds` from v3 response

## Impact

- `packages/core/lib/network/api_endpoints.dart` — endpoint strings updated
- `packages/core/lib/data/models/store_models.dart` — model additions and breaking field changes
- `packages/core/lib/data/sources/http_data_source.dart` — parser and method signature changes
- `packages/courses/lib/repositories/store_repository.dart` — `createOrder` signature
- `packages/courses/lib/providers/store_providers.dart` — notifier state extended
- `packages/courses/lib/screens/store/product_detail_screen.dart` — coupon gate removed, subscription selector + discount banner added
- `packages/courses/lib/widgets/store/product_installment_sheet.dart` — "Pay Next Installment" branch
- `packages/courses/test/` — test fixtures updated to remove `hasCoupons`
