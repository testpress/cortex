## Why

The user experience when navigating between diverse lesson types (Video, PDF, Notes) is currently disjointed, with each viewer managing its own navigation and header. This proposal introduces a unified orchestration layer and shell to provide a seamless "stationary" UI experience.

## What Changes

- **Unified Routing**: Consolidation of all lesson entry points into a single `/study/lesson/:id` route.
- **Orchestration Layer**: Introduction of a `LessonDetailOrchestrator` that dynamically switches between viewers based on the content type.
- **Unified Shell**: Implementation of `LessonDetailShell` in `packages/core` to provide a consistent header and sticky navigation footer.
- **Rich Media Viewer**: Creation of `LessonWebView` to handle HTML notes and video embeds with theme-aware styling.

## Capabilities

### New Capabilities
- `unified-lesson-shell`: Global layout component for lesson-centric views.
- `sequential-navigation`: Logic to handle intra-course movement using API-driven pointers.
- `webview-lesson-viewer`: High-fidelity HTML and embed rendering via WebView.

### Modified Capabilities
- `lesson-content-orchestration`: Updated to include router-level switching and unified loading states.

## Impact

- **Affected Packages**: `packages/core`, `packages/courses`, `packages/testpress` (routing).
- **UX**: Provides a premium, app-wide consistent navigation for all learning content.
