## Why

Lesson detail currently relies on partial/local lesson data (and mock-like fallbacks in practice) instead of treating the real lesson-detail API as the source of truth from the start. This causes incomplete payload states, hidden refresh failures, and fragile download behavior.

## What Changes

- Move lesson-detail loading to a real API-first model, where lesson detail is loaded from the real lesson-detail API and normalized for current `v2.4` responses with forward-compatibility guards for `v2.5/v3` payload differences.
- Harden lesson-detail refresh behavior so incomplete cached lessons do not remain in indefinite loading without surfaced errors.
- Standardize refresh error propagation contract from provider/repository so route/UI layers can reliably offer retry.
- Define explicit ID mapping rules between `content_id` (detail API) and `chapter_content_id` (attempt/completion API) so completion sync is unambiguous.
- Fix attachment download error handling to avoid unsafe exception assumptions and ensure graceful failure states.
- Define external-open contract for downloaded attachments from app-scoped storage (content URI/FileProvider-compatible behavior).
- Remove sensitive SDK initialization logging and align infra with production-safe diagnostics for tokens, OTP, signed URLs, and asset identifiers.
- Align Android attachment storage strategy with scoped-storage-safe defaults and remove legacy external storage dependence.

## Capabilities

### New Capabilities
- `lesson-detail-real-api-source`: Establishes real API lesson detail as the source of truth for lesson rendering metadata.
- `lesson-detail-infra-reliability`: Establishes deterministic behavior for initial fetch, background refresh, error propagation, and retry readiness.
- `attachment-download-safety`: Defines resilient attachment download/open flows with safe exception handling and scoped-storage-compatible file persistence.

### Modified Capabilities
- `lesson-content-orchestration`: Updates requirement expectations around lesson-detail loading/error states so orchestration can recover via retry instead of indefinite spinner paths.

## Impact

- Affected code: `packages/courses` providers/repository and lesson-detail widgets, `packages/core` SDK/data/network support, Android manifest/storage-related behavior in `app`.
- Runtime behavior: lesson detail is loaded from real API metadata with explicit cache/error policy, refresh failures become explicit/recoverable, and attachment failures become non-crashing.
- Dependencies/systems: TPStreams/Testpress SDK init path, Dio error handling, scoped storage behavior on Android.
