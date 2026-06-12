## Context

The video lesson viewer previously supported tabs for Notes, Transcripts, and AI Support. We are now integrating the Doubt Tab (a feature from the `discussions` package) directly into the video player's subtabs so students can ask and view doubts seamlessly while watching video lessons. 

Additionally, the Ask Doubt FAB currently floats globally in `LessonDetailOrchestrator` for all text/static lesson types, but for video lessons, it needs to be localized to the Doubt Tab itself.

## Goals / Non-Goals

**Goals:**
- Integrate `DoubtTab` as a standard subtab in `VideoLessonViewer` and `VideoLessonDetailScreen`.
- Move the floating action button (FAB) inside `DoubtTab` instead of having it global for video lessons.
- Solve unbounded height exceptions (RenderBox issues) caused by unconstrained ScrollViews interacting with Slivers.
- Break the circular dependency between `courses` and `discussions` packages.

**Non-Goals:**
- Redesigning the entire Doubt UI or API.
- Implementing an entirely new tab architecture.

## Decisions

**Decision 1: Scroll Architecture within DoubtTab**
* **Rationale:** The `DoubtTab` widget uses a `CustomScrollView` internally to handle its own scrolling, instead of returning a `ListView` wrapped in unconstrained boxes like `SingleChildScrollView` or `SliverToBoxAdapter` inside parent slivers. By isolating the scrolling internally, the tab can handle `SliverPadding` and `SliverList.separated` properly, and gracefully accept an optional `footerBuilder` injected by the parent. 

**Decision 2: Localization of Ask Doubt FAB**
* **Rationale:** Since video lessons have subtabs, the FAB is injected locally inside the `DoubtTab`'s `Stack` instead of `LessonDetailOrchestrator`. It prevents the FAB from blocking the UI when viewing Notes or Transcripts.

**Decision 3: Architectural Decoupling (Circular Dependency)**
* **Rationale:** The `courses` package cannot depend directly on `discussions/providers/doubt_providers.dart` while `discussions` simultaneously depends on `courses`. We will relocate the core doubt-related data layers (`doubt_providers`, `DoubtRepository`, etc.) into `packages/core/data` (Option A), or use a dependency injected widget registry. Given the monorepo structure, providing the Doubt API contracts in `core` ensures `courses` can consume the providers without importing `discussions` UI.

## Risks / Trade-offs

- **Risk:** Moving data layers to `core` might bloat `core` if done excessively.
  - *Mitigation:* Ensure only the repository interfaces, DTOs, and global Riverpod providers are moved to `core`, while specific UI widgets (`DoubtItemCard`, `AskDoubtFab`) remain modular or abstracted.
- **Risk:** FAB overlapping with the list content.
  - *Mitigation:* Ensure the internal `SliverPadding` in `DoubtTab` features an aggressive bottom padding (e.g., `100px`) so the FAB does not block the last list item.
