## Purpose

Provides centralized, robust error and exception tracking for the testpress shell module, capturing unexpected bookmark modifications and announcements loading errors.

## ADDED Requirements

### Requirement: Bookmarks Modification Error Tracking
The system SHALL capture unexpected errors when modifying bookmarks or bookmark folders and report them to Sentry.

#### Scenario: Failed to delete a bookmark folder
- **WHEN** deleting a bookmark folder fails due to an unexpected repository error
- **THEN** the system catches the exception, reports it to Sentry, and displays a toast message to the user.

#### Scenario: Failed to remove a bookmark
- **WHEN** removing a single bookmark fails due to an unexpected repository error
- **THEN** the system catches the exception, reports it to Sentry, and displays an error toast.

### Requirement: Announcements Fetching Error Tracking
The system SHALL capture unexpected pagination/fetching errors for announcements and report them to Sentry.

#### Scenario: Failed to load more announcements
- **WHEN** fetching the next page of announcements fails during infinite scrolling
- **THEN** the system catches the exception, reports it to Sentry, and displays a generic error toast.
