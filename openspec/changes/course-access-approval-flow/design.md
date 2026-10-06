## Context

Certain courses in the Testpress platform require approval workflows (e.g., "REQUEST PACKAGE" or "Pending Approval"). The `/api/v2.4/courses/` endpoint provides `external_content_link` (containing an SSO URL with token/signature) and `external_link_label` (containing the action title). In the mobile client, we must ingest and persist these fields, display appropriate action buttons on the course card, open the enrollment form via WebView, show a completion confirmation, and refresh the course catalog to reflect state transitions.

## Goals / Non-Goals

**Goals:**
- Ingest and store `external_content_link` and `external_link_label` in `CourseDto` and Drift's `CoursesTable`.
- Surface access state properties on the `Course` domain entity.
- Render dynamic action buttons on `CourseCard` when a course requires registration.
- Provide `CourseEnrollmentScreen` to render `externalContentLink` in an authenticated `AppWebView`.
- Silently refresh the courses list upon returning from enrollment so the UI transitions smoothly.
- Guard content routes against accessing restricted course chapters.

**Non-Goals:**
- Custom native forms for registration or moderation (the web platform directly handles the form inputs, moderation notices, rejection reasons, and re-appeal flow).

## Decisions

### 1. Data Schema & Persistence in `CoursesTable`
- **Decision**: Add two nullable text columns (`externalContentLink` and `externalLinkLabel`) to `CoursesTable` in Drift (`packages/core`).
- **Rationale**: The UI observes Drift streams for real-time and offline cache display. Persisting these fields guarantees that cached course cards consistently show the correct button state.

### 2. Button State & Card UI
- **Decision**: Evaluate `course.requiresExternalRegistration` (true when `externalContentLink` is non-null and not empty).
- **Rationale**: When true, replace the progress bar and lesson count indicators with a prominent button using `externalLinkLabel`. Tapping the card or button navigates directly to the WebView flow.

### 3. In-App WebView & Completion Handling
- **Decision**: Load `externalContentLink` in `CourseEnrollmentScreen` via `AppWebView`. The web flow handles the entire enrollment, rejection/reappeal messaging, and success feedback. When the user pops/exits the screen, refresh the course repository.
- **Rationale**: Ensures the student stays inside the app context and sees updated card states without requiring client-side interception.

## Risks / Trade-offs

- [Risk: SSO URL expiration] → The SSO link contains a timestamp signature. If a cached link expires, opening it may prompt a re-login.
  *Mitigation*: The app triggers regular course refreshes on tab entry and pull-to-refresh to keep SSO links fresh.
- [Risk: WebView navigation variance] → Form submission redirects might vary across institutes.
  *Mitigation*: Check for URL query params/paths indicating completion as well as DOM-level submission signals.
