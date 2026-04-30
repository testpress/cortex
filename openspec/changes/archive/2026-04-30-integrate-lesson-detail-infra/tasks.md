## 1. Real API Source of Truth

- [x] 1.1 Ensure lesson detail initial loading is sourced from `/api/v2.4/contents/{id}/` when local data is missing/incomplete.
- [x] 1.2 Keep local cache as read-through state, not final truth, for incomplete lesson rows.
- [x] 1.3 Add/verify parser normalization coverage for `v2.4` detail payload and forward-compatibility checks for `v2.5/v3` shape differences.

## 2. Lesson Detail Reliability

- [x] 2.1 Update `lessonDetail` provider flow to separate first-load, cached-incomplete, and complete-cache refresh behavior.
- [x] 2.2 Ensure incomplete-cache refresh failures propagate as provider error states (no silent indefinite loading).
- [x] 2.3 Keep complete-cache refresh non-blocking while preserving DB stream updates.

## 3. Attachment Download Safety

- [x] 3.1 Replace unsafe download exception handling with type-guarded cancellation checks.
- [x] 3.2 Keep attachment viewer in explicit `error` state for non-cancel failures and verify no crash path.
- [x] 3.3 Switch attachment persistence to app-scoped storage directories compatible with scoped storage.
- [x] 3.4 Remove legacy permission-dependent code paths from attachment download logic.
- [x] 3.5 Implement and validate external-open URI contract for app-scoped files (content-URI/FileProvider-compatible behavior).

## 4. Security and Platform Hygiene

- [x] 4.1 Remove sensitive SDK auth token logging from initialization flow.
- [x] 4.2 Remove legacy external storage permissions and legacy external storage flag from Android manifest.
- [x] 4.3 Validate attachment download/open behavior on Android 10+ and 13+ after manifest/storage updates.
- [x] 4.4 Audit lesson-detail-related diagnostics to ensure no tokens, OTP, signed URLs, or raw asset identifiers are logged.
