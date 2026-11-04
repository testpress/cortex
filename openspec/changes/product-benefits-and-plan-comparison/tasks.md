## 1. UI Components for Inline Plan Selection & Comparison (`packages/courses`)

- [x] 1.1 Create `ProductPlanCard` in `packages/courses/lib/widgets/store/product_plan_card.dart` rendering title, description, price, strike price, course count, benefit count (`X of Y benefits`), and radio indicator.
- [x] 1.2 Create `ProductPlanSection` in `packages/courses/lib/widgets/store/product_plan_section.dart` rendering duration pills and vertically stacked `ProductPlanCard`s.
- [x] 1.3 Create `ProductPlanComparisonSection` in `packages/courses/lib/widgets/store/product_plan_comparison_section.dart` rendering "Compare plans", segmented tabs (`[Basic] [Standard] [Premium]`), and Courses & What You Get checklists with ✓ and ✕ indicators.

## 2. Product Detail Screen Integration (`packages/courses`)

- [x] 2.1 Integrate `ProductPlanSection` and `ProductPlanComparisonSection` into `ProductDetailScreen` when `product.plans.isNotEmpty`.
- [x] 2.2 Wire two-way synchronization: tapping a plan card updates active plan and comparison tab; tapping a comparison tab selects that plan card and updates purchase price.
- [x] 2.3 Retain standalone "What you get" section for products without subscription plans (`product.plans.isEmpty && product.benefits.isNotEmpty`).

## 3. Localization & Styling (`packages/core`)

- [x] 3.1 Add localization strings for "Choose a plan", "Pick the plan that fits you and how long you need it.", "Compare plans", "{count, plural, =1{1 course} other{{count} courses}}", and "{count} of {total} benefits" across `app_*.arb`.
- [x] 3.2 Ensure full accessibility semantics, 48dp touch targets, and `Design.of(context)` dark/light theme token adherence.

## 4. Verification & Testing

- [x] 4.1 Add widget tests for `ProductPlanCard` and `ProductPlanSection`.
- [x] 4.2 Add widget tests for `ProductPlanComparisonSection` verifying segmented tabs and checklist switching.
- [x] 4.3 Add widget tests in `product_detail_screen_test.dart` verifying inline plan selection and two-way sync.
- [x] 4.4 Run `flutter analyze` and `flutter test` across `packages/core` and `packages/courses`.
