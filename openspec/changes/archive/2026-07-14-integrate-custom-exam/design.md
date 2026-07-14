## Context

The backend recently added a "Custom Exam" feature, which allows users to generate tailored exams from specific courses. The feature requires an interface on the Flutter client (`cortex`) to let users select an eligible course, configure the exam parameters (subjects, difficulty, question types, and number of questions), and submit the request. 
The entry points will be a Floating Action Button (FAB) in the "Exam" tab and an option in the app drawer.

## Goals / Non-Goals

**Goals:**
- Provide entry points (FAB in Exam tab, App Drawer menu item) to start the Custom Exam flow.
- Display a list of courses that have `allow_custom_test=true`.
- Dynamically render filter options (dropdowns, chips) based on the `/custom-test-config/` response for the selected course.
- Enforce the `max_questions_per_test` limit using a slider or input field.
- Check and display remaining `daily_attempts_available` and `monthly_attempts_available`.
- Show an appropriate error or lock the generation process if attempts are exhausted.
- Route to the appropriate post-generation screen (or exam player) by interpreting the API response upon generation.

**Non-Goals:**
- Creating custom exams that combine questions from *multiple* courses (this is strictly a single-course feature).
- Offline support for generating custom exams (requires active backend validation).
- Storing the fetched courses (`allow_custom_test=true`) in the local database. These should be fetched and held in memory only for the purpose of selection.

## Decisions

- **Entry Points Navigation**: We will add a new route, e.g., `/custom-exam-course-selection`. The FAB in the Exams tab and the drawer item will both push this route.
- **State Management**: We will use a standard state management approach (likely BLoC or Provider, matching the existing `cortex` app architecture) to fetch the initial course list and subsequent configuration options.
- **Limit Handling**: We will fetch the configuration first. If `daily_attempts_available == 0` or `monthly_attempts_available == 0`, we can still allow the user to see the configuration screen but we will disable the "Generate" button and show a clear error message/banner explaining why it's locked. (Alternatively, show an alert dialog immediately when they try to proceed, as per user's suggestion).
- **Generation Endpoint & Post-Generation Routing**: We will implement a POST request to generate the exam. Based on the response (which is expected to contain the generated exam ID or attempt details), we will navigate the user to the appropriate screen (either a summary screen or directly into the player).

## Risks / Trade-offs

- **[Risk]** The configuration endpoint `/custom-test-config/` might return empty subjects or difficulty levels if a course has questions that lack metadata.
  - **Mitigation**: The UI must gracefully handle empty lists (e.g., hiding the Subject dropdown if no subjects are returned) and ensure the payload sent for generation is still valid.
- **[Risk]** The user's limits might run out while they are lingering on the configuration screen (e.g., they generated one on the web concurrently).
  - **Mitigation**: Ensure the generation API call gracefully handles a "Limits Exhausted" 400/403 error from the backend and updates the UI accordingly.
