## MODIFIED Requirements

### Requirement: Upstream Data Hydration (No UI Fetching)

#### Scenario: Navigating from Dashboard / Resume Learning
- **WHEN** the user navigates directly to a lesson from a Dashboard widget (like Resume Learning) without first downloading the course chapter list
- **THEN** the Ask Doubt screen SHALL safely fallback to the cached lesson properties (chapter title and subject name) to display the context breadcrumb
