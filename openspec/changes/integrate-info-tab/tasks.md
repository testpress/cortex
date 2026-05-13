## 1. Data Layer Enhancements

- [x] 1.1 Add `watchInfoCourses()` stream to `CourseRepository` in `packages/courses/lib/repositories/course_repository.dart`.
- [x] 1.2 Update `PaginatedResponseDto.fromJson` in `packages/core/lib/data/models/paginated_response_dto.dart` to map root-level tags to nested items.
- [x] 1.3 Remove `tagIds` from `CoursesTable`, `CourseDto`, and all repository mappings across the codebase.

## 2. UI Migration & Cleanup

- [x] 2.1 Update `InfoPage` in `packages/courses/lib/screens/info/info_page.dart` to consume the real Info courses stream and support pagination/pull-to-refresh.
- [x] 2.2 Refactor `InfoCourseDetailScreen` to display the standard Course -> Chapters -> Lessons hierarchy using existing curriculum widgets.
- [x] 2.3 Delete legacy models and mock data:
    - Remove `InfoCourse` and `InfoVideo` from `packages/courses/lib/models/info_models.dart`.
    - Remove `mockInfoCourses` and related providers from `packages/courses/lib/providers/info_providers.dart`.

## 3. High-Fidelity Loading & UX

- [x] 3.1 Implement `Skeletonizer` on the Info landing page to show structured loading states while courses are being fetched.
- [x] 3.1.1 Ensure Info skeleton cards render visible text-row bones (title + metadata) and maintain neutral contrast.
- [x] 3.2 Standardize Info card styling and semantics to match `CourseCard`.
- [x] 3.3 Implement immersive routing (hide bottom bar) for Info detail pages.
