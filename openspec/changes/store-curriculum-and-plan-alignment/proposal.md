## Why

The mobile store page displays all bundled courses indiscriminately in the Curriculum tab with static count chips rather than real chapter and lesson contents. Additionally, subscription tier add-on courses are not visible inside the subscription plan selector, diverging from the web experience where the Curriculum displays the base course content tree and the Subscription modal reveals plan-specific course bundles.

## What Changes

- Scope the store product Curriculum tab to display the base product course(s), excluding courses bundled exclusively into subscription plans.
- Dynamically fetch and render course chapters and contents hierarchically in the store curriculum view instead of static count chips.
- Update the subscription plan selection bottom sheet to render distinct plan cards displaying the plan name, bundled course badges (mapped from `plan.courseIds`), and pricing/duration options, remaining unselected by default.

## Capabilities

### New Capabilities
*(None — no new standalone capabilities introduced.)*

### Modified Capabilities
- `store-curriculum`: Expandable course cards must load and display real chapters and lesson hierarchy instead of summary count badges; curriculum only includes product base courses.
- `store-purchasing`: Subscription plan selection sheet displays individual plan cards showing the plan name, bundled courses mapped from `plan.courseIds`, and duration options without pre-selection.

## Impact

- `packages/courses/lib/screens/store/product_detail_screen.dart`: Course filtering for curriculum tab.
- `packages/courses/lib/widgets/store/product_expandable_course_card.dart`: Interactive chapter tree and lesson rendering.
- `packages/courses/lib/widgets/store/product_subscription_sheet.dart`: Plan card layout with plan title, bundled course badges, and radio selection.
- `packages/courses/lib/providers/store_providers.dart`: In-memory chapter/curriculum provider for store preview.
- Unit and widget tests in `packages/courses/test/`.
