## Context

The backend enforces a total question limit (e.g. 200 questions) for a Custom Exam. However, the current frontend UI limits the slider only on a per-block basis and does not validate the total across all selected subjects. This discrepancy leads to users creating exams that exceed the total limit, causing an API failure during generation. This design outlines how we will dynamically compute the remaining quota on the frontend to proactively constrain the UI.

## Goals / Non-Goals

**Goals:**
- Dynamically limit the question slider (`_noOfQuestions`) to the available remaining quota in the exam budget.
- Disable adding new subjects if the remaining budget is less than the minimum required block size (1).
- Prevent internal state desync when a user saves a block without interacting with the clamped slider.
- Provide clear visual context to the user about their remaining question budget.

**Non-Goals:**
- Changing the backend config format or API limits.
- Validating the maximum slider value against a subject's available question count (subject-specific limit). The focus is only on the global exam limit.
- Implementing an "Edit Block" capability. We will continue relying on the "Delete and Re-add" pattern for now.

## Decisions

- **Calculate Used Quota Dynamically in UI Build:** 
  The `customExamBuilderProvider` manages a list of `QuestionnaireBlock` objects. We can derive `usedQuestions` on the fly inside the `build` method of `CustomExamBuilderScreen` and `CustomExamSubjectBottomSheet`. This avoids adding complex state management for derived data.

- **Clamp `_noOfQuestions` Before Save:** 
  Since the slider visually clamps its maximum value, but the underlying state `_noOfQuestions` is initialized to 15, we must forcefully clamp it in `_saveBlock` against `remainingQuota`. If the remaining quota is 10 and the user doesn't touch the slider, clamping ensures that 10 is saved instead of 15.

- **Button UX State:** 
  We will enhance the `+ Add Questionnaire` button text dynamically:
  - If `blocks.isEmpty` and `remaining >= 1`: "+ Add Questionnaire"
  - If `blocks.isNotEmpty` and `remaining >= 1`: "+ Add More Questionnaires"
  - If `remaining < 1`: "Limit Reached ($usedLimit/$totalLimit)"

## Risks / Trade-offs

- **Risk:** The minimum block size was previously hardcoded as `5` in multiple places. If this changes, it might break the `< 1` logic.
  **Mitigation:** We introduced a shared constant `QuestionnaireBlock.minQuestions` (now `1`) to standardize this constraint and protect against silent overrides.
- **Trade-off:** Without an "Edit" button, users must delete and re-add blocks if they hit the limit and need to rebalance their allocations. This is acceptable for this scope as it prevents the critical generation crash.
