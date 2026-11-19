## 1. Core Platform Implementation (`packages/core`)

- [x] 1.1 Implement YouTube embed URL sanitizer in `AppIframeView` (`sanitizeYouTubeEmbedUrl`) to inject `rel=0` idempotently while preserving existing query parameters
- [x] 1.2 Integrate URL sanitizer into `AppIframeView._loadIframe()` before generating HTML template
- [x] 1.3 Add unit tests in `packages/core/test/widgets/app_iframe_view_test.dart` for YouTube URL sanitization (plain URL, existing query params, existing rel parameter, non-YouTube URLs)

## 2. Courses Domain Implementation (`packages/courses`)

- [x] 2.1 Update `LessonWebView.buildStyledHtml` in `packages/courses/lib/widgets/lesson_detail/lesson_web_view.dart` to intercept YouTube `<iframe>` embeds in raw HTML with symmetrical quote handling and apply the sanitizer
- [x] 2.2 Add unit tests in `packages/courses/test/widgets/lesson_web_view_test.dart` for raw HTML iframe sanitization with `rel=0`, quote symmetry, and entity handling
- [x] 2.3 Block outbound YouTube navigation and social share intents in `LessonWebView.handleNavigationRequest` without delegating to `url_launcher`
- [x] 2.4 Add unit tests in `packages/courses/test/widgets/lesson_web_view_test.dart` verifying YouTube external navigation suppression, social share intent blocking, and non-YouTube link delegation

## 3. Verification & Validation

- [x] 3.1 Run tests across both `packages/core` and `packages/courses` to verify no regressions
- [x] 3.2 Verify analyzer diagnostics pass with no warnings or errors
