## ADDED Requirements

### Requirement: Unified Exam Question and Option Rendering
The exam player SHALL render the question text and all of its options within a single `AppHtml` (WebView) instance to prevent the initialization overhead of multiple WebViews.

#### Scenario: Rendering question and options
- **WHEN** the user views a question card
- **THEN** the system generates a single HTML document containing the question, standard HTML inputs (radio buttons or checkboxes) for each option, and renders it in a single WebView

### Requirement: Capturing Option Selection from WebView
The system SHALL capture user interactions on HTML option inputs (radio or checkboxes) and propagate the selected option IDs back to the Flutter layer.

#### Scenario: User clicks an option
- **WHEN** the user taps an option rendered within the WebView
- **THEN** Javascript updates the visual checked state of the inputs and posts the new answer payload through a message channel
- **AND THEN** the Flutter layer receives the message and updates the exam attempt state

### Requirement: Enforce Deterministic Chapter Lesson Ordering
The chapter detail and curriculum retrieval logic SHALL enforce deterministic ordering of lessons/exams according to their `orderIndex` ascending.

#### Scenario: Displaying lessons and exams in a chapter
- **WHEN** the system retrieves cached lessons for a chapter from the local database
- **THEN** the query SHALL explicitly sort the results by `orderIndex` in ascending order to prevent random/arbitrary layout shifts and ensure correct pedagogical progression.

### Requirement: Structured JSON Communication Between WebView and Flutter
The WebView HeightChannel communication SHALL utilize structured JSON messages instead of raw string prefixes (like 'ready:') to ensure a robust, non-brittle API contract between JavaScript and Dart.

#### Scenario: Sending and parsing layout updates
- **WHEN** the WebView content is loaded or resized
- **THEN** the JavaScript SHALL post a stringified JSON payload with 'event' and 'height' fields to the HeightChannel
- **AND THEN** the Flutter layer SHALL safely decode the JSON to extract the height and ready state.

### Requirement: HTML Generation Separation of Concerns
HTML generation logic for exam question cards SHALL be isolated in dedicated builder classes, keeping widget files focused on layout only.

#### Scenario: Active exam question rendering
- **WHEN** the system builds HTML for an active exam question
- **THEN** `TestQuestionHtmlBuilder.build(...)` SHALL produce the complete HTML/CSS/JS string
- **AND THEN** `TestQuestionCard` SHALL only pass that output to `AppHtml` and wire up callbacks

#### Scenario: Review mode question rendering
- **WHEN** the system builds HTML for a review-mode question
- **THEN** `ReviewQuestionHtmlBuilder.build(...)` SHALL produce the complete HTML/CSS string with colour-coded options and explanation

### Requirement: Bounded WebView Lifecycle to Prevent OOM
The exam player SHALL NOT keep visited question WebViews permanently alive in memory. WebViews MUST be eligible for disposal when their question card scrolls off screen.

#### Scenario: Navigating through a large question set
- **WHEN** the user navigates through many questions in a long exam (100+ questions)
- **THEN** the system SHALL allow Flutter to dispose off-screen WebViews naturally
- **AND THEN** memory usage SHALL remain bounded regardless of total question count
- **AND THEN** the previously selected answer SHALL still display correctly on re-entry because answer state is preserved in the Riverpod exam state, not in the widget
