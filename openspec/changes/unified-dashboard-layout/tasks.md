## 1. HomeGreetingSection — showName Parameter

- [x] 1.1 Add optional `showName` boolean parameter to `HomeGreetingSection` widget (default: `true` for backward compatibility)
- [x] 1.2 Conditionally render the user's name in the greeting text based on `showName`
- [x] 1.3 Verify greeting shows "Good Morning" only (no name) when `showName` is `false`

## 2. InstituteBanner — Conditional User Info

- [x] 2.1 Wrap the user name + enrollment ID block in `InstituteBanner` with `if (!AppConfig.showProfileTab)`
- [x] 2.2 Verify banner shows no user info when `showProfileTab` is `true`
- [x] 2.3 Verify banner shows user name + ID when `showProfileTab` is `false`

## 3. PaidActiveHomeScreen — Dynamic Header Title

- [x] 3.1 Compute `instituteName` from `InstituteSettings.current?.name` in `build()`
- [x] 3.2 Use `instituteName` as `DashboardHeader` title when non-empty; fall back to `L10n.of(context).homeHeaderTitle`

## 4. PaidActiveHomeScreen — Pass showName to Greeting

- [x] 4.1 Pass `showName: !dto.AppConfig.showProfileTab` to `HomeGreetingSection` in the standard layout (no banner)

## 5. PaidActiveHomeScreen — Unified Widget List

- [x] 5.1 Remove the `if (isBannerPresent) ... else ...` fork from the `AppScroll` children list
- [x] 5.2 Replace with a single unified list following the fixed order: Contextual Hero → Today's Schedule → Lesson Cards → Updates & Announcements → Study Momentum → Top Learners → Quick Access
- [x] 5.3 Remove the `isBrilliantPala` variable and its conditional usage entirely
- [x] 5.4 Verify `SizedBox.shrink()` fallbacks still work for empty data states (Updates, Momentum, Learners)

## 6. Widget Modularization (Newspaper Metaphor)

- [x] 6.1 Extract `DashboardHeader` logic into `widgets/dashboard_header_widget.dart`
- [x] 6.2 Extract `GreetingSection` logic into `widgets/greeting_section_widget.dart`
- [x] 6.3 Extract `TopCarouselSection` logic into `widgets/top_carousel_section_widget.dart`
- [x] 6.4 Extract `ContextualHeroSection` logic into `widgets/contextual_hero_section_widget.dart`
- [x] 6.5 Extract `TodayScheduleSection` logic into `widgets/today_schedule_section_widget.dart`
- [x] 6.6 Extract `LessonCardsSection` logic into `widgets/lesson_cards_section_wrapper.dart`
- [x] 6.7 Extract `AnnouncementsSection` logic into `widgets/announcements_section_widget.dart`
- [x] 6.8 Extract `StudyMomentumSection` logic into `widgets/study_momentum_section_widget.dart`
- [x] 6.9 Extract `TopLearnersSection` logic into `widgets/top_learners_section_widget.dart`
- [x] 6.10 Extract `QuickAccessSection` logic into `widgets/quick_access_section_widget.dart`
- [x] 6.11 Update `PaidActiveHomeScreen` to import all extracted widgets and remove inline classes

## 7. Verification

- [x] 7.1 Hot-reload and verify standard layout (no logo) shows institute name in header, greeting without name when profile tab enabled
- [x] 7.2 Hot-reload and verify banner layout shows banner without user info when profile tab enabled
- [x] 7.3 Verify widget order is consistent: Updates & Announcements appears above Top Learners
- [x] 7.4 Verify no regressions on clients that previously used the Brilliant-specific ordering
