## ADDED Requirements

### Requirement: Home Screen Relocation to App Shell
The system SHALL host the main application dashboard (`PaidActiveHomeScreen`) within the `testpress` app package to serve as the high-integrity feature orchestrator.

#### Scenario: Successful Dashboard Orchestration
- **WHEN** the student navigates to the main application dashboard
- **THEN** the system MUST render the `PaidActiveHomeScreen` from the `testpress` package.

---

### Requirement: Domain Decoupling
The system SHALL maintain a strict architectural boundary where domain packages (e.g., `courses`) do not house the primary application entry screen.

#### Scenario: Home Screen Independence
- **WHEN** the `courses` package is analyzed or compiled
- **THEN** it MUST NOT export or internalize the `PaidActiveHomeScreen`.
- **AND** the app-level shell (testpress) MUST be the only source of the main dashboard.
