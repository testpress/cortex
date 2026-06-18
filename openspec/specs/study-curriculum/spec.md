# study-curriculum Specification

## Purpose
TBD - created by archiving change refactor-study-filters. Update Purpose after archive.
## Requirements
### Requirement: Curriculum filters act as toggles
The system SHALL treat curriculum filters as toggle buttons, allowing an unselected state.

#### Scenario: User toggles an active filter
- **WHEN** the user taps a curriculum filter chip that is currently active
- **THEN** the filter is deselected, and the curriculum list defaults to the Chapter Folder View

### Requirement: Folder view fallback
The system SHALL display the Folder View whenever no filter chip is active.

#### Scenario: Default view with no filters
- **WHEN** the user opens the curriculum list and no filters are active
- **THEN** the curriculum is grouped by Chapter folders

### Requirement: Flat view for "All" filter
The system SHALL flatten the curriculum view to show all lessons sequentially when the "All" filter is selected.

#### Scenario: User selects the All filter
- **WHEN** the user taps the "All" filter chip
- **THEN** the curriculum displays a flat list of all items across all chapters

