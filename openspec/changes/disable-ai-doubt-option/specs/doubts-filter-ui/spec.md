## MODIFIED Requirements

### Requirement: Doubts Type Filter Chips
The UI SHALL provide a way to filter the doubts list between "ALL", "AI", and "MENTOR" types when AI doubts are enabled. When AI doubts are disabled (`enableAiDoubt` is false), the entire filter chips bar SHALL be hidden since all doubts belong solely to mentors.

#### Scenario: Filter selection updates the list
- **GIVEN** `enableAiDoubt` is true
- **WHEN** the user selects the "AI" filter chip
- **THEN** the doubts list is updated to show only AI-related doubts

#### Scenario: Filter chips bar hidden when AI doubts are disabled
- **GIVEN** `enableAiDoubt` is false
- **WHEN** the user views the doubts list
- **THEN** the filter chips bar SHALL be omitted completely from the screen

#### Scenario: Filter state ignored and reset when AI doubts are disabled
- **GIVEN** `enableAiDoubt` is false
- **WHEN** the user opens the doubts list (even with an initial filter or deep link)
- **THEN** the active query filter SHALL be reset to `null` (All) so no hidden filter restricts the doubts list

