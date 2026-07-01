## MODIFIED Requirements

### Requirement: Breadcrumb Hierarchy Structure
The Ask a Doubt screen header SHALL display a breadcrumb hierarchy. Line 1 SHALL contain a sequence of context strings separated by a chevron icon. Line 2 SHALL contain the Topic Name preceded by a content-type icon.

#### Scenario: Displaying the breadcrumb
- **WHEN** the user opens the Ask a Doubt screen
- **THEN** they see the dynamic list of breadcrumbs on the first line, and the Topic name on the second line

### Requirement: Balanced Truncation
The dynamic breadcrumb strings on Line 1 SHALL use balanced truncation to ensure elements remain visible when space is limited.

#### Scenario: Displaying multiple breadcrumbs
- **WHEN** multiple breadcrumbs are provided and space is limited
- **THEN** the breadcrumbs SHALL be truncated evenly with ellipses to share the horizontal space
