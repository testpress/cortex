# 0007: Zoom SDK Native Integration

## Status
Accepted

## Context
The application requires native Zoom Meeting SDK integration for live classroom sessions. Previously, we relied on a web-based Zoom lobby which suffered from poor performance and lacked advanced meeting features (e.g. video tiles, low-latency audio, native layout views). 

Integrating the Zoom Meeting SDK introduces a significant footprint of binary dependencies (~570 MB of native `.aar` and `.framework` files) and causes binary collisions with existing native database packages like `sqlite3`. We needed to wrap the SDK in a locally managed package to allow customization, fix runtime channel registration races, and prevent Git history bloat without modifying the core app dependencies.

## Decision
We introduced a custom, locally managed native wrapper plugin strictly inside the `zoom` package (`packages/zoom`) in our monorepo, forked from the original `flutter_zoom_meeting_sdk` plugin. 

Key architectural decisions include:
1. **Local Fork over External Dependency**: We forked the wrapper locally to maintain full control over compiled build behaviors, package namespaces (`com.testpress.flutter_zoom_meeting_sdk`), and platform versions.
2. **Git LFS (Large File Storage) for Binaries**: We configured Git LFS tracking for native binary files (`*.aar` and the iOS `MobileRTC` executable). This prevents repository size inflation and respects GitHub's 100 MB file limit.
3. **SQLite Binary Collision Resolution**: To resolve `UnsatisfiedLinkError` crashes on Android caused by a name clash between Zoom's database engine and Drift's custom `libsqlite3.so`, we capped the `sqlite3` Dart dependency inside `packages/core` to `<3.0.0` (forcing version `2.9.4`). This disables Native Assets compilation, causing Drift to share the native SQLite library packaged by Zoom.
4. **Dynamic Sentry and Callback Injection**: 
   - Refactored native Kotlin event stream handlers to resolve event sinks dynamically via closures to prevent startup null pointer race conditions.
   - Introduced a `sentryService` setter in the abstract `MeetingService` interface, allowing `meetingServiceProvider` in `core` to dynamically inject the app's global Sentry instance into `ZoomMeetingService` without introducing circular package dependencies.

## Consequences
- **Positive**: Full compile-time control over the Zoom SDK integration, preventing third-party updates from breaking our custom platform configuration.
- **Positive**: Git history remains extremely small and fast to fetch, only downloading the binaries when Git LFS is active.
- **Positive**: Resolved all runtime binary namespace conflicts and layout errors (such as Compose `NoSuchMethodError` and missing `ViewBinding` classes) cleanly at the plugin compilation layer.
- **Tradeoff**: Team developers cloning the repository for the first time must have `git-lfs` installed locally to build mobile targets.
