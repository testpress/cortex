## ADDED Requirements

### Requirement: Exam Detail Pre-Flight Summary
The exams package SHALL provide a `ExamPrescreen` that summarizes exam duration, question count, and marks.

#### Scenario: Summarizes metadata correctly
- **WHEN** a user visits an exam overview
- **THEN** it displays the duration, question count, and scoring schemes retrieved from the API

### Requirement: Historical Attempts Log
The `ExamPrescreen` SHALL fetch and present previous exam attempts in a structured table.

#### Scenario: Previous attempts rendered
- **WHEN** the previous attempts load successfully
- **THEN** it displays Date, Score, Correct and Incorrect counts with a review CTA

