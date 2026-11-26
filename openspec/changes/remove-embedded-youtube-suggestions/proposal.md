## Why

When embedded YouTube videos are paused or finish playing in lesson content, YouTube displays arbitrary third-party recommendations by default, distracting learners and potentially showing irrelevant or competing content. Additionally, tapping related videos or player share buttons triggers top-level WebView navigation, pulling students away from the lesson.

Injecting `rel=0` ensures video recommendations remain restricted to the uploader's channel, while intercepting outbound YouTube navigation and social share intents keeps learners focused inside the lesson view.

## What Changes

- Restrict YouTube embed recommendations to the same channel by automatically enforcing `rel=0` on embed URLs in `AppIframeView` and raw HTML iframe embeds in `LessonWebView`.
- Suppress top-level outbound navigation to YouTube and social sharing dialogs (e.g. WhatsApp, Facebook, X, Reddit) in `LessonWebView` to keep learners within the course shell.
- Preserve standard in-app browser delegation for legitimate external resource hyperlinks.
- Add unit and widget regression tests verifying embed URL transformation, entity decoding, quote symmetry, and navigation filtering.

## Capabilities

### Modified Capabilities
- `html-iframe-embed`: Enforce `rel=0` query parameter on YouTube embed URLs in `AppIframeView`.
- `webview-lesson-viewer`: Transform raw HTML iframe embeds to include `rel=0` and suppress outbound YouTube and social share navigation while delegating non-YouTube external links to the in-app browser.

## Impact

- **Affected Packages**: `packages/core` and `packages/courses`.
- **Dependencies**: No new external dependencies introduced.
- **APIs**: Fully backwards-compatible; no breaking API changes.
