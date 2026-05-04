## Context

The current LMS dashboard relies on hardcoded dummy data for the "What's New" section. We are integrating the Testpress V2.4 "What's New" API, which provides a normalized feed of the latest content updates. To support offline access and instant loading, we need a robust persistence strategy that scales as more dashboard sections (Resume, Trending, etc.) are added.

## Goals / Non-Goals

**Goals:**
- Implement a reactive, offline-first data flow for the "What's New" section.
- Create a scalable database infrastructure for managing ordered dashboard content.
- Support metadata "hydration" (Chapter names, durations) from normalized API responses.

**Non-Goals:**
- Implementing the "Resume Learning" section (deferred to a future change).
- Redesigning the `LessonCardWidget` UI (integration only).

## Decisions

### 1. Dedicated Mapping Table (Choice 2)
We will implement a `DashboardContentsTable` rather than adding flags to the main `LessonsTable`.
- **Rationale**: Decouples the volatile dashboard feed from the core curriculum structure. It prevents "flag bloat" in the main table and allows for easier management of multiple dashboard sections and their specific display orders.
- **Alternatives**: Internal boolean flags (Choice 1) - Rejected due to poor scalability and lifecycle management complexity.

### 2. Reusable Dashboard DTOs
We will use a specialized `DashboardContentsDto` instead of reusing `CourseCurriculumDto`.
- **Rationale**: Decouples the dashboard response structure from the course-specific curriculum logic. This DTO acts as a universal container for normalized dashboard sections, supporting Lessons, Chapters, and Courses natively.
- **Enrichment**: The `CurriculumParser` will hydrate this DTO by resolving metadata (e.g., Chapter Names) from the normalized lists provided in the API response.

### 3. Enum-based Type Management
We will implement `DashboardSectionType` and `DashboardContentType` enums for all mapping operations.
- **Rationale**: Eliminates "stringly-typed" logic and prevents bugs when filtering dashboard sections or joining tables. `DashboardContentType` will include granular types (video, pdf, course, etc.) to allow the UI to determine the card type without deep-diving into master tables.

### 4. Polymorphic Content Handling (Filtering)
The `DashboardRepository` will provide specialized methods (e.g., `watchWhatsNewFeed`) that filter based on `DashboardContentType`.
- **Strategy**: The mapping table tracks the specific type for every item. This allows a single repository to serve different UI requirements—for instance, the "What's New" section can specifically stream `LessonDto` objects, while a "Trending Courses" section could stream `CourseDto` objects from the same infrastructure.

### 5. Wipe-and-Refresh Synchronization
The `DashboardRepository` will perform a full refresh of the mapping table for a specific section type upon successful API fetch.
- **Rationale**: Ensures the local dashboard exactly matches the API's latest state and sorting order without complex diffing logic.
- **Safety**: The main `LessonsTable` remains untouched except for merges, ensuring no content data is lost.

## Risks / Trade-offs

- **[Risk]** Query performance on mapping table JOINs.
  - **Mitigation**: Add indices to `content_id` and `section_type` in the mapping table.
- **[Risk]** Overwriting local progress with fresh API data.
  - **Mitigation**: Utilize the existing `LessonDto.mergeWith` logic to prioritize local state (progress, bookmarks) during the upsert process.
