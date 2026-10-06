## Why

Some courses require administrative approval, package requests, or external registration before students can access their contents. The backend conveys this state via `external_content_link` and `external_link_label` in the `/api/v3/courses/` response. Currently, the client app does not persist or handle these fields, resulting in broken or unhandled access states when learners attempt to interact with restricted courses.

## What Changes

- Ingest `external_content_link` and `external_link_label` from the course API response into `CourseDto` and persist them in the Drift `CoursesTable`.
- Surface course access states in `CourseDto` (`requiresExternalRegistration`, `enrollmentTitle`).
- Update `CourseCard` UI to display dynamic action buttons (e.g., "REQUEST PACKAGE", "Pending Approval", "Resubmit") instead of default progress bars when registration is required.
- Provide `CourseEnrollmentScreen` wrapper to open `externalContentLink` in an authenticated WebView, allowing the web flow to handle registration, approval notices, and rejection messages.
- Refresh course list upon returning from the enrollment screen.
- Guard course curriculum routes against unapproved access attempts, redirecting to the enrollment screen.

## Capabilities

### New Capabilities
- `course-access-approval`: Handles in-app WebView registration, submission confirmation dialogs/screens, and access guarding for courses requiring approval.

### Modified Capabilities
- `course-api`: Ingests and persists `external_content_link` and `external_link_label` in `CourseDto` and `CoursesTable`.

## Impact

- `packages/core`: `CourseDto`, `CoursesTable`, `AppDatabase`, `CourseRepository`, and mapper functions.
- `packages/courses`: `CourseCard` UI, course detail navigation logic, and enrollment WebView integration.
