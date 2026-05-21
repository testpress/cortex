## Why

The Video screen currently displays hardcoded subtabs (Notes, Transcript, Ask Doubt, AI Support) regardless of whether the specific content has these features enabled. We need to integrate API-driven logic to dynamically show or hide these tabs based on the content's capabilities (like `enable_transcript`, `is_ai_enabled`, etc.) and handle the content states correctly (e.g., parsing `.vtt` files for transcripts, or rendering `.md` files for notes). This ensures a personalized and accurate user experience based on the backend data.

## What Changes

- Add new properties to the core content models (`LessonDto`, `Lesson`, etc.) to parse API fields: `enable_transcript`, `video_subtitle`, `is_ai_enabled`, and `ai_notes_url`.
- Update the API deserialization logic in `LessonDto._parseBase` and `LessonDto._parseVideoLesson`.
- Modify `VideoLessonDetailScreen` to dynamically render subtabs based on the lesson model flags.
- Introduce `VideoSubtabsRepository` to fetch external markdown notes and WebVTT transcripts using `Dio`, keeping `CourseRepository` pristine and isolating parsing operations.
- Implement UI for the "Transcript" tab to display "Transcription in progress" or parse and display `.vtt` content when completed.
- Implement UI for the "Notes" tab to fetch and render `.md` content using `ai_notes_url`.
- Make the "AI Support" tab visible only when `is_ai_enabled` is true.

## Capabilities

### New Capabilities
- `video-lesson-subtabs`: Dynamic rendering and state management of video lesson subtabs (Transcript, AI Notes, AI Support, Ask Doubt) based on API configuration.
- `vtt-parser`: Capability to fetch and parse `.vtt` (WebVTT) subtitle files for the transcript tab.
- `video-subtabs-repository`: A dedicated data repository to fetch and parse remote subtab contents (Markdown & WebVTT) off the main thread.

### Modified Capabilities
- `lesson-detail-real-api-source`: Updating the lesson detail API parser and models to include AI and transcript metadata fields (`enable_transcript`, `video_subtitle`, `is_ai_enabled`, `ai_notes_url`).

## Impact

- **Models**: `LessonDto`, `Lesson` will be modified to include new properties.
- **UI Screens**: `VideoLessonDetailScreen` will switch from a fixed `TabBar` to a dynamically built list of tabs based on content features.
- **Repositories**: Introduce `VideoSubtabsRepository` to handle data-fetching and WebVTT parsing logic.
- **Tab Views**: `TranscriptsTab` and `NotesTab` will be updated with actual data fetching and parsing logic. **Their Riverpod providers will be refactored to depend on `VideoSubtabsRepository` instead of directly executing raw `Dio` network calls.**
