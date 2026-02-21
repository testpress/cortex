# Tasks: LMS Paid Active User Home Screen (`lms-home-paid-active`)

## 1. Data Layer & Preparation

- [x] 1.1 Create mock data for `PaidActiveHome` including classes, assignments, and test data in `packages/courses/lib/data/mock_data.dart`
- [x] 1.2 Implement Riverpod providers for dashboard data (`todayClassesProvider`, `pendingAssignmentsProvider`, `studyMomentumProvider`) in `packages/courses/lib/providers/`

## 2. Shared Dashboard Components

- [x] 2.1 Implement `AppCarousel` with dot indicators and "peek" behavior in `packages/core/lib/widgets/`
- [x] 2.2 Implement `GreetingSection` with dynamic time-based messages
- [x] 2.3 Implement `HeroBannerCarousel` and `ContextualHeroCard` for primary top-page calls-to-action
- [x] 2.4 Implement `PromotionalBanners` for updates and announcements
- [x] 2.5 Implement `QuickAccess` grid widget with hover effects
- [x] 2.6 Implement `TopLearnersSection` with leaderboard carousel and avatar rendering
- [x] 2.7 Implement `DashboardHeader` top app-bar with hamburger menu base (menu implementation separate)

## 3. TodaySnapshot Implementation

- [x] 3.1 Implement base `TodaySnapshot` container with smart grouping logic as defined in specs
- [x] 3.2 Implement `ClassCard` component for "Now & Next" and "Later Today"
- [x] 3.3 Implement `AssignmentCard` component with segmented progress bar
- [x] 3.4 Implement `TestCard` component with importance badges
- [x] 3.5 Verify carousel behavior and empty states for each snapshot section

## 4. StudyMomentum Implementation

- [x] 4.1 Implement `ActivityStrip` with intensity-based color mapping
- [x] 4.2 Implement `LearningStatsGrid` for lessons, tests, and assessments
- [x] 4.3 Implement `SubjectInsightsCard` for performance highlights
- [x] 4.4 Verify dark mode adaptation for all momentum visualizations

## 5. Screen Assembly & Routing

- [x] 5.1 Create `PaidActiveHomeScreen` using `CustomScrollView` in `packages/courses/lib/screens/`
- [x] 5.2 Integrate all dashboard components with Riverpod providers
- [x] 5.3 Handle loading and error states for dashboard data
- [x] 5.4 Update `home` branch in `AppRouter` to use `PaidActiveHomeScreen`
- [x] 5.5 Final visual pass and lint fixes
- [x] 5.6 Parity verification and exact styling alignment with Figma Design specifications (padding, borders, dividers, colors)
