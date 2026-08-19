## Context

See [proposal.md](proposal.md) for the motivation of this change.

1. In `packages/courses/lib/repositories/course_repository.dart`:
   - `watchCourse` checks and writes to `_activeDetailSyncs` using `courseId` as the key.
   - `refreshCourseDetail` uses a `lockKey` of `'detail_$courseId'` on the exact same map.
2. In `packages/courses/lib/providers/course_list_provider.dart`:
   - `CourseSearchState.copyWith` takes an optional parameter `Object? error`.
   - The body executes `error: error`, replacing `this.error` with `null` when the optional parameter is omitted (which defaults to `null`).

## Goals / Non-Goals

**Goals:**
- Unify the synchronization lock key used for fetching course details in `CourseRepository`.
- Ensure concurrent calls to `watchCourse`'s network fallback and `refreshCourseDetail` are properly deduplicated under a single future.
- Fix `CourseSearchState.copyWith` so that omitting `error` preserves `this.error`, while passing `error: null` successfully clears it.

**Non-Goals:**
- Changing database structure or model logic.
- Rewriting provider lifecycles or UI rendering.

## Decisions

### Unify lock key to `'detail_$courseId'`
We will standardize on `'detail_$courseId'` as the synchronization lock key. 

*Rationale:*
`_activeDetailSyncs` is a repository-wide map shared across multiple methods. Explicitly namespace keys using the prefix `detail_` prevents any potential namespace collisions.

### Use identical() with const Object() as copyWith sentinel value
To differentiate between a parameter being omitted (defaults to fallback) vs explicitly passed as `null`, we will update the copyWith signature:
```dart
CourseSearchState copyWith({
  // ...
  Object? error = const Object(),
}) {
  return CourseSearchState(
    // ...
    error: identical(error, const Object()) ? this.error : error,
  );
}
```

*Rationale:*
This is a standard Dart pattern for handling nullable fields in `copyWith` methods without requiring heavy dependencies or verbose helper structures.

## Risks / Trade-offs

- **Risk:** Typo in key definition leading to syncs never completing/cleaning up.
  - **Mitigation:** We will extract the lock key format into a helper method or local variable to ensure the key used for query and removal is identical.

