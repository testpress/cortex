## Context

The current architecture uses monolithic screens for different lesson types, causing UI fragmentation and navigation hurdles when crossing domain boundaries (e.g., from Courses to Exams).

## Goals / Non-Goals

**Goals:**
- Centralize lesson navigation and header UI in a single `core` component.
- Transition to router-level orchestration for content switching.
- Standardize rich-media rendering through a unified WebView.

**Non-Goals:**
- Modifying the underlying data fetchers or DTO mappings (handled in previous PR).
- Implementing full offline support for HTML content.

## Decisions

### 1. Unified Shell (`LessonDetailShell`)
Defined in `core`, this component provides the header and sticky footer navigation markers. It is intentionally agnostic of the content being displayed, relying on a `body` slot.

### 2. Router Orchestrator
The `app_router` now identifies the lesson format (PDF, Video, HTML, Test) and wraps the respective viewer in the `LessonDetailShell`. For videos, it delegates playback to the `TestpressPlayer` from the `tpstreams_player_sdk`.

### 3. High-Fidelity WebView
Introduced `LessonWebView` in the `courses` package. It uses CSS injection to apply the app's design tokens (colors, typography) to arbitrary HTML content, ensuring a seamless visual blend.

## Risks / Trade-offs

- **Loading States**: Deep-linking requires completing the lesson metadata fetch before the shell can resolve the correct next/prev navigation pointers, necessitating a unified loading indicator.
- **WebView Performance**: While heavier than native text, it's the only way to guarantee fidelity for complex V2.4 API HTML payloads.
