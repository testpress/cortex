## Context

See [proposal.md](file:///Users/syedibrahim/workspace/flutter/cortex/openspec/changes/fix-active-detail-syncs-key-mismatch/proposal.md) for the motivation of this change.

In `packages/courses/lib/repositories/course_repository.dart`:
- `watchCourse` (lines 128–138) checks and writes to `_activeDetailSyncs` using `courseId` as the key.
- `refreshCourseDetail` (lines 243–261) uses a `lockKey` of `'detail_$courseId'` on the exact same `_activeDetailSyncs` map.

This creates a mismatch preventing active synchronizations from being correctly deduplicated when both methods execute concurrently.

## Goals / Non-Goals

**Goals:**
- Unify the synchronization lock key used for fetching course details in `CourseRepository`.
- Ensure concurrent calls to `watchCourse`'s network fallback and `refreshCourseDetail` are properly deduplicated under a single future.

**Non-Goals:**
- Changing database structure or model logic.
- Rewriting provider lifecycles or UI rendering.

## Decisions

### Unify lock key to `'detail_$courseId'`
We will standardize on `'detail_$courseId'` as the synchronization lock key. 

*Rationale:*
`_activeDetailSyncs` is a repository-wide map shared across multiple methods. Explicitly namespace keys using the prefix `detail_` prevents any potential namespace collisions if other detail-fetching routines are introduced in the future.

*Alternatives considered:*
- Standardizing on `courseId` (without prefix): Rejected because it is less descriptive and does not distinguish detail syncs from other potential course-level sync locks.

## Risks / Trade-offs

- **Risk:** Typo in key definition leading to syncs never completing/cleaning up.
  - **Mitigation:** We will extract the lock key format into a helper method or local variable to ensure the key used for query and removal is identical.
