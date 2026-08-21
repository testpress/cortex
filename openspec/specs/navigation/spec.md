# navigation Specification

## Purpose
TBD - created by archiving change standardize-tab-headers. Update Purpose after archive.
## Requirements
### Requirement: Smart Root Tab Navigation
Primary content screens acting as root tabs MUST provide access to the global drawer navigation menu, and switch to a back button when pushed as a sub-page.

#### Scenario: User navigates to root tab
- **WHEN** the user is viewing the Study, Exam, Info, Profile, or AI tab as a root bottom-navigation destination
- **THEN** the system displays a Hamburger Menu icon in the top-left of the static header
- **THEN** tapping the icon opens the global side drawer

#### Scenario: User pushes screen as sub-page
- **WHEN** the user navigates to the Profile screen by pushing it onto the navigation stack
- **THEN** the system displays a standard Back button in the top-left of the static header

### Requirement: Subpage Back Button Navigation
All nested screens pushed onto the root tab navigation stack SHALL show a back button in the header.

#### Scenario: User navigates to immersive chat
- **WHEN** the user is viewing the immersive chat screen
- **THEN** the header displays a back button to return to the AI root screen

