## Context

See `proposal.md` - Why. The native Zoom SDK wrapper package (`packages/zoom`) is already merged into the `main` branch. This design document covers the app-level integration inside the `courses` and `app` packages.

## Goals / Non-Goals

**Goals:**
- Integrate the Zoom launch action inside the `VideoConferenceViewer` widget.
- Capture all initialization and authentication exceptions inside the viewer and log them using the app's `sentryServiceProvider`.
- Exclude `sqlite3-native-library` in Gradle conditionally so that the database runs in both Zoom-enabled and Zoom-disabled builds.

**Non-Goals:**
- Modifying the native Zoom SDK wrapper package itself.

## Decisions

### Decision 1: Conditional Exclude in `build.gradle.kts`
- **Rationale**: Wrapping the exclude statement in `if (project.findProject(":zoom") != null)` ensures that the Maven dependency `sqlite3-native-library` is only excluded when Zoom is active. This allows the standard SQLite library to package normally when Zoom is commented out, resolving the database initialization crash.
- **Alternatives Considered**: Excluding the library globally, which crashed the app when Zoom was disabled.

### Decision 2: UI-Level Exception Capturing
- **Rationale**: Since `VideoConferenceViewer` is a `ConsumerWidget` with access to a Riverpod `WidgetRef`, catching exceptions inside the widget's `_joinMeeting` function and calling `ref.read(sentryServiceProvider).captureException(...)` is the cleanest and most direct way to log errors.
- **Alternatives Considered**: Catching errors inside the low-level Zoom service, which is static and does not have access to Riverpod provider refs.

## Risks / Trade-offs

- **[Risk] Incremental Android Debug Caching**: Android's incremental package manager caches native `.so` files during debug installs, causing errors when switching dependencies.
  - **Mitigation**: Developers must perform a clean install (uninstall and rebuild) when enabling/disabling the Zoom dependency locally during development.
