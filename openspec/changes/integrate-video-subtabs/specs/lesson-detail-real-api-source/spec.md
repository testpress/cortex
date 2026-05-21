## MODIFIED Requirements

### Requirement: Real API Is Source of Truth for Lesson Detail
The lesson detail system MUST treat the real lesson-detail API response as the authoritative source for renderable lesson metadata, including dynamic features like transcripts and AI notes.

#### Scenario: Initial lesson detail fetch
- **WHEN** A lesson detail is requested and local row is missing or incomplete
- **THEN** The system MUST fetch lesson detail from `/api/v2.4/contents/{id}/`.
- **AND** Viewer-critical fields MUST be hydrated from the API response before final rendering.
- **AND** The response MUST be parsed to populate `enable_transcript`, `video_subtitle`, `is_ai_enabled`, and `ai_notes_url`.

#### Scenario: Local row exists but is stale/incomplete
- **WHEN** A local row is available but lacks renderable metadata (including new subtab configuration fields)
- **THEN** The system MUST refresh from the real lesson-detail API.
- **AND** Local row data MUST be treated as transitional cache, not final truth.
