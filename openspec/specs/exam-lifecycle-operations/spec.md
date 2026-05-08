# exam-lifecycle-operations Specification

## Purpose
TBD - created by archiving change exam-api-contract. Update Purpose after archive.
## Requirements
### Requirement: Exam Action Operations
The `DataSource` interface and its implementations (`HttpDataSource`, `MockDataSource`) SHALL support retrieving attempts and initiating/ending sections.

#### Scenario: Start and End Section Lifecycle
- **WHEN** `startSection` is called with a section ID or URL
- **WHEN** `endSection` is called with a section ID or URL
- **THEN** the API returns the updated section/attempt payload successfully

