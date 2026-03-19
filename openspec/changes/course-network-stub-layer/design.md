## Context

`CourseRepository` currently depends on `DataSource`, and course screens consume repository streams. To enable parallel work between course-list and course-detail API integration, we need a single network service class introduced first so both contributors build on one shared entry point.

## Goals / Non-Goals

**Goals:**
- Introduce `CourseApiService` with stable read-only method signatures.
- Provide DI wiring via Riverpod provider.
- Keep existing runtime flow unchanged to minimize regression risk.

**Non-Goals:**
- No endpoint URL wiring.
- No response mapping implementation.
- No migration of repository from `DataSource` in this change.

## Decisions

- Create `CourseApiService` in `packages/courses/lib/network/course_api_service.dart`.
Rationale: keeps course-specific networking inside the courses package and avoids a global god-object.

- Add a top-level provider `courseApiServiceProvider` using `dioProvider`.
Rationale: aligns with existing auth/profile service composition and keeps injection consistent.

- Implement stubs by throwing `UnimplementedError` with method-specific messages.
Rationale: prevents accidental runtime use while giving clear TODO points for both parallel contributors.

## Risks / Trade-offs

- Risk: A stub could be called accidentally at runtime.
Mitigation: explicit `UnimplementedError` messages and no repository wiring in this change.

- Risk: Method contract may need small changes once backend schema is finalized.
Mitigation: keep stubs read-only and narrow to known flows (`courses`, `course`, `chapters`, `lessons`).
