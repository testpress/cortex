## 1. DTO Structural Flattening

- [x] 1.1 Remove `chapters` field from `CourseDto` in `packages/core/lib/data/models/course_dto.dart` and update constructor/copyWith.
- [x] 1.2 Update `CourseDto.fromJson` and `toJson` to remove nested list handling.
- [x] 1.3 Remove `lessons` field from `ChapterDto` in `packages/core/lib/data/models/chapter_dto.dart` and update constructor/copyWith.
- [x] 1.4 Update `ChapterDto.fromJson` and `toJson` to remove nested list handling.

## 2. Mock Data Adaptation

- [x] 2.1 Update `MockDataSource.getCourses()` in `packages/core/lib/data/sources/mock_data_source.dart` to return flat `CourseDto` objects.
- [x] 2.2 Update `MockDataSource.getChapters()` and specific chapter sub-methods to return flat `ChapterDto` objects.
- [x] 2.3 Refactor internal mock data helpers to ensure all collections are returned via their respective `get...` methods.

## 3. Propagation & Cleanup

- [x] 3.1 Update `CourseRepository` in `packages/courses/lib/repositories/course_repository.dart` to ensure it only uses ID-based fetching.
- [x] 3.2 Verify project-wide compilation and fix any broken UI references.
