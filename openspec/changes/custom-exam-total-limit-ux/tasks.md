## 1. Builder Screen UI Updates

- [x] 1.1 Calculate `usedQuestions` and `remainingQuota` dynamically in `CustomExamBuilderScreen`'s `build` method.
- [x] 1.2 Update the `+ Add Questionnaire` button logic to be disabled when `remainingQuota < 5`.
- [x] 1.3 Update the `+ Add Questionnaire` button label to dynamically show "Add Questionnaire", "Add More Questionnaires", or "Limit Reached ($used/$total)".
- [x] 1.4 Add a descriptive text element above or near the blocks list displaying the global budget (e.g., "Total Questions: $used / $total").

## 2. Subject Bottom Sheet Updates

- [x] 2.1 Calculate `usedQuestions` and `remainingQuota` in `CustomExamSubjectBottomSheet`'s `_buildContent` method.
- [x] 2.2 Update the slider's `maxVal` calculation to use `remainingQuota` instead of `config.limits.maxQuestionsPerTest`.
- [x] 2.3 Modify the `_saveBlock` method to strictly clamp `_noOfQuestions` to the `remainingQuota` to prevent the default 15 from bypassing the limit.
- [x] 2.4 Add a small hint text above or below the slider indicating the remaining available questions for clarity.
