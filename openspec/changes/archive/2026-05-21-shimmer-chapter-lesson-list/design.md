## Context

The cortex platform uses `Skeletonizer` combined with Design System tokens (`design.colors.skeleton` and `design.colors.onSkeleton`) to display high-fidelity, premium shimmer layouts for the Dashboard and Study Tab course list.
Currently, navigating into the Chapter list (`ChaptersListPage`) or a specific Chapter's Detail view (`ChapterDetailPage`) displays a generic `AppLoadingIndicator()` (circular spinner). This breaks the high-end visual aesthetic and continuity of the study navigation flow.

## Goals / Non-Goals

**Goals:**
*   Replace standard loading indicators in the chapter list and chapter detail pages with structural skeleton loaders.
*   Achieve unified loading visuals matching the Study tab's course list shimmer.
*   Support smooth background sync transitions without showing full-screen spinners when data is partially present.
*   Prevent layout shifts when actual data replaces the shimmer skeletons.

**Non-Goals:**
*   Refactoring the visual layouts of the chapter or lesson cards themselves.
*   Adding skeleton states to other sub-screens, such as the quiz/test readers, or discussion threads in this specific change.

## Decisions

### 1. Parent-Level Skeletonizer for Lists
*   **Decision**: Wrap the list of items (`SliverList` or `ListView`) inside a `Skeletonizer` widget when the loading condition is true, passing a fixed count (e.g., 5-6 items) of mock data.
*   **Rationale**: Placing the `Skeletonizer` container at the parent/list level coordinates the shimmer animation across all list items concurrently and makes the state management extremely clean.
*   **Alternative Considered**: Passing `isSkeleton` to every individual list item widget. While viable, this requires propagating parameters down through multiple widget constructors and makes animation sync across items harder.

### 2. Static Skeleton Mock DTO Lists
*   **Decision**: Define static `_skeletonChapters` and `_skeletonLessons` helper lists in the UI layer (similar to `_skeletonCourses` in `study_content_list.dart`) containing realistic titles and metadata counts.
*   **Rationale**: Skeletonizer relies on real widget hierarchies and text content to draw the shimmer shapes ("bones"). Stable, realistically sized text lengths prevent the skeleton cards from looking too small or shifting in size when actual data is rendered.
*   **Alternative Considered**: Rendering blank boxes of hardcoded sizes. This is less maintainable and does not adapt automatically if text sizes or insets change in future designs.

### 3. Automatic Skeletonization Without Manual Bones/Skeletons
*   **Decision**: Rely entirely on `Skeletonizer`'s default automatic skeletonization of standard text, widgets, and icons. Do NOT introduce manual `Skeleton.replace` or `Bone` wrappers.
*   **Rationale**: Simplifies the codebase, avoids manual skeleton/bone configuration, and keeps the design highly maintainable and clean, matching standard Skeletonizer usage as demonstrated in official documentation and simple course lists.

### 4. Preserving Card Backgrounds and Shadows
*   **Decision**: Move the `Skeletonizer` boundary inside `AppCard` for `ChapterContentItem`, and avoid wrapping the entire page in `Skeletonizer` in `ChapterDetailPage`'s loading state. Instead, apply `Skeletonizer` selectively to the header contents and individual list items.
*   **Rationale**: Wrapping `AppCard` or wrapping the entire page in `Skeletonizer` causes the custom card containers' background colors and shadows to be skeletonized or hidden. Moving `Skeletonizer` to wrap only the inner layouts ensures card backgrounds and shadows are preserved, matching the visual style of the chapter list.

## Risks / Trade-offs

*   **[Risk] Unresponsive clicking during loading**: Users might try to click on a shimmering card and expect navigation.
      *   *Mitigation*: Set `onTap` handlers to `null` for both `ChapterCurriculumItem` and `LessonListItem` when the skeleton state is active.
*   **[Risk] Shimmering when data is already cached**: Background syncing might flash shimmers if the sync triggers on page entry despite cache presence.
      *   *Mitigation*: Only enable the skeleton state when the repository's loading/syncing state is active **AND** the existing cached list is empty, preventing unnecessary flashes.

