## ADDED Requirements

### Requirement: Parallelized Question Loading
The network data source SHALL fetch paginated questions concurrently in parallel to minimize initial load time.

#### Scenario: Concurrent page retrieval
- **WHEN** the first page of questions is successfully retrieved and indicates multiple pages exist
- **THEN** the remaining pages SHALL be requested concurrently in parallel.

### Requirement: Debounced Answer Submissions
The exam repository SHALL debounce answer submission network calls per question while updating the local state optimistically.

#### Scenario: Option selected within debounce window
- **WHEN** user selects an option for a question
- **THEN** it SHALL update the local state immediately but delay the API request by a debounce duration.

#### Scenario: Multiple selections on the same question
- **WHEN** user changes options multiple times within the debounce window
- **THEN** only the final answer state SHALL be sent to the server.

#### Scenario: Flushing pending submissions
- **WHEN** the exam is ended or session is reset
- **THEN** any pending debounced answers SHALL be flushed and sent to the server immediately.
