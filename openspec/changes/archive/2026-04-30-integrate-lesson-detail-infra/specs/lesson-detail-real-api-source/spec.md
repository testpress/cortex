## ADDED Requirements

### Requirement: Real API Is Source of Truth for Lesson Detail
The lesson detail system MUST treat the real lesson-detail API response as the authoritative source for renderable lesson metadata.

#### Scenario: Initial lesson detail fetch
- **WHEN** A lesson detail is requested and local row is missing or incomplete
- **THEN** The system MUST fetch lesson detail from `/api/v2.4/contents/{id}/`.
- **AND** Viewer-critical fields MUST be hydrated from the API response before final rendering.

#### Scenario: Local row exists but is stale/incomplete
- **WHEN** A local row is available but lacks renderable metadata
- **THEN** The system MUST refresh from the real lesson-detail API.
- **AND** Local row data MUST be treated as transitional cache, not final truth.

### Requirement: API Version Compatibility Contract
The lesson-detail integration MUST document and enforce compatibility expectations for the current detail endpoint and adjacent API versions.

#### Scenario: Current detail endpoint usage
- **WHEN** Lesson detail is fetched
- **THEN** The integration MUST use the current supported detail endpoint contract.
- **AND** The contract MUST explicitly define normalized fields required for rendering.

#### Scenario: Version drift handling
- **WHEN** Upstream payload shape differs between `v2.4`, `v2.5`, or `v3` structures
- **THEN** Parser normalization MUST preserve required lesson-detail fields.
- **AND** Incompatible payloads MUST surface explicit errors rather than silent fallback.

### Requirement: Content ID and Chapter Content ID Mapping
The integration MUST define and use explicit mapping between detail-read IDs and completion-write IDs.

#### Scenario: Detail fetch ID
- **WHEN** A lesson detail is requested from route/navigation context
- **THEN** The request MUST use `content_id` for detail fetch.

#### Scenario: Completion sync ID
- **WHEN** A lesson completion attempt is posted
- **THEN** The request MUST use the resolved `chapter_content_id`.
- **AND** The mapping from `content_id` to `chapter_content_id` MUST be deterministic and testable.

### Requirement: Explicit Cache and Offline Behavior
The integration MUST define behavior for first-load failures and cache-available states.

#### Scenario: First load without complete local data
- **WHEN** No complete local row is available and detail API request fails
- **THEN** The system MUST emit an explicit error state with retry capability.
- **AND** It MUST NOT present incomplete metadata as final lesson detail.

#### Scenario: Complete local row available
- **WHEN** A complete local row exists
- **THEN** The system MAY render from local cache immediately.
- **AND** It MUST refresh in background and reconcile updates.
