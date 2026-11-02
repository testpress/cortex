# Implementation Tasks: Native Store Faculty Showcase

## 1. Data Model & Localization

- [x] 1.1 Implement `ProductFacultyDto` and `FacultyTeachingDto` in `packages/core/lib/data/models/store_models.dart` and add `faculty: List<ProductFacultyDto>` to `ProductDto`.
- [x] 1.2 Add localized keys in `packages/core/lib/l10n/` across English, Arabic, Malayalam, and Tamil (`storeMeetYourFaculty`, `storeYearsTeaching`, `storeIntroVideo`, `storeFacultyProfile`, `storeHighlights`, `storeQualifications`, `storeAbout`, `storeTeachesInThisProduct`, `storeTaughtBy`, `storeTaughtByAndMore`, `storeShowFewer`, `storeShowAllFaculty`, `storeNowShowing`, `storeWatchIntro`) and generate localization delegates.

## 2. Native UI Components & Accessibility Compliance

- [x] 2.1 Implement `ProductFacultySummary` in `packages/courses/lib/widgets/store/product_faculty_summary.dart` with avatar cluster, text truncation, `AppSemantics.button`, and ≥ 48dp touch target.
- [x] 2.2 Implement `ProductFacultySection` in `packages/courses/lib/widgets/store/product_faculty_section.dart` with `ProductFacultyCard`, expand/collapse threshold (> 4 instructors), and `AppSemantics.header`.
- [x] 2.3 Implement `FacultyProfileScreen` in `packages/courses/lib/screens/store/faculty_profile_screen.dart` with neutral `AppHeader`, 48×48dp back navigation button, 16:9 intro video player, credentials layout, and multi-course switcher with 48dp min touch targets.

## 3. Product Detail Screen Integration

- [x] 3.1 Integrate `ProductFacultySummary` and `ProductFacultySection` into `ProductDetailScreen` in `packages/courses/lib/screens/store/product_detail_screen.dart`, navigating to `FacultyProfileScreen` via `AppRoute` while strictly isolating and preserving existing checkout actions.

## 4. Testing & Verification

- [x] 4.1 Implement widget tests for `ProductFacultySummary`, `ProductFacultySection`, and `FacultyProfileScreen` in `packages/courses/test/`.
- [x] 4.2 Update `product_detail_screen_test.dart` to verify native faculty card rendering, tap navigation to `FacultyProfileScreen`, and back pop handling.
