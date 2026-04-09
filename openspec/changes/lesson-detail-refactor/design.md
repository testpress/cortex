## Context

Currently, the lesson detail implementation is split between multiple screens, each with its own boilerplate for data management. We want to move to a "Domain Partitioning" model where the Router decides which specialized screen to show, instead of relying on a "Shell" widget that delegates internally.

## Goals / Non-Goals

**Goals:**

- **Isolate PDF content**: Move PDF-specific logic to `PdfLessonDetailScreen`.
- **Router-First Architecture**: Use `app_router.dart` as the switcher to avoid redundant widget layers.
- **Isolate UI components**: Maintain specialized headers and layouts within each content screen for tailored UX.
- **Standardize filenames**: Correct naming drift (`_screen.dart` vs `_page.dart`).

**Non-Goals:**

- **Adding new content types**: We are only refactoring existing PDF, Video, and Test paths.
- **Cross-package UI sharing**: Each domain package (`courses`, `exams`) will maintain its own specialized detail UI.

## Decisions

- **Decision 1: Use the Router as the Brain**: Instead of a "Switcher" screen, we'll map paths like `/lesson/:id` directly to specialized screens in the `app_router.dart` builder.
- **Decision 2: Standardize on `_screen.dart`**: To match your naming convention, all detail entry-point filenames will end with `_screen.dart`.
- **Decision 3: Keep UI Isolated**: PDF and Video screens will keep their own specialized headers and sidebar logic to follow the "Independent Domain" principle.

## Risks / Trade-offs

- **Risk: Duplicate Data Loading Logic** → **Mitigation**: Use a common `lessonDetailProvider` inside the Router Builder so that fetching, loading, and error states are handled once for all types in a single location.
- **Risk: Breaking Router Paths** → **Mitigation**: Update all barrel file exports (`courses.dart`) and route definitions during the deletion of the legacy shell screen.
