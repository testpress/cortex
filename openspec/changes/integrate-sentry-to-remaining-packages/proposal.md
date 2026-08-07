## Why

Currently, exceptions caught inside the `discussions`, `profile`, and `testpress` packages are either swallowed, printed to the debug console, or shown only as local UI toast messages without being reported to the central error monitoring system. This prevents effective monitoring, debugging, and proactive resolution of runtime failures in these modules.

## What Changes

- Integrate Sentry exception tracking across the remaining packages (`discussions`, `profile`, and `testpress`).
- Inject `SentryService` into repository constructors (e.g., `ForumRepository`).
- Capture uncaught/swallowed exceptions in state providers and notifier methods using `sentryServiceProvider` before rethrowing or fallback.
- Catch unexpected/generic exceptions in UI screens and event handlers and report them via `ref.read(sentryServiceProvider).captureException(...)`.
- Maintain decoupled architecture by strictly avoiding direct dependencies on the `sentry_flutter` package inside target packages, utilizing the `core` package's `SentryService` wrapper.

## Capabilities

### New Capabilities
- `discussions-error-tracking`: Captures and logs exceptions in the forums and doubts modules (repositories, providers, and detail screens).
- `profile-error-tracking`: Captures and logs generic errors during authentication (login, registration, OTP validation, and login activity management).
- `testpress-error-tracking`: Captures and logs exceptions within the bookmarks and announcements modules.

### Modified Capabilities

## Impact

- **Affected Code**: 
  - `packages/discussions/lib/repositories/forum_repository.dart`
  - `packages/discussions/lib/providers/forum_providers.dart`
  - `packages/discussions/lib/screens/forum_post_detail_screen.dart`, `ask_doubt_form_screen.dart`, `forum_post_create_screen.dart`, `doubt_detail_screen.dart`
  - `packages/profile/lib/screens/otp_screen.dart`, `edit_profile_screen.dart`, `login_activity_screen.dart`, `forgot_password_screen.dart`, `login_screen.dart`, `mobile_login_screen.dart`, `signup_screen.dart`
  - `packages/testpress/lib/screens/bookmarks/bookmarks_screen.dart`
  - `packages/testpress/lib/screens/announcements/announcements_list_screen.dart`
- **Dependencies**: Uses the `core` package's `SentryService` and Riverpod `sentryServiceProvider` directly. No new third-party dependencies are added.
