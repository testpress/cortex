## Why

Currently, there is no centralized discussion system within the LMS courses. Students and instructors lack a platform to interact, ask questions, and share insights directly in the course context. Implementing a discussion forum will increase engagement and provide a structured knowledge base for each course. Existing data structures were previously coupled to specific participant types, which we must now generalize.

## What Changes

We are refactoring the Forum infrastructure and integrating new UI screens. This includes:
- The system SHALL migrate database tables for threads and comments to support social stats.
- The system SHALL upgrade to Generic authorship (Name/Avatar strings) across DTOs and Repos.
- The UI SHALL introduce immersive, non-Material views for selecting courses and viewing discussion lists.
- The system SHALL implement course-scoped discussion threads with metadata and social statistics.
- The system SHALL support status badges for answered and unanswered threads.
- The system SHALL enable navigation between courses and their respective discussion lists.

## Capabilities

### New Capabilities
- `forum-post`: Course-scoped discussion threads with snippet previews, author metadata, social stats, and status badges (Answered/Unanswered).

### Modified Capabilities
- None

## Impact

- `packages/core`: Refactored Drift tables (`ForumThreadsTable`, `ForumCommentsTable`), and DTOs (`ForumThreadDto`, `ForumCommentDto`).
- `packages/forum`: New standalone domain module encapsulating the `ForumRepository`, providers, widgets, and full screen implementations.
- `app`: Global routing integration to the new forum package.
- `packages/core/lib/l10n`: Comprehensive forum-specific localization keys for EN, ML, and AR.
