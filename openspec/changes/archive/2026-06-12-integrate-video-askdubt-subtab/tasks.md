## 1. Core UI Components

- [x] 1.1 Extract AskDoubtFab from LessonDetailOrchestrator for global context.
- [x] 1.2 Implement DoubtTab widget with CustomScrollView for its inner list.
- [x] 1.3 Add AskDoubtFab localized at the bottom right corner inside DoubtTab.

## 2. Integration into Video Viewer

- [x] 2.1 Update VideoLessonViewer to include DoubtTab in its subtabs unconditionally.
- [x] 2.2 Update VideoLessonDetailScreen to include DoubtTab in its TabBarView.
- [x] 2.3 Ensure TabBarView and CustomScrollViews handle the DoubtTab layout properly without unbounded heights.

## 3. Resolving Architectural Dependency

- [x] 3.1 Migrate `doubt_providers.dart` from `discussions` to a shared injection module (e.g., `core/data/providers`).
- [x] 3.2 Update `courses` to consume the doubt providers from the shared injection layer rather than importing `discussions` directly.
- [x] 3.3 Ensure the `discussions` package correctly implements and satisfies the injected `doubt_providers` logic.
