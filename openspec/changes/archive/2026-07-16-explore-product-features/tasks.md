## 1. Network Layer

- [x] 1.1 Add check-out endpoints (`createOrder`, `applyCoupon`, `getInstallmentPlans`) to `DataSource`
- [x] 1.2 Expose endpoints through `ExploreRepository`

## 2. State Management

- [x] 2.1 Create `ProductDiscountNotifier` for caching draft orders and handling coupon application state
- [x] 2.2 Create Providers for fetching installment plans

## 3. UI Components (BottomSheet Actions)

- [x] 3.1 Implement `ProductDiscountSheet` for applying coupons
- [x] 3.2 Implement `ProductInstallmentSheet` for selecting installment plans
- [x] 3.3 Ensure both sheets rely purely on `packages/core/core.dart`

## 4. Product Detail Screen Refactor

- [x] 4.1 Implement `ProductExpandableCourseCard` for the curriculum tab
- [x] 4.2 Restructure `ProductDetailScreen` to support multiple tabs
- [x] 4.3 Add Buy Now and Installments CTAs
- [x] 4.4 Extract all strings to `packages/core/lib/l10n/*.arb`
