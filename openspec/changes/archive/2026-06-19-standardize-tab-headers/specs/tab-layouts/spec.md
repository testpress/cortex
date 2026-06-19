## ADDED Requirements

### Requirement: Static Headers for Primary Tabs
Primary content tabs MUST maintain a static header containing the screen title and primary navigation controls outside of the scrollable area.

#### Scenario: User scrolls tab content
- **WHEN** the user scrolls down the list of content in the Study, Exam, Info, or Profile tabs
- **THEN** the header area remains completely fixed at the top of the screen
- **THEN** only the content list area is affected by scroll physics
