## Context

Currently, the `ExamPrescreen` provides exam metadata and allows users to start or resume an exam, but lacks visibility into past completions. 
Additionally, the prescreen currently has an early-return bug when loading a standalone `testId` without a pre-fetched `lesson`, which displays a blank black screen instead of utilizing the built-in skeleton loading UI (`isMetadataLoading`).

## Goals / Non-Goals

**Goals:**
- Display a clean table of previous completed attempts (Date, Score, Correct, Incorrect, Action).
- Ensure smooth skeleton loading while the history is fetched.
- Enable seamless navigation to review detailed analytics for past attempts.
- Fix the existing skeleton loading bug on `ExamPrescreen`.

**Non-Goals:**
- Offline persistence of historical attempts.

## Decisions

- **Decision 1: Direct API Fetching** ➔ We will use the existing `examAttemptsProvider(attemptsUrl)` inside `ExamPrescreen`. We will filter the results to only those where `state == 'Completed'`. This avoids the complexity of database modeling for a feature that only requires transient data presentation.
- **Decision 2: Lazy Review Routing** ➔ When navigating to `/review-analytics` or `/review-answers`, we will construct a `ReviewRoutePayload` with empty `questions` and `attemptStates` maps, and supply the `AttemptDto`. The review screens are already architected to detect the missing local questions and dynamically fetch them from `ApiEndpoints.solutionsReview(attempt.id)` using the provided attempt payload.
- **Decision 3: Fix Skeleton Loader** ➔ We will remove the early return `if (lesson == null && lessonDetailAsync.isLoading)` from `ExamPrescreen.build`. This allows the UI tree to correctly process the `isMetadataLoading` condition and render the built-in skeletons immediately.

## Risks / Trade-offs

- **[Risk] Null `attemptsUrl` for standalone exams** ➔ Mitigation: UI will gracefully return a `SizedBox.shrink()` if `attemptsUrl` is null or empty.
- **[Risk] Loading State Blocking Main UI** ➔ Mitigation: Only the history table section will show skeletons; the rest of the prescreen metadata (top half) will load immediately to avoid blocking the user.
