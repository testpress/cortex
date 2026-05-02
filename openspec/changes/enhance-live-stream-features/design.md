## Context

The current live stream implementation in `LessonDto` is broken for v2.4+ content API because it doesn't account for the nested `live_stream` object, leading to incorrect stream URLs and missing status flags. Additionally, the live lesson UI should remain stable by avoiding embedded chat rendering and keeping a simple video-first layout.

## Goals / Non-Goals

**Goals:**
- Fix `Live Stream` content type identification and parsing in `LessonDto`.
- Refactor `LessonDto` (DTO) and `Lesson` (Domain) models to include live-stream specific metadata.
- Map API statuses ("Running", "Upcoming", "Completed") to domain-level flags (`isRunning`, `isUpcoming`).
- Keep live viewer rendering chat-free to prevent WebView-related UX instability.

**Non-Goals:**
- Implementing any in-view live chat client/webview UI.
- Changing the underlying video playback technology (e.g., swapping players).

## Decisions

### 1. Robust Type Identification
Update `LessonDto._identifyLessonType` to check both the presence of the `live_stream` key and the value of `content_type` string.
- **Rationale**: Ensures "Live Stream" content is correctly identified even if the detailed object is temporarily missing or structured differently in list responses.

### 2. Nested Data Extraction in DTO
Modify `LessonDto._parseLiveStreamLesson` to deep-dive into the `live_stream` JSON object for `stream_url`, `status`, and `duration`.
- **Rationale**: Aligns with the v2.4+ API structure where live-specific data is encapsulated rather than flattened.

### 3. Domain Model Expansion
Update the `Lesson` domain model in `packages/courses` and the corresponding mapping logic in `CourseRepository`.
- **Rationale**: Exposes rich live-stream metadata to the UI layer in a type-safe manner.

### 4. Simplified Live Viewer
Render live lessons as a stable video-first experience with a non-interactive black filler area beneath the player, without embedding chat webviews.
- **Rationale**: Avoids mobile WebView focus/viewport issues and preserves consistent playback UX.

## Risks / Trade-offs

- **[Risk]** → Variation in status strings from the API (e.g., "running" vs "Live").
- **[Mitigation]** → Implement a case-insensitive status parser with broad keyword matching in `LessonDto`.
- **[Trade-off]** → Removing in-view chat reduces live interactivity.
- **[Rationale]** → Prioritizing stable playback and layout consistency is preferable to unstable embedded chat behavior in current scope.
