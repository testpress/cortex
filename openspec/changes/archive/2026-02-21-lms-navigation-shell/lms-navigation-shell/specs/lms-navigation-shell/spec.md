## ADDED Requirements

### Requirement: Persistent Navigation Shell
The system SHALL provide a persistent application shell containing the `AppTabBar` that remains visible across all primary navigation roots.

#### Scenario: Switching between tabs
- **WHEN** the user is on the "Home" tab and clicks the "Study" icon in the tab bar
- **THEN** the system navigates to the Study screen while maintaining the shell visibility

### Requirement: Stateful Tab Preservation
The system MUST preserve the state of each tab independently to avoid re-initializing screens upon switching back.

#### Scenario: Returning to a previous tab
- **WHEN** the user scrolls down on the "Study" tab, switches to "Profile", and then switches back to "Study"
- **THEN** the "Study" tab remains at the same scroll position as when it was left

### Requirement: Exclusive Full-screen Views
The system SHALL support views that occupy the entire screen, hiding the navigation shell (e.g., for immersive reading or video playback).

#### Scenario: Opening a lesson
- **WHEN** the user selects a lesson from the course list
- **THEN** the system navigates to a full-screen view where the `AppTabBar` is no longer visible

### Requirement: Sub-routing within Tabs
Each primary tab SHALL support its own stack of push/pop navigation without affecting the other tabs.

#### Scenario: Navigating within Study tab
- **WHEN** the user clicks a course in the "Study" tab to see chapters
- **THEN** the chapter list is pushed onto the study tab's local stack, and the "Back" action returns them to the course list within that same tab
