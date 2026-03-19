## Why

Course API work is being split across parallel contributors for list and detail flows. A shared network service scaffold is needed now so both contributors can implement endpoints without creating conflicting class/file introductions later.

## What Changes

- Add a course network-layer service scaffold in `packages/courses` with read-only method stubs.
- Add a Riverpod provider for the course network service backed by the shared `dioProvider`.
- Keep current repository/data-source behavior unchanged for this step.
- Define method signatures only; no endpoint wiring or payload parsing in this change.

## Capabilities

### New Capabilities
- `course-network-service-layer`: Establishes a dedicated course API service contract and provider in the courses package to support parallel API implementation.

### Modified Capabilities
- `study-curriculum-list`: Document that the real API path can be introduced through a service layer without requiring immediate behavior change.

## Impact

- Affected code: `packages/courses/lib/network/*` and export surface updates in `packages/courses/lib/courses.dart`.
- APIs: no runtime behavior change, only new internal service API surface.
- Dependencies: reuses existing `dioProvider` from core.
