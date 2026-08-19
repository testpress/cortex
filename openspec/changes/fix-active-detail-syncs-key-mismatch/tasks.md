## 1. Unify Lock Key in Repository

- [x] 1.1 In `packages/courses/lib/repositories/course_repository.dart`'s `watchCourse` method, define `final lockKey = 'detail_$courseId';`
- [x] 1.2 Replace references to `_activeDetailSyncs[courseId]` and `_activeDetailSyncs.containsKey(courseId)` with `_activeDetailSyncs[lockKey]`

## 2. Verification

- [x] 2.1 Run analysis or build checks on `packages/courses` to ensure compilation is clean and no lint errors are introduced.
