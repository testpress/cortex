## 1. Data Layer

- [x] 1.1 Create/Update API endpoints in the network module for fetching custom exam eligible courses (`/api/v3/courses/?allow_custom_test=true`).
- [x] 1.2 Create/Update API endpoints for fetching custom exam configuration (`/api/v3/courses/<course_id>/custom-test-config/`).
- [x] 1.3 Add models (DTOs) for the custom test configuration response (subjects, difficulty levels, limits, etc.).
- [x] 1.4 Add models (DTOs) for the custom exam generation request payload and response.
- [x] 1.5 Implement repositories/data sources to interact with these endpoints, ensuring fetched courses are NOT persisted to the local database.

## 2. State Management (Domain Layer)

- [x] 2.1 Create BLoC/Cubit to manage the course selection state (fetching and holding eligible courses in memory).
- [x] 2.2 Create BLoC/Cubit to manage the custom exam configuration state (fetching config, handling filter selections, and enforcing attempt limits).

## 3. UI Layer

- [x] 3.1 Implement the Custom Exam Course Selection screen showing the in-memory list of eligible courses.
- [x] 3.2 Implement the Custom Exam Configuration screen UI with dropdowns/chips for subjects, difficulties, and question types.
- [x] 3.3 Implement the question count slider/input enforcing the `max_questions_per_test` limit.
- [x] 3.4 Implement limit indicators (`daily_attempts`, `monthly_attempts`) and locked state handling (e.g., displaying error when limits are 0).
- [x] 3.5 Add the Custom Exam entry point (FAB) in the Exam tab.
- [x] 3.6 Add the Custom Exam entry point in the App Drawer.

## 4. Integration and Routing

- [x] 4.1 Define routes for the new Custom Exam screens in the app router.
- [x] 4.2 Connect the Generate button to trigger the API request and handle navigation based on the backend response.
