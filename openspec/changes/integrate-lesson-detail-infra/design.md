## Context

The lesson-detail stack currently mixes partial cached rows, background refresh, and mock-friendly fallback behavior. This means lesson viewers can start from incomplete metadata instead of a real lesson-detail payload from the API. We need to make the real lesson-detail API the source of truth from initial load, with explicit recovery when refresh fails.

## Goals / Non-Goals

**Goals:**
- Treat the real lesson-detail endpoint as authoritative for renderable metadata from initial load.
- Keep API-version drift manageable by normalizing `v2.4` detail payloads with explicit compatibility expectations for `v2.5/v3`.
- Define unambiguous ID mapping between detail and completion endpoints.
- Guarantee deterministic lesson-detail loading behavior for first load and cached-incomplete load paths.
- Ensure background refresh failures are surfaced through provider contracts so route/UI layers can offer retry.
- Make attachment download error handling exception-safe and non-crashing.
- Align Android attachment storage approach with scoped-storage-compatible behavior.
- Remove sensitive diagnostics from production paths (auth token, OTP, signed media URLs, asset IDs).

**Non-Goals:**
- Visual redesign of lesson-detail screens.
- Reworking exams/test engines.
- Adding offline HTML caching.
- Full route architecture redesign.

## Decisions

### 1. Deterministic provider refresh states
- Decision: treat first-load and cached-incomplete paths differently.
- Rationale: first-load must hydrate from real API metadata; cached-incomplete should stream cache + refresh result and surface refresh errors.
- Alternative considered: always silent background refresh. Rejected because it reintroduces indefinite loader risk.

### 1a. Explicit offline/cache policy
- Decision: define first-load behavior as API-required; define complete-local-row behavior as cache-usable with background refresh.
- Rationale: avoids ambiguous UX where incomplete local rows masquerade as final render data.
- Alternative considered: always fallback to stale local rows. Rejected because it hides data quality issues and can break viewer requirements.

### 2. Error propagation over suppression for incomplete lessons
- Decision: propagate refresh errors on incomplete cached rows instead of using silent `.ignore()`.
- Rationale: incomplete local rows are not a valid replacement for real API detail; error must be visible for retry.
- Alternative considered: timeout fallback to null row. Rejected due to ambiguous state transitions.

### 2a. API version compatibility guardrails
- Decision: keep detail loading on current `/api/v2.4/contents/{content_id}/` contract but normalize parser expectations and document forward-compatibility checks for `v2.5/v3` fields.
- Rationale: current endpoint is available and implemented, but compatibility must be explicit to avoid future drift.
- Alternative considered: immediate endpoint migration as part of this infra change. Rejected to keep blast radius limited.

### 2b. ID-space mapping contract
- Decision: treat lesson route parameter as `content_id` for detail reads and require a deterministic mapping to `chapter_content_id` before completion writes.
- Rationale: detail and completion endpoints operate in different ID spaces.
- Alternative considered: using the same `{id}` blindly for both calls. Rejected as ambiguous and brittle.

### 3. Safe exception typing in attachment download flow
- Decision: remove forced exception casts and use type guards (`e is DioException`) before cancel checks.
- Rationale: prevents crash-on-error paths when non-Dio exceptions occur.
- Alternative considered: catch `DioException` only. Rejected because other runtime exceptions can still occur in I/O path.

### 4. Scoped-storage-safe attachment directory strategy
- Decision: prefer app-scoped external storage (`getExternalStorageDirectory`) with fallback to app documents directory.
- Rationale: avoids legacy permissions and Play policy friction while keeping open-file behavior intact.
- Alternative considered: public Download directory + legacy permissions. Rejected due to policy and compatibility concerns.

### 4a. External open/share contract
- Decision: define attachment open behavior via content-URI-compatible sharing/opening path (FileProvider-compatible semantics) from app-scoped files.
- Rationale: app-scoped storage alone does not guarantee external app readability.
- Alternative considered: raw file path sharing. Rejected due to permission-denied risks on modern Android.

### 5. Sensitive diagnostics policy
- Decision: apply a no-sensitive-logging policy to auth tokens, OTP, signed media URLs, and asset identifiers in lesson-detail-related flows.
- Rationale: these values are security-sensitive and not required in production logs.
- Alternative considered: partial masking only at one call site. Rejected as incomplete.

## Risks / Trade-offs

- [Risk] Refresh failures are now surfaced more often, potentially increasing visible error states.
  - Mitigation: route-level retry affordance and explicit user messaging.
- [Risk] API-version assumptions may drift as upstream evolves.
  - Mitigation: parser normalization and documented version-compatibility tests/checklist.
- [Risk] Completion calls can fail if ID mapping is incorrect.
  - Mitigation: explicit `content_id -> chapter_content_id` mapping contract and test coverage.
- [Risk] App-scoped storage may reduce user visibility in generic file managers.
  - Mitigation: keep explicit open-file action and media scan where applicable.
- [Risk] External apps may fail to open app-scoped files without URI sharing semantics.
  - Mitigation: define and validate content-URI-compatible open/share behavior.
- [Risk] Existing consumers that assume partial local rows are immediately renderable may require adaptation.
  - Mitigation: keep error/retry path explicit and keep complete-cache path non-blocking.

## Migration Plan

1. Make lesson-detail provider/repository API-first for initial render metadata.
2. Add/verify version-normalization and ID-mapping behavior in repository/provider path.
3. Define and verify attachment external-open contract from app-scoped storage.
4. Remove sensitive diagnostics in lesson-detail-related initialization/runtime paths.
5. Verify analyzer/tests and manual flows for first-load, cached-incomplete, and retry paths.
6. Remove legacy storage permissions and validate download/open behavior on Android 10+ and 13+.
7. Keep complete-cache path non-blocking while preserving DB stream updates.

Rollback strategy:
- Revert the provider/repository and attachment safety changes together; no schema-level migration coupling beyond existing additive fields.

## Open Questions

- Should refresh error state be normalized into a typed domain error (instead of generic exception surface) in this change or follow-up?
- Do we want an explicit stale-cache banner when serving cached incomplete metadata before refresh completes?
- Should we migrate detail loading endpoint to `v2.5/v3` in a follow-up once compatibility validation is complete?
