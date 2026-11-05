## Why

Students purchasing products or subscription plans need clear transparency on what perks and benefits they receive (such as live doubt clearing, mentorship, printed notes, or test series access). While the backend has merged API v3 support exposing product benefits and plan-level benefit mappings, the mobile app currently only presents course bundles and prices. Introducing product benefits and plan comparison helps students understand the value proposition, compare tiers side-by-side, and choose the right plan with confidence.

## What Changes

- Add `ProductBenefitDto` and integrate `benefits` and `hasProductSubscriptionPlans` into `ProductDto`.
- Update `SubscriptionPlanDto` to include `benefitIds` and `benefits`.
- Display a dedicated "What you get" benefits section on `ProductDetailScreen` for products that define benefits.
- Enhance `ProductSubscriptionSheet` to display benefits included in each subscription plan and highlight differences across plans.
- Update `MockDataSource` and add unit tests verifying serialization and UI presentation.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `store-store`: Display product benefits ("What you get") on the product detail screen for products defining benefits.
- `store-purchasing`: Display included benefits per subscription plan in the plan selection and comparison bottom sheet so students can compare perks between tiers.

## Impact

- **Models**: `packages/core/lib/data/models/store_models.dart` (`ProductBenefitDto`, `SubscriptionPlanDto`, `ProductDto`).
- **Data Source & Mocks**: `packages/core/lib/data/sources/mock_data_source.dart`.
- **UI Components**:
  - `packages/courses/lib/screens/store/product_detail_screen.dart` (Product benefits section).
  - `packages/courses/lib/widgets/store/product_subscription_sheet.dart` (Plan benefits list and inclusion comparison).
- **Localization**: Add strings for benefits, inclusions, and plan comparison in `packages/core/lib/l10n/app_en.arb`.
- **Tests**: `packages/core/test/data/models/product_dto_test.dart`, `packages/courses/test/widgets/store/product_subscription_sheet_test.dart`, and `packages/courses/test/screens/store/product_detail_screen_test.dart`.

