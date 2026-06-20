## Why

The `PaidActiveHomeScreen` dashboard layout is controlled by a `isBannerPresent` "God Flag" that forks the entire widget list into two hardcoded branches (`// Brilliant specific order` and `// Standard order`), causing duplicated widget declarations, a URL string hack (`isBrilliantPala`), and inconsistent widget ordering across clients. The user's name visibility is also uncontrolled—it appears everywhere regardless of the Profile tab config.

## What Changes

- Remove the `// Brilliant specific order` and `// Standard order` `if/else` fork from `PaidActiveHomeScreen` and replace with a single, unified widget list.
- The widget order is fixed as: Contextual Hero → Today's Schedule → Lesson Cards → Updates & Announcements → Study Momentum → Top Learners → Quick Access.
- Remove the hardcoded `isBrilliantPala` URL string check that was used to hide Study Momentum; show it for all clients.
- Conditionally hide the user's name in `InstituteBanner` (top-right) when `AppConfig.showProfileTab` is `true`.
- Conditionally show the user's name in `HomeGreetingSection` (main body greeting) when `AppConfig.showProfileTab` is `true`.
- When no banner logo is configured (`isBannerPresent` is false), show the actual institute name from `InstituteSettings.current?.name` as the `DashboardHeader` title instead of the generic `homeHeaderTitle` localization string.

## Capabilities

### New Capabilities
- `dashboard-username-visibility`: Controls whether the user's name is shown in the dashboard header/greeting based on the `showProfileTab` config flag.

### Modified Capabilities
- `lms-home-paid-active`: Dashboard layout order and widget conditional logic is changing.
- `institute-banner`: User info visibility in the banner is now conditional.

## Impact

- `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart` — Main refactoring target.
- `packages/core/lib/widgets/institute_banner.dart` — User info visibility change.
- `packages/courses/lib/widgets/greeting_section.dart` — `showName` parameter may need to be added.
- No API changes. No new dependencies. No breaking public widget API changes.
