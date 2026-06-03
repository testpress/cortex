# exam-input-question-types Specification

## Purpose
TBD - created by syncing delta specs from exam-input-question-support.

## Requirements

### Requirement: Short Answer Question Rendering
The exam player SHALL render Short Answer (`S`) type questions with a single-line text input field embedded in the question WebView.

#### Scenario: Viewing a short answer question
- **WHEN** the user navigates to a question with type `S`
- **THEN** the system SHALL render the question text followed by a single-line `<input type="text">` element with a `YOUR ANSWER` placeholder
- **AND THEN** no option list SHALL be shown

#### Scenario: Pre-populated answer on resume
- **WHEN** the user resumes a paused attempt and navigates to a short answer question that was previously answered
- **THEN** the input field SHALL be pre-populated with the previously typed value from `QuestionDto.shortText`

#### Scenario: Answer persists across question navigation
- **WHEN** the user types a short answer and then navigates to another question and back
- **THEN** the typed text SHALL be preserved and displayed in the input field upon returning

### Requirement: Numerical Question Rendering
The exam player SHALL render Numerical (`N`) type questions with a single-line input field that enforces numeric-only input and triggers the decimal number keyboard on mobile.

#### Scenario: Viewing a numerical question
- **WHEN** the user navigates to a question with type `N`
- **THEN** the system SHALL render the question text followed by a single-line `<input inputmode="decimal">` element
- **AND THEN** the device's numeric/decimal keyboard SHALL appear when the field is focused

#### Scenario: Sanitization — commas are stripped
- **WHEN** the user types a value containing commas (e.g. `1,234`)
- **THEN** commas SHALL be removed automatically, leaving `1234`

#### Scenario: Sanitization — only one decimal point allowed
- **WHEN** the user types a value containing multiple decimal points (e.g. `1.2.3`)
- **THEN** only the first decimal point SHALL be retained, leaving `1.23`

#### Scenario: Sanitization — single leading negative sign
- **WHEN** the user types a negative value (e.g. `-42`)
- **THEN** exactly one leading dash SHALL be kept and the rest of the string SHALL be numeric

### Requirement: Essay Question Rendering
The exam player SHALL render Essay (`E`) type questions with a multi-row textarea embedded in the question WebView.

#### Scenario: Viewing an essay question
- **WHEN** the user navigates to a question with type `E`
- **THEN** the system SHALL render the question text followed by a multi-row `<textarea>` element
- **AND THEN** no option list SHALL be shown

#### Scenario: Essay text persists across navigation
- **WHEN** the user types essay content and then navigates to another question and back
- **THEN** the full essay text SHALL be preserved

### Requirement: Real-time Text Relay from WebView to Flutter
The system SHALL relay every keystroke from input-based question fields to the Flutter layer via the `MessageChannel` JS channel using a structured JSON message of the form `{"type":"inputChange","value":"<text>"}`.

#### Scenario: User types in an input field
- **WHEN** the user types or deletes characters in a Short Answer, Numerical, or Essay input
- **THEN** the WebView SHALL post a JSON message `{"type":"inputChange","value":"<current_text>"}` to `MessageChannel` on every change

#### Scenario: Flutter receives and stores the value
- **WHEN** Flutter receives an `inputChange` message on `MessageChannel`
- **THEN** the exam repository SHALL update the in-memory answer state for the current question with the new `shortText` value

### Requirement: Short Text Submission in Answer Payload
The system SHALL include the `short_text` field in the answer API request body when submitting answers for Short Answer, Numerical, or Essay question types.

#### Scenario: Submitting a short answer
- **WHEN** the exam flushes pending answers to the backend
- **THEN** the API payload for `S`, `N`, or `E` type questions SHALL include `"short_text": "<typed_value>"`
- **AND THEN** `selected_answers` SHALL be an empty list for these question types
