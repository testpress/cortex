## 1. Core API & DTO Setup

- [x] 1.1 Extend LiveClassStatus enum to support cancelled status
- [x] 1.2 Implement paginated response parsing in LiveClassDto
- [x] 1.3 Implement DataSource.getLiveClasses signature and http/mock implementations

## 2. Caching & Repository Setup

- [x] 2.1 Create LiveClassesRepository to sync data into Drift SQLite database table
- [x] 2.2 Register liveClassesRepositoryProvider in repository_providers.dart

## 3. Riverpod State Management

- [x] 3.1 Create LiveStreamList stream notifier in live_stream_provider.dart

## 4. UI & Navigation Layout

- [x] 4.1 Create LiveStreamListScreen with tab filters
- [x] 4.2 Create LiveStreamCalendarView using syncfusion_flutter_calendar
- [x] 4.3 Create LiveStreamCard with status color decorations
- [x] 4.4 Add 'Live Classes' option to DashboardDrawer

## 5. Accessibility & WCAG Compliance

- [x] 5.1 Wrap scrollable lists in AppSemantics.scrollableList()
- [x] 5.2 Expand custom switch toggle hit target area to 48x48dp
- [x] 5.3 Migrate status badge to AppText core primitive

## 6. GoRouter Navigation Setup

- [x] 6.1 Register LiveStreamListScreen in routes configuration
- [x] 6.2 Navigate to Live Classes using GoRouter context APIs instead of root navigator push

## 7. Localization

- [x] 7.1 Define localized keys in app localization arb files
- [x] 7.2 Replace all hardcoded strings with localized variables

## 8. Motion Preferences Integration

- [x] 8.1 Integrate MotionPreferences curve and duration in the switch toggle animation

## 9. Riverpod CodeGen Migration

- [x] 9.1 Migrate isSyncingInitialPageProvider and liveStreamSyncErrorProvider to @riverpod notifiers

## 10. Dependency Justification

- [x] 10.1 Add justification comments for syncfusion_flutter_calendar and timezone dependency overrides in pubspecs
