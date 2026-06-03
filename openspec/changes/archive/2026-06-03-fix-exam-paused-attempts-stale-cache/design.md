## Context

When a user submits/ends an exam, the app updates the local cache (`paused_attempts_count` set to `0`) and records the timestamp in an in-memory variable `_lastLocalPausedUpdate`. During the subsequent 5 minutes, background revalidation fetches (which may hit a stale CDN return where `paused_attempts_count` is still `1`) are ignored. However, if the user restarts the app (killing the process), the in-memory timestamp is lost. When the app reopens, the background revalidation fetch runs, receives the stale CDN response, and overwrites the local cache, reverting the CTA button to "Resume".

## Goals / Non-Goals

**Goals:**
- Persist the timestamp of the last local update to the paused attempts count across app restarts.
- Ensure that if the app is closed and reopened within 5 minutes of ending or pausing an exam, stale background fetch API responses do not overwrite the accurate local count.

**Non-Goals:**
- Altering the SQLite/Drift database schema (which would require database migrations).
- Introducing new external state management packages.

## Decisions

### 1. Store the Update Timestamp in `examMetadataJson`
- **Option A (Chosen)**: Add a `last_local_paused_update` ISO 8601 string key directly to the exam metadata JSON saved in `LessonsTable.examMetadataJson`.
  - *Rationale*: Since the metadata is already stored as a JSON string in SQLite, we can inject a custom metadata field without needing to modify the database schema or run migration scripts. `ExamDto.fromJson` ignores extra keys, making this fully backward-compatible.
- **Option B**: Store the timestamp in a separate key-value store (e.g. `SharedPreferences`).
  - *Rationale*: Requires importing/injecting preference managers, managing string/key namespaces, and is less cohesive than keeping all exam metadata cached in a single DB field.

### 2. Retain the 5-Minute Revalidation Threshold
- **Decision**: Keep the 5-minute timeout. If a local update occurred less than 5 minutes ago, any background fetch will preserve the local `paused_attempts_count` value and also forward the update timestamp so it isn't cleared by the fetch.

### 3. Terminate Active Section in `endExam`
- **Decision**: Before calling the main attempt's end URL, check if there is an active running section, and if so, call `_dataSource.endSection(currentSection.endUrl)`.
  - *Rationale*: A running section blocks the backend attempt from transitioning to `'Completed'`. Terminating the active section first guarantees correct attempt completion.

## Risks / Trade-offs

- **[Risk]** The backend CDN might take longer than 5 minutes to clear/update its cache.
  - *Mitigation*: 5 minutes is a standard and robust window for standard CDN caching TTLs. Increasing it too much risks ignoring actual updates made on other devices.
- **[Risk]** `ExamDto.fromJson` or serialization errors.
  - *Mitigation*: `ExamDto.fromJson` accesses keys explicitly and does not restrict extra fields, so adding `last_local_paused_update` is safe.

## Verification Plan

### Automated/Manual Tests
- Start an exam, pause/exit it (CTA says "Resume").
- End/submit the exam (CTA changes to "Start").
- Force close the app.
- Re-open the app within 5 minutes, navigate back to the exam.
- Verify that the CTA button still says "Start" (and does not revert to "Resume").
