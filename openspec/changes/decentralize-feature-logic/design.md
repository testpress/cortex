## Context

The current `packages/data` package is a "God Package" containing DTOs, Repositories, API Clients, and Riverpod Providers for all features (Courses, Exams, Profile, etc.). This leads to tight coupling, where any change to the data layer affects the entire app's build and dependency graph.

## Goals / Non-Goals

**Goals:**
- Transition each feature package (`courses`, `exams`, `profile`) to own its business logic (Repositories, Providers).
- Reduce `packages/data` to a "Shared Schema" package containing only DTOs and shared infrastructure.
- Maintain existing Riverpod state management patterns during the relocation.
- Ensure the app remains runnable and buildable at each step of the refactor.

**Non-Goals:**
- Functional changes or bug fixes to the existing logic.
- Performance optimization of the repositories.
- Moving the generic `BaseApiClient` out of its current home (targeting `core` or `data` infrastructure layer for now).

## Decisions

- **Feature-Centric Folders:** Each feature package will adopt a standardized directory structure for logic:
  - `lib/data/`: Mock data and repository implementations.
  - `lib/models/`: Internal models that aren't shared across features.
  - `lib/providers/`: Riverpod providers and controllers.
- **Shared Data (DTOs):** DTOs (Data Transfer Objects) will remain in `packages/data/lib/models/` for now to serve as the shared "lingua franca" and prevent circular dependencies between feature packages.
- **Incremental Relocation:** Refactoring will occur in waves:
  1. Profile/Settings logic.
  2. Course logic.
  3. Exam logic.
- **Public Exports:** Feature barrel files (e.g., `packages/courses/lib/courses.dart`) will explicitly export the new providers and repositories to maintain a clean public API for the `testpress` aggregator.
- **Dependency Management:** Feature packages will continue to depend on `packages/data` (for DTOs) and `packages/core` (for UI/Infrastructure). The `testpress` aggregator remains the top-level orchestrator.

## Risks / Trade-offs

- **Circular Dependencies:** Moving a provider that depends on another module's state into a feature package could trigger a circular dependency. **Mitigation:** Carefully analyze dependencies before moving; keep globally shared state in `data` if isolation is impossible.
- **Build Runner Noise:** Moving Riverpod generators (`.g.dart` files) across packages will require running `build_runner clean` and `build_runner build` frequently during the transition.
- **Import Hell:** Massive refactoring of import paths across dozens of files. **Mitigation:** Perform the migration incrementally and use automated IDE refactoring where possible.
