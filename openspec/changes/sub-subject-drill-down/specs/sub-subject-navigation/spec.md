## ADDED Requirements

### Requirement: Tappable Non-Leaf Rows
Non-leaf subject rows in both the Overall Reports and Individual Reports views SHALL be tappable and navigate to the child subject analytics view. The chevron icon on non-leaf rows was already present as a visual indicator from the previous task.

#### Scenario: Tapping a non-leaf row in Overall Reports
- **WHEN** the user taps a bar chart row for a subject where `leaf == false`
- **THEN** the system SHALL push the route `/exams/analytics?parentId=<id>&subjectName=<encoded name>` onto the navigation stack

#### Scenario: Tapping a non-leaf row in Individual Reports
- **WHEN** the user taps any cell in a table row for a subject where `leaf == false`
- **THEN** the system SHALL push the route `/exams/analytics?parentId=<id>&subjectName=<encoded name>` onto the navigation stack

#### Scenario: Leaf rows are not interactive
- **WHEN** the user taps a row for a subject where `leaf == true`
- **THEN** no navigation SHALL occur
