## ADDED Requirements

### Requirement: Breadcrumb Hierarchy Structure
The Ask a Doubt screen header SHALL display a two-line breadcrumb hierarchy. Line 1 SHALL contain the Course Name and Chapter Name separated by a chevron icon. Line 2 SHALL contain the Topic Name preceded by a content-type icon.

#### Scenario: Displaying the breadcrumb
- **WHEN** the user opens the Ask a Doubt screen
- **THEN** they see the Course and Chapter names on the first line, and the Topic name on the second line

### Requirement: Balanced Truncation
The Course and Chapter names on Line 1 SHALL use balanced truncation to ensure both elements remain visible when space is limited.

#### Scenario: Both are Long
- **WHEN** both Course and Chapter names exceed available space equally
- **THEN** both names SHALL be truncated with ellipses, sharing the horizontal space equally

#### Scenario: Long Course, Short Chapter
- **WHEN** the Course name is long but the Chapter name is short
- **THEN** the Chapter name SHALL be fully visible, and the Course name SHALL be truncated using the remaining space

#### Scenario: Short Course, Long Chapter
- **WHEN** the Course name is short but the Chapter name is long
- **THEN** the Course name SHALL be fully visible, and the Chapter name SHALL be truncated using the remaining space

#### Scenario: Both are Short
- **WHEN** both names fit within the available space
- **THEN** neither name SHALL be truncated

#### Scenario: Extremely Long, Very Little Space
- **WHEN** space is extremely limited and both names are long
- **THEN** both names SHALL be truncated to a minimum width but remain visible with ellipses
