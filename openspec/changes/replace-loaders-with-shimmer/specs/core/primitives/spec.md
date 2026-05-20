# Capability: Neutral UI & Primitives

## ADDED Requirements

### Requirement: Shared Loading Primitives Remain Unchanged
The shared `AppLoadingIndicator` SHALL continue to serve as the compact indeterminate loading primitive for the app.

#### Scenario: Button loading state
- **WHEN** an action button is submitting or waiting on a brief request
- **THEN** the button MAY display `AppLoadingIndicator`
- **AND** the button content SHALL remain compact and centered

#### Scenario: Non-structural wait state
- **WHEN** a widget has no stable content skeleton to present
- **THEN** it MAY use `AppLoadingIndicator` instead of a structural placeholder
