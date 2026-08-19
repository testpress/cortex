## Why

1. `CourseRepository._activeDetailSyncs` is used in two places with inconsistent keys: `watchCourse` uses the bare `courseId`, while `refreshCourseDetail` uses `'detail_$courseId'`. Because they share the same dedup map but use different keys, a background fetch from `watchCourse` and a foreground call to `refreshCourseDetail` for the same course will not recognise each other, firing two concurrent network requests instead of one.
2. In `CourseSearchState.copyWith`, `error` is assigned as `error: error` without a fallback `?? this.error`. As a result, calling `copyWith` to update any other field (e.g. `isLoading: false` or `pagination`) will unintentionally reset the error state to `null`.

## What Changes

- Standardise `_activeDetailSyncs` key to `'detail_$courseId'` in `watchCourse`'s search-result fallback path (line ~129 of `course_repository.dart`)
- Update `CourseSearchState.copyWith` in `course_list_provider.dart` to preserve `this.error` if `error` parameter is not supplied, while still allowing the error to be explicitly cleared (set to `null`).

## Capabilities

### New Capabilities
<!-- None — this is a pure internal bug fix with no new spec-level behaviour -->

### Modified Capabilities
<!-- None — dedup is an implementation detail, not a spec-level requirement -->

> **Note:** This is a pure refactor / bug fix. No spec-level behaviour changes.
> `skip_specs: true` will be set in `.openspec.yaml`.

## Impact

- **Files:** 
  - `packages/courses/lib/repositories/course_repository.dart`
  - `packages/courses/lib/providers/course_list_provider.dart`
- **Scope:** Repository lock key update + `copyWith` parameter sentinel check
- **Risk:** Very low — no external contract changes

