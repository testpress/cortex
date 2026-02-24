## 1. Core Audit & Preparation

- [x] 1.1 Review `AppText` for missing semantic roles required for dense dashboard layouts.
- [x] 1.2 Finalize decision on 22px greeting mapping (Display vs Headline).

## 2. Widget Refactoring: High-Level Components

- [x] 2.1 Refactor `DashboardHeader` to use semantic `headline`.
- [x] 2.2 Refactor `HomeGreetingSection` to use semantic `display`/`headline`.

## 3. Widget Refactoring: Section UI

- [x] 3.1 Refactor `TodaySnapshot` headers and card typography to use `title`/`subtitle`/`bodySmall`.
- [x] 3.2 Refactor `StudyMomentumGrid` to use semantic roles for headers and atomic scale for stats.
- [x] 3.3 Refactor `TopLearnersSection` to use context-aware semantic roles for rankings and achievements.
- [x] 3.4 Refactor `ContextualHeroCard` and `PromotionalBanners` to use `headline`/`body`.

## 4. Verification

- [x] 4.1 Run `flutter analyze` on `courses` and `core` packages.
- [x] 4.2 Run `flutter test` on `courses` and `core` packages.
- [x] 4.3 Visual verification: Ensure semantic roles maintain the intended design hierarchy.
