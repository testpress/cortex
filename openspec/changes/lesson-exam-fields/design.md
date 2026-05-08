## Context

To enable launching exam attempts from the course player lesson view, we need to expose the exam slug and the API attempts URL on the lesson itself. This requires adding nullable `attemptsUrl` and `slug` fields to the `LessonsTable` database, the `LessonDto` data model, and the `Lesson` domain model.

## Goals / Non-Goals

**Goals:**
- Add `attemptsUrl` and `slug` fields to the offline database schema.
- Update data models and domain mappers to pass these fields seamlessly across packages.
- Regenerate the local database database models to avoid build errors.

**Non-Goals:**
- Implement any API requests or network calls to start attempts or fetch attempts.
- Modify any exam-player or exam-overview screen UI.

## Decisions

### Decision: Native Drift Database Migration (Nullable Fields)
We decided to add `attemptsUrl` and `slug` as nullable text columns to the existing `LessonsTable`. Because they are nullable, we do not need complex manual migration logic; Drift can automatically handle schema updates on app launch for nullable fields.

### Decision: Add `toDto()` on domain `Lesson`
The domain `Lesson` inside `packages/courses` is the main entity consumed by the courses UI. Adding a helper `toDto()` method allows us to easily convert a `Lesson` back to a `LessonDto` when transitioning to the exams package router branches.

## Risks / Trade-offs

- **Risk**: Database drift regeneration issues during active development.
- **Mitigation**: Ensure a full build_runner build runs to regenerate all generated models correctly.
