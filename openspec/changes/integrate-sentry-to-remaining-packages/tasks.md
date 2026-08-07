## 1. Discussions Package Sentry Integration

- [x] 1.1 Update `ForumRepository` constructor in `packages/discussions/lib/repositories/forum_repository.dart` to accept `SentryService` and wrap key methods (fetching, posting) with try-catch blocks using SentryService.
- [x] 1.2 Update `forumRepositoryProvider` in `packages/discussions/lib/providers/forum_providers.dart` to watch `sentryServiceProvider` and pass it to the constructor.
- [x] 1.3 Add `SentryService` exception tracking inside caught blocks in `packages/discussions/lib/providers/forum_providers.dart` (e.g. `globalForumThreadDetailProvider`, `globalForumCommentsProvider`, `loadMore`).
- [x] 1.4 Integrate `sentryServiceProvider` in `packages/discussions/lib/screens/forum_post_detail_screen.dart` for capturing exceptions when posting replies.
- [x] 1.5 Integrate `sentryServiceProvider` in `packages/discussions/lib/screens/ask_doubt_form_screen.dart` for capturing exceptions when submitting doubts.
- [x] 1.6 Integrate `sentryServiceProvider` in `packages/discussions/lib/screens/forum_post_create_screen.dart` for capturing exceptions when creating posts.
- [x] 1.7 Integrate `sentryServiceProvider` in `packages/discussions/lib/screens/doubt_detail_screen.dart` for capturing exceptions when sending doubt replies.
- [x] 1.8 Remove redundant `debugPrint` statements alongside Sentry capture in discussions provider and screen files.

## 2. Profile Package Sentry Integration

- [x] 2.1 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/otp_screen.dart` during resend and verify.
- [x] 2.2 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/edit_profile_screen.dart` during save.
- [x] 2.3 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/login_activity_screen.dart` during sessions fetch/logout.
- [x] 2.4 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/forgot_password_screen.dart` during reset password.
- [x] 2.5 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/login_screen.dart` during password and Google login.
- [x] 2.6 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/mobile_login_screen.dart` during OTP generation.
- [x] 2.7 Integrate Sentry error capturing inside generic exception handlers in `packages/profile/lib/screens/signup_screen.dart` during registration.

## 3. Testpress Package Sentry Integration

- [x] 3.1 Integrate Sentry error capturing in `packages/testpress/lib/screens/bookmarks/bookmarks_screen.dart` for folder deletion and bookmark removal failures.
- [x] 3.2 Integrate Sentry error capturing in `packages/testpress/lib/screens/announcements/announcements_list_screen.dart` for announcement load-more failures.

## 4. Verification and Testing

- [x] 4.1 Verify code compilation across all modules by running `flutter analyze`.
- [x] 4.2 Run existing tests across all modified modules.
