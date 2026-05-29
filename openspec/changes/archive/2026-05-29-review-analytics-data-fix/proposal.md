## Why

The Review Analytics screen displays several metrics that are incorrect or fabricated — including Time Taken, Total Time, Score, and mark-per-question values — because the controller derives these from guesses and hardcoded defaults instead of reading values the API already provides. This results in misleading analytics data even when the user's actual performance is good.

## What Changes

- **Add `timeTaken` field to `AttemptDto`** — read `time_taken` directly from the attempt API response instead of computing elapsed time from `totalDuration - remainingSeconds`.
- **Remove hardcoded time fallbacks** — the `Duration(minutes: 10)` and `Duration(minutes: totalQs * 2)` fallbacks in the controller will be replaced with null, and the UI will show `–` when data is genuinely unavailable.
- **Forward `ExamDto` through the route payload** — `ExamDto` carries `duration`, `markPerQuestion`, `negativeMarks`, and `totalMarks` from the exam detail API. These are the authoritative values and must be passed through `ReviewRoutePayload` to the analytics screen instead of being dropped at navigation time.
- **Remove hardcoded `markPerQuestion` default of `4.0`** — this value must come from `ExamDto.markPerQuestion`. If the API does not provide it, no fallback should be assumed.
- **Remove the score recomputation heuristic** — the logic that detects `scoreVal == correctCount` and multiplies by `markPerQuestion` is an invented rule with no API contract behind it. Score must be displayed as returned by the API; any mismatch is a data concern, not something to fix in the client.
- **Hide Rank row when `rankEnabled` is false** — the `attempt.rankEnabled` field is already parsed in `AttemptDto` but never used in the analytics screen. The rank row should be hidden entirely when `rankEnabled != true`, not shown as `–` or `0/0`.
- **Use `ExamDto.duration` for Total Time** — instead of computing total time from `totalQs * 2`, use `ExamDto.duration` (e.g. `"00:20:00"`) which is the actual configured exam duration. As a fallback when `ExamDto` is unavailable, use `timeTaken + remainingTime` from the attempt.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `lms-review-analytics`: Requirements for Time Taken, Total Time, Score, Mark Per Question, and Rank display are changing — metrics must be sourced from API-provided fields only, with no client-side guessing or hardcoded defaults.
- `exam-review-analytics`: `AttemptDto` gains a new `timeTaken` field mapped from the attempt API response.

## Impact

- **`packages/core/lib/data/models/attempt_dto.dart`** — add `timeTaken` field
- **`packages/exams/lib/models/review_route_payload.dart`** — add `examDto` field to carry `ExamDto`
- **`packages/exams/lib/screens/review_analytics/review_analytics_controller.dart`** — remove hardcoded defaults, use `ExamDto` fields and `attempt.timeTaken` directly
- **`packages/exams/lib/screens/review_analytics/review_analytics_screen.dart`** — pass `examDto` through to `ReviewAnalyticsParam`
- **`packages/exams/lib/screens/review_analytics/widgets/metrics_grid.dart`** — conditionally hide rank row based on `rankEnabled`
- **`packages/exams/lib/screens/test_detail_screen.dart`** — pass `state.exam` into the route payload when opening analytics
- **`packages/testpress/lib/navigation/routes/exams_routes.dart`** — forward `examDto` from payload to screen
- **`packages/testpress/lib/navigation/routes/study_routes.dart`** — forward `examDto` from payload to screen
