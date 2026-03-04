## Why

The LMS needs a dedicated screen for studying text-based lessons with support for rich content formats (headings, paragraphs, images, lists, and callouts). This screen is essential for providing a comprehensive learning experience beyond just video content.

## What Changes

- Introduce `LessonDetailScreen` to render structured lesson content.
- Implement a content rendering system for `LessonContent` types: `heading`, `paragraph`, `image`, `list`, `callout`.
- Add a sticky header with a back button, bookmark/download actions, and a reading progress bar.
- Support lesson metadata display (subject, lesson number, duration).
- Implement navigation between lessons (Previous/Next).
- Ensure responsive layout for different screen sizes.
- *Note: Video lessons, assessments, and tests are excluded from this specific capability.*

## Capabilities

### New Capabilities
- `lms-lesson-detail`: Rendering and navigation for text-based LMS lessons involving rich content formats.

## Impact

- New screen in the LMS flow.
- Integration with the curriculum data layer (lessons and progress).
- Potential impact on navigation routes.
