## Context

Cortex is a white-labeled Flutter app that needs support for video conference lesson types (such as Zoom). This design focuses on parsing, persisting, and mapping the metadata returned by the API so that it can be displayed on a debug lobby page before executing the native SDK integration.

---

## Goals / Non-Goals

**Goals:**
*   Parse Zoom conference metadata (`conference_id`, `password`, `access_token`, `state`, `join_url`) from the API.
*   Persist this metadata locally using a SQLite database (Drift).
*   Propagate fields from DTOs to domain models and providers.
*   Fix all exhaustive switch statements to handle the new `LessonType.videoConference` enum value.
*   Build a lobby UI displaying meeting details for debugging.

**Non-Goals:**
*   Integrating the Zoom Video SDK native binaries (`mobilertc` / `sqlite3_key`).
*   Implementing the native MethodChannel bridge layer.

---

## Decisions

### Decision 1: Extend SQLite Schema (`LessonsTable`)

We add three text columns (`conferenceId`, `password`, `accessToken`) to `LessonsTable`. We bump `schemaVersion` to `2` in `app_database.dart` and provide an upgrade migration path to avoid erasing existing offline databases.

### Decision 2: Model & Provider Mapping

We update the `Lesson` domain model and mapping layers (`lesson_detail_provider.dart`, `chapter_detail_provider.dart`, and `course_repository.dart`) to ensure the fields propagate correctly from database rows and DTOs to the UI.

### Decision 3: Exhaustive Match Routing

Adding `videoConference` to the `LessonType` enum requires matching it in all switches over `LessonType` across the app (routing in lists, icons, themes, and detail orchestration) to comply with Dart 3 exhaustive matching.

### Decision 4: Debug Lobby UI

We implement a lobby screen in `VideoConferenceViewer` displaying start datetime, duration, provider, meeting ID, passcode, access token, and state to verify the data parses and persists correctly.
