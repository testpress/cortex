## Context

The Flutter application needs to display "My Results", a feature specifically requested for a particular institute (Brilliant Palla). Currently, this feature exists only in Android. The API is hosted at an IP address without a valid SSL certificate (`https://65.108.62.51/studentexamapi`). We need to implement the UI for displaying these results in a tabular format (Model and Weekly exams) and handle the network layer complexities of SSL bypass and external pagination.

## Goals / Non-Goals

**Goals:**
- Provide a horizontally scrollable UI to view detailed tabular exam results across two categories (Model and Weekly).
- Connect to the external student API via a custom Dio instance or HTTP override that bypasses SSL verification for the specific IP.
- Add a configuration flag in `AppConfig` to easily toggle this feature.
- Use `UserDto.username` from the current session as the `studentno` parameter in the API.

**Non-Goals:**
- Do not refactor existing Testpress APIs; this is an isolated API integration.
- Do not implement offline support or caching for these results in this iteration.

## Decisions

**Decision 1: Network Implementation for SSL Bypass**
We will create a specific Dio instance exclusively for `ExamResultApiService` within `packages/exams` rather than overriding the global `HttpOverrides`. This keeps the SSL bypass restricted to just this domain and minimizes security risks across the rest of the application.

**Decision 2: UI Tabular Implementation**
Because the API returns many columns (ranks, scores for multiple subjects), a standard `ListView` of cards won't provide the expected Excel-like experience. We will use a `DataTable` or a custom row component wrapped inside a `SingleChildScrollView(scrollDirection: Axis.horizontal)` to allow swiping to view all data.

**Decision 3: Location of the code**
All code models, providers, and UI will be scoped inside `packages/exams/lib/screens/results/`. This encapsulates the feature while allowing `dashboard_drawer.dart` in `testpress` to route to it.

## Risks / Trade-offs

- **Risk**: Hardcoding an IP address might break if the external server changes IP.
- **Mitigation**: We will define the base URL in a configuration file or constant so it can be updated easily if needed.

- **Risk**: Bypassing SSL validation is insecure against MITM attacks.
- **Mitigation**: We restrict this bypass only to the specific `65.108.62.51` API client, not the whole app.
