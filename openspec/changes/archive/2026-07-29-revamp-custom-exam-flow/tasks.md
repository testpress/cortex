## 1. Data & API Layer

- [x] 1.1 Create `QuestionnaireBlock` data model (subjects, no_of_questions, difficulty_levels, question_types).
- [x] 1.2 Create the API response model for `GET /custom-test-config/` (subjects flat list, difficulties, question types, test modes, limits).
- [x] 1.3 Add repository method for `GET /api/v3/courses/{course_id}/custom-test-config/` to fetch the builder configuration.
- [x] 1.4 Update `CustomExamRepository` `POST` method to accept `test_mode` and the new `questionnaires` array payload.

## 2. State Management

- [x] 2.1 Create `CustomExamBuilderState` and Notifier/Bloc to manage the `List<QuestionnaireBlock>` and current drill-down navigation state.
- [x] 2.2 Implement state action: add a new block to the list.
- [x] 2.3 Implement state action: remove an existing block from the list.
- [x] 2.4 Implement subject ID resolution logic (empty `[]` for root "All", parent ID for parent-level "All", specific ID for leaf subject).

## 3. UI Implementation (Builder Screen)

- [x] 3.1 Create the base `CustomExamBuilderScreen` with an empty state and a prominent "+ Add Subject" button.
- [x] 3.2 Implement the subject chip row with drill-down navigation (tapping a parent immediately replaces chips with its children).
- [x] 3.3 Implement the configuration inputs (number of questions, multi-select difficulty chips, multi-select question type chips).
- [x] 3.4 Implement the "Save" action that creates a block and adds it to the state.
- [x] 3.5 Implement the Summary Card widget showing subject name, question count, difficulty levels, and question types.
- [x] 3.6 Wire up the "+ Add more subjects" button to reset the drill-down and start the subject selection flow again.
- [x] 3.7 Implement the "Remove" action on each Summary Card.

## 4. Mode Selection & Submission

- [x] 4.1 Implement the sticky "Next" button that is disabled until at least one block is configured.
- [x] 4.2 Implement the Mode Selection dialog/bottom sheet presenting "Practice Quiz" and "Regular Exam" options.
- [x] 4.3 Wire up the "Start Exam" button to the POST API call, passing `test_mode` and the `questionnaires` array.
- [x] 4.4 Handle HTTP 403 error from the POST call and display the backend's detail error message to the user.
- [x] 4.5 On successful POST response, navigate the user into the exam player using the returned `userexam.id`.
