## Context

The current `LessonContentItemDto` architecture is based on a "rich-text atom" model, designed to render content like a blog post (headings, paragraphs, images). However, the backend source of truth for lessons is now strictly defined as media-based (PDF or Video). Maintaining a complex JSON list for a single URL adds technical debt to the data layer and complicates UI rendering.

## Goals / Non-Goals

**Goals:**
- **Flatten Lesson Data**: Move from a `List<Content>` format to a single `contentUrl` string in `LessonDto` and `LessonsTable`.
- **Primary Media Rendering**: Implement a high-performance in-app PDF viewer for lessons of type `pdf`.
- **Architectural Cleanup**: Delete redundant DTOs (`LessonContentItemDto`) and domain models (`LessonContentItem`) that were only used for the rich-text Atoms.

**Non-Goals:**
- **Rich-Text Support**: We are explicitly removing support for "article-style" text lessons, as the backend will only provide PDF or Video content.
- **Legacy Migration**: We will not provide a migration path for old `contentJson` data; we will perform a clean table reset for lessons.

## Decisions

### Decision 1: Use `syncfusion_flutter_pdfviewer` for PDF rendering
- **Rationale**: It provides a premium, fast, and highly customizable PDF experience. Importantly, it supports remote URLs directly, removing the need for us to manage manual file caching/downloading before display.
- **Alternatives Considered**: 
  - `flutter_pdfview`: Faster native rendering but requires manual "download-to-local-file" logic.
  - `url_launcher`: Easiest to implement but forces users out of the app, breaking the lesson progress tracking flow.

### Decision 2: Replace `contentJson` with `contentUrl` in Drift (Database)
- **Rationale**: While we could store the URL inside the existing `contentJson` column as a single-element list, it's cleaner to have a dedicated text column. This improves database readability and removes the overhead of JSON serialization.
- **Impact**: Requires a clear of the local `Lessons` table and an update to the `CourseRepository` mapping logic.

### Decision 3: Redesign `LessonDetailScreen` as a Media Dispatcher
- **Rationale**: The current `LessonDetailScreen` is optimized for scrolling through a list of text blocks. The new design will act as a "Shell" that renders a `SyncfusionPdfViewer` or a `Chewie` Video Player based on the lesson type, filling the screen with a single immersive media view.

## Risks / Trade-offs

- **[Risk] Syncfusion License** → **Mitigation**: We will use the Syncfusion Community License (free for small companies) or ensure the commercial license is in place before production.
- **[Trade-off] App Size** → **Mitigation**: Adding a high-quality PDF engine increases the app size slightly, but this is acceptable for a premium LMS experience that requires robust offline and zoom support.
