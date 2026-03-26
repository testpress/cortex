## Why

The current `LessonContentItemDto` architecture is over-engineered for the project's needs. While it currently supports rich-text "atoms" (headings, paragraphs, etc.), the backend will exclusively provide single file URLs (e.g., S3 links) for PDF and Video lessons. Maintaining a complex, nested JSON structure for simple media links adds unnecessary complexity to the data layer, caching logic, and UI rendering.

## What Changes

- **REMOVE**: `LessonContentItemDto` data model and all associated rich-text atom types (heading, paragraph, callout, list, image). **BREAKING**
- **REMOVE**: `LessonContentItem` domain models and the atom-based rendering loop in `LessonDetailScreen`. **BREAKING**
- **MODIFY**: `LessonDto` to replace the `content` list with a single `contentUrl` string field.
- **MODIFY**: `LessonsTable` in the Drift database to replace the `contentJson` column with a dedicated `contentUrl` text column.
- **MODIFY**: `MockDataSource` to provide sample PDF and Video URLs instead of raw text atoms.
- **ADD**: A dedicated PDF viewer integration in the `courses` package to render lessons of type `pdf` using the new `contentUrl`.

## Capabilities

### New Capabilities
- `lesson-pdf-playback`: Ability to render remote PDF documents within the app using a dedicated viewer, replacing the current text-based mock reader.

### Modified Capabilities
- `packages/data-layer`: Shift from JSON-serialized content atoms to direct URL persistence for lessons.
- `packages/mock-data`: Update the mock data provider to supply realistic media URLs for all lesson types.
- `chapter-detail`: Update the lesson detail view to handle single-media playback (PDF/Video) instead of multi-part text rendering.

## Impact

- **Core Package**: Breaking changes to `LessonDto`, database schema migrations for `LessonsTable`, and updates to the `CourseRepository` mapping logic.
- **Courses Package**: Complete refactor of `Lesson` domain model and `LessonDetailScreen` to support the new URL-based playback flow.
- **API Contract**: Simplifies the expected backend response for lesson content to a single string URL.
