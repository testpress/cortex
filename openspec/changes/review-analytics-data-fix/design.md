## Context

The `ReviewAnalyticsScreen` displays post-exam metrics — score, time taken, total time, mark-per-question, and rank. These values are currently derived using a mix of client-side computation, invented heuristics, and hardcoded defaults, because the controller does not read several fields that the API already returns in the attempt response, and because the `ExamDto` (which carries authoritative exam-level metadata) is dropped before the analytics screen is reached.

**Current broken paths:**
- `timeTaken` → computed from `totalDurationSeconds - remainingSeconds` from section data, falls back to hardcoded `Duration(minutes: 10)` when sections are absent.
- `totalTime` → computed from `totalQs * 2 minutes`, not from the actual exam duration.
- `markPerQuestion` → falls back to hardcoded `4.0` when absent from the attempt response.
- `score` → a heuristic recomputes it when `scoreVal == correctCount`, which has no API contract.
- `rank` → shown as `–` or `0/0` even when `rankEnabled` is false.

**Root cause:** Two missing data flows:
1. `AttemptDto` does not map the `time_taken` field that the attempt end API already returns.
2. `ExamDto` (loaded at exam start, carries `duration`, `markPerQuestion`, `negativeMarks`) is never forwarded into the `ReviewRoutePayload` — it is dropped at the point of navigation.

## Goals / Non-Goals

**Goals:**
- Read `time_taken` directly from the attempt API response and surface it as `timeTaken` in `AttemptDto`.
- Forward `ExamDto` through `ReviewRoutePayload` so analytics can use `duration`, `markPerQuestion`, and `negativeMarks` from the authoritative source.
- Remove all hardcoded numeric defaults (`4.0` for marks, `10` minutes for time, `totalQs * 2` for total time).
- Remove the invented score recomputation heuristic.
- Conditionally hide the rank row using `attempt.rankEnabled` instead of showing placeholder values.
- Show `–` for any metric that is genuinely unknown rather than fabricating a value.

**Non-Goals:**
- Changing how the subject analytics API is called or what data it returns.
- Changing the overall layout, design, or navigation of the analytics screen.
- Fixing any server-side data issues (e.g. rank computation delay is expected and handled by hiding the row when not enabled).

## Decisions

### Decision 1: Read `time_taken` from the attempt API, not from computed elapsed time

**Choice:** Add `timeTaken: String?` to `AttemptDto`, mapped from `time_taken` in the attempt JSON.

**Rationale:** The attempt end API response already includes a `time_taken` field computed server-side. Computing elapsed time from `totalDuration - remainingSeconds` is fragile — it requires both section duration and remaining time to be present in the end-exam response, which they often are not. The server-computed value is the ground truth.

**Alternative considered:** Continue computing elapsed time in the client using `DateTime.now() - examStartTime`. Rejected because it would require storing exam start time, adds complexity, and would still be wrong if the exam was paused/resumed.

---

### Decision 2: Forward `ExamDto` via `ReviewRoutePayload`

**Choice:** Add `exam: ExamDto?` to `ReviewRoutePayload`. Populate it from `state.exam` in `TestDetailScreen._openAnalytics`. Pass it through the route builder to `ReviewAnalyticsScreen` and then into `ReviewAnalyticsParam`.

**Rationale:** `ExamDto` is already loaded and present in `ExamAttemptState` at the time the user submits the exam. It carries `duration` (total exam time), `markPerQuestion`, and `negativeMarks` — all authoritative values. The cost is one additional field on the payload; the benefit is eliminating all guessing in the controller.

**Alternative considered:** Re-fetch the exam detail in the analytics controller. Rejected because the exam is already loaded — fetching it again is wasteful and adds a network dependency to the analytics screen.

---

### Decision 3: Remove score recomputation heuristic entirely

**Choice:** Display `attempt.score` as parsed — `scoreVal / maxScoreVal` from the API string, no multiplication.

**Rationale:** The heuristic `if (scoreVal == correctCount && markPerQuestion > 1) → scoreVal = correct * markPerQuestion` was added to compensate for a suspected API quirk. However, there is no confirmed API contract for this. Applying it risks inflating the score for cases where the numerator legitimately equals the correct count (e.g. 1-mark-per-question exams). The score string from the API is the authoritative value.

**Alternative considered:** Use `attempt.percentage` to back-calculate score. Rejected because `percentage` is also a string and introduces the same parsing uncertainty.

---

### Decision 4: Hide rank row when `rankEnabled` is not `true`

**Choice:** Pass `attempt.rankEnabled` into `AnalyticsOverview` and hide the rank metric card entirely when it is `false` or `null`.

**Rationale:** Showing `0/0` or `–` for rank when rank is not enabled is confusing. The `rankEnabled` field is already parsed in `AttemptDto`. Hiding the row is the correct behaviour — consistent with how other optional fields are handled in the analytics screen.

---

### Decision 5: Use `ExamDto.duration` for total time; fallback is `timeTaken + remainingTime`

**Choice:** In priority order: (1) `ExamDto.duration` parsed as `HH:mm:ss`. (2) `attempt.timeTaken + attempt.remainingTime` added as durations. (3) `null` — show `–` in the UI.

**Rationale:** `ExamDto.duration` is the configured exam duration, not a derived value. The `timeTaken + remainingTime` fallback works for non-sectioned exams where section data is absent but both individual fields are present in the attempt response. If neither is available, showing `–` is correct.

## Risks / Trade-offs

- **`ExamDto` may be null** (analytics accessed from history, not immediately after exam) → The controller already handles `attempt == null`; all `ExamDto`-sourced fields are optional and fall back to `null` (displayed as `–`).
- **`time_taken` may be `null` in the API response** for older attempts or non-standard flows → Handled: `AttemptDto.timeTaken` is `String?`; controller shows `–` when null.
- **Score display may look wrong to users comparing against expectations** → This is expected — the score shown is what the API computed. Any discrepancy is a server-side data issue, not a client bug.
- **`markPerQuestion` absent from `ExamDto`** in some exam types → `ExamDto.markPerQuestion` is `String?`; if null, subject-level score calculation returns `0` and the column shows `0` rather than a guess.
