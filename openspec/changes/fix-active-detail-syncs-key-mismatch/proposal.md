## Why

`CourseRepository._activeDetailSyncs` is used in two places with inconsistent keys: `watchCourse` uses the bare `courseId`, while `refreshCourseDetail` uses `'detail_$courseId'`. Because they share the same dedup map but use different keys, a background fetch from `watchCourse` and a foreground call to `refreshCourseDetail` for the same course will not recognise each other, firing two concurrent network requests instead of one.

## What Changes

- Standardise `_activeDetailSyncs` key to `'detail_$courseId'` in `watchCourse`'s search-result fallback path (line ~129 of `course_repository.dart`)
- No public API or provider interface changes — this is an internal guard fix

## Capabilities

### New Capabilities
<!-- None — this is a pure internal bug fix with no new spec-level behaviour -->

### Modified Capabilities
<!-- None — dedup is an implementation detail, not a spec-level requirement -->

> **Note:** This is a pure refactor / bug fix. No spec-level behaviour changes.
> `skip_specs: true` will be set in `.openspec.yaml`.

## Impact

- **File:** `packages/courses/lib/repositories/course_repository.dart`
- **Scope:** Single two-character change to the key string inside `watchCourse`
- **Risk:** Very low — no logic change, only consistency in the key used for map lookup
