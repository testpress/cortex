## Why

Video conference lessons (such as Zoom sessions) need to be supported by the Cortex client. To prepare for this integration, we need to parse and persist all conference metadata (meeting ID, passcode, access token, state, join URL) from the API into the local SQLite database via Drift. We also need to map this metadata through the DTOs, domain models, and providers to the UI, and implement a debugging lobby page that displays these details cleanly.

---

## What Changes

*   **Database Schema (`packages/core`)**: Add `conferenceId`, `password`, and `accessToken` columns to `LessonsTable` and define the Drift database migration.
*   **Domain Models & Mappers (`packages/courses`)**: Update `Lesson` domain model, mapping providers (`lesson_detail_provider` and `chapter_detail_provider`), and repository database row conversions to handle the new Zoom fields.
*   **Lobby UI (`packages/courses`)**: Implement a debug lobby screen in `VideoConferenceViewer` that displays meeting details (Duration, Start Time, Provider, Meeting ID, Passcode, Access Token, and State) along with an "Attend Class" button.
*   **Routing & Exhaustive Switch Matching**: Fix pattern matching switch statements for `LessonType.videoConference` across list views, router, and the detail orchestrator.

---

## Capabilities

### New Capabilities
- `live-stream/conference-parsing`: Parse, persist, and display video conference metadata without native SDK links.

---

## Impact

*   **`packages/core`**: Updates lessons table scheme, database generation, and central router.
*   **`packages/courses`**: Updates domain models, detail providers, repository, orchestrator, list views, and introduces the conference lobby widget.
