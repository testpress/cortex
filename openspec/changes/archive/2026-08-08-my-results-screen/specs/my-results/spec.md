## ADDED Requirements

### Requirement: Results Drawer Toggle
The system SHALL provide a remote configuration flag to toggle the visibility of the "My Results" menu item in the dashboard drawer.

#### Scenario: Config is enabled
- **WHEN** `SHOW_EXAM_RESULTS` is set to true in `AppConfig`
- **THEN** the "My Results" item appears in the dashboard drawer

#### Scenario: Config is disabled
- **WHEN** `SHOW_EXAM_RESULTS` is set to false in `AppConfig`
- **THEN** the "My Results" item is hidden from the dashboard drawer

### Requirement: Tabular Results Display
The system SHALL display a horizontally scrollable table showing exam results separated by "Model Exam" and "Weekly Exam" tabs.

#### Scenario: Viewing Model Exams
- **WHEN** the user navigates to the "My Results" screen and selects the "Model Exam" tab
- **THEN** the system displays a table of Model Exam scores with subjects, ranks, and grades

#### Scenario: Viewing Weekly Exams
- **WHEN** the user selects the "Weekly Exam" tab
- **THEN** the system displays a table of Weekly Exam scores with subjects, ranks, and grades

### Requirement: SSL Bypass for IP Address
The system SHALL connect to the specific IP address for the results API by explicitly trusting its certificate.

#### Scenario: Fetching results over external IP
- **WHEN** the API client sends a POST request to `65.108.62.51/studentexamapi`
- **THEN** the request succeeds without throwing a HandshakeException for an invalid certificate
