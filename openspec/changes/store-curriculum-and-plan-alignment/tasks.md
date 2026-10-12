## 1. Course Scoping in Store Detail Screen

- [x] 1.1 Compute plan course IDs and filter base curriculum courses in `product_detail_screen.dart` with fallback for pure bundle products.
- [x] 1.2 Pass scoped curriculum courses to the curriculum tab renderer and update course availability check (`hasCourse`).


## 2. Subscription Plan Sheet Redesign

- [x] 2.1 Refactor `ProductSubscriptionSheet` layout to group duration tiers under distinct `SubscriptionPlanDto` cards.
- [x] 2.2 Render plan titles, descriptions, and bundled course badge chips mapped from `plan.courseIds` against `product.coursesDetails`.
- [x] 2.3 Render duration and pricing radio options with strike-through pricing under each plan card.
- [x] 2.4 Support unselected initial state when multiple plans exist, and update CTA to proceed once a plan duration is selected.

## 3. Store Course Curriculum & Chapter Tree

- [x] 3.1 Implement auto-disposing in-memory `storeCourseChaptersProvider` in `store_providers.dart`.
- [x] 3.2 Update `ProductExpandableCourseCard` to watch `storeCourseChaptersProvider` when expanded.
- [x] 3.3 Render chapter tree list tiles with expandable caret icons and skeleton shimmer loading state.
- [x] 3.5 Refactor `StoreChapterTile` to remove redundant `allChapters` parameter and rely directly on `childrenByParentId`.
- [x] 3.6 Unify duplicate chapter skeleton between `product_expandable_course_card.dart` and `store_chapter_tile.dart` using design tokens and named constants.

## 4. Testing & Verification

- [x] 4.1 Update and add widget tests for curriculum course scoping in `product_detail_screen_test.dart`.
- [x] 4.2 Add widget tests for `ProductSubscriptionSheet` verifying plan cards, course badges, and plan detail selection.
- [x] 4.3 Add widget tests for `ProductExpandableCourseCard` verifying chapter tree expansion, loading states, and error handling.
- [x] 4.4 Run full test suite across `packages/courses` and `packages/core` to verify no regressions.
