## ADDED Requirements

### Requirement: Synchronous Theme Preference Persistence
The system SHALL persist display theme preferences (`appearance_mode`) to native key-value storage (`SharedPreferences` / `NSUserDefaults`) and pre-load them before rendering `runApp()` to guarantee zero asynchronous loading fallback on app start.

#### Scenario: Cold start theme restoration
- **WHEN** the application cold starts after being completely closed
- **THEN** the initial frame MUST mount with the user's saved `DesignMode` from native key-value storage
- **AND** it MUST NOT fall back to system default theme during initial database load
