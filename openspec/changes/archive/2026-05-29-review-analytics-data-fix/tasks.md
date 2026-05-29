## 1. AttemptDto — Add `timeTaken` field

- [x] 1.1 Add `timeTaken: String?` field to `AttemptDto` class definition
- [x] 1.2 Map `time_taken` from the attempt JSON in `AttemptDto.fromJson` (check both `json` and `data` nested keys, consistent with other fields)
- [x] 1.3 Include `timeTaken` in `AttemptDto.toJson` if it exists

## 2. ReviewRoutePayload — Add `ExamDto`

- [x] 2.1 Add `exam: ExamDto?` optional field to `ReviewRoutePayload`
- [x] 2.2 Remove `elapsedSeconds` and `totalDurationSeconds` fields added in a previous partial fix (these are now superseded by `ExamDto.duration` and `AttemptDto.timeTaken`)

## 3. TestDetailScreen — Forward ExamDto at navigation

- [x] 3.1 In `_openAnalytics`, populate `exam: state.exam` in `ReviewRoutePayload`
- [x] 3.2 Remove `elapsedSeconds` and `totalDurationSeconds` from the payload construction and the `_parseDurationString` helper (no longer needed)

## 4. Route Builders — Pass ExamDto to Screen

- [x] 4.1 In `exams_routes.dart` `review-analytics` builder: pass `payload?.exam` as `exam` to `ReviewAnalyticsScreen`
- [x] 4.2 In `study_routes.dart` `review-analytics` builder: pass `payload?.exam` as `exam` to `ReviewAnalyticsScreen`

## 5. ReviewAnalyticsScreen — Accept ExamDto

- [x] 5.1 Add `exam: ExamDto?` parameter to `ReviewAnalyticsScreen`
- [x] 5.2 Remove `elapsedSeconds` and `totalDurationSeconds` parameters from `ReviewAnalyticsScreen`
- [x] 5.3 Pass `exam` into `ReviewAnalyticsParam`

## 6. ReviewAnalyticsParam — Accept ExamDto

- [x] 6.1 Add `exam: ExamDto?` optional field to `ReviewAnalyticsParam`
- [x] 6.2 Remove `elapsedSeconds` and `totalDurationSeconds` from `ReviewAnalyticsParam`

## 7. ReviewAnalyticsController — Use API data, remove all hardcoding

- [x] 7.1 Replace `timeTaken` computation with `attempt.timeTaken` parsed via `_parseDurationToSeconds`. Show `null` if absent.
- [x] 7.2 Replace `totalTime` computation with `param.exam?.duration` parsed via `_parseDurationToSeconds`. Fallback: `timeTaken + attempt.remainingTime`. Show `null` if neither is available.
- [x] 7.3 Remove `Duration(minutes: 10)` hardcoded fallback for `timeTaken`
- [x] 7.4 Remove `Duration(minutes: totalQs * 2)` hardcoded fallback for `totalTime`
- [x] 7.5 Replace hardcoded `4.0` default for `derivedMarkPerQuestion` with `double.tryParse(param.exam?.markPerQuestion ?? '')`. Do not fall back to any number — use `null` and let the score show as `0` if absent.
- [x] 7.6 Remove the score recomputation heuristic (`scoreVal == correctCount → multiply by markPerQuestion`)
- [x] 7.7 Pass `rankEnabled: attempt.rankEnabled` into `AnalyticsOverview`
- [x] 7.8 In `_fetchSubjectAnalytics`, source `markPerQuestion` and `negativeMarks` from `param.exam` instead of re-deriving from the attempt score string
- [x] 7.9 Remove the `elapsedSeconds` / `totalDurationSeconds` path from the controller entirely

## 8. AnalyticsOverview — Add `rankEnabled`

- [x] 8.1 Add `rankEnabled: bool?` field to `AnalyticsOverview`

## 9. MetricsGrid — Conditional rank display

- [x] 9.1 Hide the Overall Rank metric card entirely when `overview.rankEnabled != true`
- [x] 9.2 Remove the `overallRank == 0 && totalParticipants == 0 → show '–'` logic (replaced by `rankEnabled` check)

## 10. Verification

- [x] 10.1 Run `flutter analyze` across `packages/exams`, `packages/core`, `packages/testpress` — zero issues
- [x] 10.2 Confirm Time Taken shows the actual elapsed time from the API after exam submission
- [x] 10.3 Confirm Total Time shows the exam's configured duration
- [x] 10.4 Confirm Score displays the raw API value without recomputation
- [x] 10.5 Confirm Rank row is hidden when `rank_enabled` is false in the attempt response
- [x] 10.6 Confirm section scores use `ExamDto.markPerQuestion` — no `4.0` default
- [x] 10.7 Confirm Overall Performance bar reflects the correct score percentage

## 11. Data Parsing Fixes (Post-Verification)

- [x] 11.1 Score string parsing: Convert score string "6.00/6.00" using `double.tryParse` before rounding, since `int.tryParse` fails on floats.
- [x] 11.2 Course-linked Exams marking scheme fallback: Ensure `_initializeExam` forwards `markPerQuestion` and `negativeMarks` from the `cachedExam` when building synthetic `ExamDto`, and add attempt-level fallback.
- [x] 11.3 Subject Accuracy parsing: Compute `correctPercentage` from `correct / total * 100` if the API omits `correct_percentage` in `SubjectAnalyticsDto`.
- [x] 11.4 Max Score fallback: Compute `maxScore` dynamically (`totalQs * markPerQuestion`) if the API score string omits the max score (e.g. returns `"6.00"` instead of `"6.00/6.00"`) or if the score string is `null`.
- [x] 11.5 UI Polish: Set `padding: EdgeInsets.zero` on the `MetricsGrid`'s `GridView.builder` to remove the awkward default excess spacing above the cards.
- [x] 11.6 Code Review Improvements: Simplify negative marking fallbacks (default to `0.0`) and improve duration parsing to safely ignore empty/invalid durations.
