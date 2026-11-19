## Context

The Cortex monorepo renders embedded YouTube videos through two primary widgets:
1. `AppIframeView` in `packages/core`: Platform-level widget that renders standalone iframe embed URLs in an isolated `WebViewWidget`.
2. `LessonWebView` in `packages/courses`: Domain-level widget that renders full lesson HTML (notes and `embedContent`), which frequently contains inline `<iframe src="...">` elements pointing to YouTube embeds.

By default, YouTube embeds without `rel=0` display recommendations from arbitrary external channels when paused or finished. Furthermore, clicking on recommended videos, "Watch on YouTube", or the player share menu can trigger outbound navigation that redirects students away from the lesson. To keep learners engaged and focused on course materials, YouTube embeds must restrict recommendations to the uploader's channel via `rel=0`, and outbound navigation targeting YouTube or social share dialogs must be suppressed.

## Goals / Non-Goals

**Goals:**
- Provide a centralized utility in `packages/core` (`AppIframeView.sanitizeYouTubeEmbedUrl`) that injects `rel=0` into YouTube embed URLs.
- Automatically apply this transformation in `AppIframeView._loadIframe()`.
- Intercept embedded YouTube iframe `src` attributes in `LessonWebView.buildStyledHtml` and apply `rel=0` while preserving quote delimiters and HTML entity encoding (`&amp;`).
- Suppress top-level outbound navigation to YouTube domains and social share endpoints containing YouTube links in `LessonWebView.handleNavigationRequest`.
- Preserve external in-app browser delegation for legitimate non-YouTube reference links.
- Maintain full backwards compatibility and test coverage across unit and widget tests.

**Non-Goals:**
- Completely hiding the end-screen video grid: YouTube deprecated disabling related videos entirely in September 2018; `rel=0` restricts them to the same channel.
- Modifying non-YouTube embed providers (e.g. Vimeo, Wistia) or direct non-embed links.

## Decisions

### 1. Centralize YouTube Embed Sanitization in `AppIframeView` (`packages/core`)
- **Choice**: Expose a static helper `AppIframeView.sanitizeYouTubeEmbedUrl(String rawUrl)` in `packages/core`.
- **Rationale**: `packages/core` is the platform SDK and already defines `isSupportedUrl` and `normalizeUrl`. Keeping URL parsing and parameter merging logic in `core` allows domain packages like `packages/courses` to reuse it, avoiding duplicated logic.

### 2. URL Transformation via `Uri.replace`
- **Choice**: Parse the URL with `Uri.tryParse`, verify host/path matching (`/embed/` on `youtube.com` or `youtube-nocookie.com`), and merge `{'rel': '0'}` into `queryParameters`.
- **Rationale**: `Uri.replace` handles query parameter replacement idempotently, preserving existing parameters (`start`, `autoplay`) and updating `rel=1` to `rel=0` without duplicate keys.
- **Fallback**: If `Uri.tryParse` returns null or the URL is not a recognized YouTube embed, return the normalized URL untouched.

### 3. Symmetrical Regex Replacement in `LessonWebView`
- **Choice**: In `packages/courses`, use `RegExp(r'''(<iframe\b[^>]*?\bsrc=(["']))([^"']+)(\2)''', caseSensitive: false)` and `replaceAllMapped` to match iframe sources.
- **Rationale**: Capturing the opening quote and using a backreference (`\2`) guarantees that single-quoted and double-quoted attribute delimiters are preserved symmetrically without breaking on edge cases.
- **Entity Handling**: Decode `&amp;` to `&` before URI parsing, and re-escape `&` as `&amp;` when injecting the sanitized URL back into the HTML attribute.

### 4. Precision Filtering for Outbound Navigation and Share Dialogs
- **Choice**: In `LessonWebView.handleNavigationRequest`:
  - Block top-level navigation to YouTube hosts (`youtube.com`, `youtube-nocookie.com`, `youtu.be`).
  - Block social sharing dialogs targeting known social platforms (`whatsapp.com`, `facebook.com`, `twitter.com`, `x.com`, `reddit.com`, `linkedin.com`, `pinterest.com`, `t.me`) when the payload contains a YouTube link.
- **Rationale**: Prevents player share buttons from navigating out to social media apps while ensuring legitimate external articles (e.g., an article link mentioning `youtube.com` in its path or query parameters) are not falsely blocked and continue delegating to `url_launcher`.

## Risks / Trade-offs

- **[Risk]** Malformed embed markup or entities in backend HTML.  
  → **Mitigation**: Use safe fallback logic returning original attributes if parsing fails; test with mixed providers and encoded entities.
- **[Risk]** Over-aggressive navigation blocking.  
  → **Mitigation**: Constrain share intent suppression to known social share hostnames rather than global substring matching on all URLs.
