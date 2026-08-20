## 1. Unify Lock Key in Repository

- [x] 1.1 In `packages/courses/lib/repositories/course_repository.dart`'s `watchCourse` method, define `final lockKey = 'detail_$courseId';`
- [x] 1.2 Replace references to `_activeDetailSyncs[courseId]` and `_activeDetailSyncs.containsKey(courseId)` with `_activeDetailSyncs[lockKey]`

## 2. Fix copyWith in Search State

- [x] 2.1 In `packages/courses/lib/providers/course_list_provider.dart`'s `CourseSearchState.copyWith` signature, set `Object? error = const Object(),`
- [x] 2.2 In the method body, set `error: identical(error, const Object()) ? this.error : error,`

## 3. Verification

- [x] 3.1 Run analysis or build checks on `packages/courses` to ensure compilation is clean and no lint errors are introduced.
- [x] 3.2 Add/run unit tests if applicable, or verify that copyWith preserves error state when not passed, and clears error state when null is explicitly passed.

