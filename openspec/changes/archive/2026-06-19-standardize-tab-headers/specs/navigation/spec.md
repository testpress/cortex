## ADDED Requirements

### Requirement: Smart Root Tab Navigation
Primary content screens acting as root tabs MUST provide access to the global drawer navigation menu, and switch to a back button when pushed as a sub-page.

#### Scenario: User navigates to root tab
- **WHEN** the user is viewing the Study, Exam, Info, or Profile tab as a root bottom-navigation destination
- **THEN** the system displays a Hamburger Menu icon in the top-left of the static header
- **THEN** tapping the icon opens the global side drawer

#### Scenario: User pushes screen as sub-page
- **WHEN** the user navigates to the Profile screen by pushing it onto the navigation stack
- **THEN** the system displays a standard Back button in the top-left of the static header
