## 1. DeepLinkHandler Implementation

- [x] 1.1 Create `packages/testpress/lib/navigation/deep_link_handler.dart`.
- [x] 1.2 Implement URL sanitization: trim whitespace, parse URI, strip query parameters and fragments.
- [x] 1.3 Implement mapping for dashboard, learn, and leaderboard URLs (`/dashboard`, `/learn`, `/leaderboard`, `/`) → `/home`.
- [x] 1.4 Implement mapping for content and lesson URLs (`/exams/chapter_content/:id`, `/courses/:courseId/contents/:id`, `/chapters/:chapterId/:id`) → `/study/lesson/:id`.
- [x] 1.5 Implement mapping for course overview (`/courses`) → `/study`.
- [x] 1.6 Implement mapping for products and store (`/products/:slug`, `/store/product/:slug` → `/store/product/:slug`, `/products`, `/store` → `/store`).
- [x] 1.7 Implement mapping for authentication (`/login` → `/login`, `/activate`, `/register` → `/signup`).
- [x] 1.8 Implement mapping for forum posts (`/p/:slug`, `/posts/:slug` → `/home/discussions/forum/posts/:slug`).
- [x] 1.9 Implement mapping for exams (`/exams*` → `/exams`).
- [x] 1.10 Implement fallback to `/home` for any unrecognized or malformed paths.

## 2. Notification Service Integration

- [x] 2.1 Update `PushNotificationService._handleDeepLink` in `packages/testpress/lib/providers/push_notification_service.dart` to use `DeepLinkHandler.resolve(url)`.
- [x] 2.2 Add exception handling around notification navigation to gracefully fall back to `/home` in case of navigation errors.

## 3. Testing & Verification

- [x] 3.1 Create `packages/testpress/test/navigation/deep_link_handler_test.dart`.
- [x] 3.2 Test all specified URL patterns, query parameter stripping, and segment extraction.
- [x] 3.3 Test edge cases (null, empty, malformed URLs, and unknown route fallbacks).
- [x] 3.4 Run Flutter tests in `packages/testpress` to ensure all tests pass and code quality checks succeed.

## 4. Pattern Matcher & Tenant Tab Gating Refactor

- [x] 4.1 Refactor `DeepLinkHandler` to use a declarative pattern-to-target rule table with parameter substitution.
- [x] 4.2 Add route availability checking against `NavTab.active(settings)` and `AppConfig.showCertificate` with safe fallback to `/home` (or `/study` for exams).
- [x] 4.3 Update `PushNotificationService` to store pending raw URLs and resolve/validate at dispatch time when `InstituteSettings` is loaded.
- [x] 4.4 Update unit tests to verify declarative pattern matching and feature/tab availability fallbacks.
- [x] 4.5 Clear pending deep link on user logout to prevent cross-account redirection.
- [x] 4.6 Switch bottom navigation shell tabs via `router.go()` and push detail screens via `router.push()`.
- [x] 4.7 Register bootstrapProvider listener in pushNotificationService factory for canonical Riverpod lifecycle management.
