## Context

The dashboard currently uses hardcoded mock data for the "Resume Learning" section. The real backend API (`/api/v2.4/resume/`) provides a relational response structure where lesson metadata, user video progress, and assessment states are separated into different lists. This requires a technical strategy to "join" these datasets into a unified list of cards for the UI.

## Goals / Non-Goals

**Goals:**
- Implement real-time synchronization of the "Resume Learning" feed.
- Support offline-first access using the existing Drift database infrastructure.
- Reuse the `DashboardContentDto` and `LessonCardsSectionWidget` for UI consistency.
- Correctly map video and exam progress to a unified progress bar or status label.

**Non-Goals:**
- Modifying or clearing progress from the dashboard.
- Implementing "pagination" for the dashboard section (we will show the top N items from the first page).

## Decisions

### 1. Branched Parsing in `DashboardContentsDto`
We will update `DashboardContentsDto.fromJson` to branch its logic based on the `sectionType` parameter.
- **For `whatsNew`**: Maintain the current straightforward mapping of the `results` list.
- **For `resumeLearning`**: Implement the "Filter and Match" logic to join `chapter_contents` with `user_videos` and `assessments`.
- **Rationale**: This prevents the `resume` parsing logic from introducing complexity or overhead when fetching other sections, while keeping the DTO entry point unified.
- **Alternative**: A single complex loop. **Rejected** because the data structures are fundamentally different (straight list vs. relational tables).

### 2. Join Logic for Progress
We will use the following join keys:
- **Videos**: `chapter_content.video_id` matches `user_video.video_content.id`.
- **Exams**: `chapter_content.exam_id` matches `assessment.exam.id`.
- **Order**: We will loop through `chapter_contents` first and filter based on progress presence (as per user preference), ensuring the server's provided content metadata remains the source of truth.

### 3. Repository and Provider Pattern
We will add `watchResumeLearningFeed()` to `DashboardRepository`.
- **Rationale**: This follows the established pattern in the codebase, where the repository handles the "yield cached data first, then refresh from network" logic.

## Risks / Trade-offs

- **[Risk]**: `video_id` or `exam_id` mismatch between lists.
- **[Mitigation]**: Implement defensive parsing with `null` checks; if a match isn't found, the item will be excluded from the list to avoid showing cards without progress.
- **[Trade-off]**: By ignoring the `attempts` list, we rely on the `chapter_contents` order. If the server doesn't sort `chapter_contents` by recency, the order might be different from the web platform.
