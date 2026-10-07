## ADDED Requirements

### Requirement: Search Bar Clear Button Visibility
The system SHALL display a trailing clear (`x`) button inside `AppSearchBar` when and only when the search field contains non-empty text.

#### Scenario: Search input is empty
- **WHEN** the search field contains no text
- **THEN** the trailing clear button is omitted from the UI.

#### Scenario: Search input contains text
- **WHEN** the user enters one or more characters into the search field
- **THEN** the trailing `LucideIcons.x` icon button appears on the right edge of the search bar.

---

### Requirement: Search Bar Clear Action
The system SHALL reset the input text and notify listeners when the clear button is tapped.

#### Scenario: User taps clear button
- **WHEN** the user taps the clear button
- **THEN** the text in the active controller is cleared (`''`)
- **AND** `onChanged('')` is called
- **AND** `onClear()` is invoked if provided
- **AND** the clear button disappears from the search bar.

---

### Requirement: Accessibility & Touch Target Standards
The system SHALL provide an accessible semantic button role and a minimum 48×48dp touch target for the clear action.

#### Scenario: Screen reader announces clear button
- **WHEN** assistive technologies focus on the clear button
- **THEN** the button is announced with a localized label ("Clear search", "தேடலை அழி", "തിരയൽ മായ്ക്കുക", "مسح البحث") or custom `clearSemanticLabel` override
- **AND** no duplicate tap actions are emitted to the accessibility tree.

#### Scenario: Touch area dimensions
- **WHEN** the clear button is rendered
- **THEN** its hit area has a minimum size of 48×48dp (`BoxConstraints(minWidth: 48, minHeight: 48)`)
- **AND** `AppSearchBar` maintains a consistent fixed `height: 48` whether empty or filled to prevent layout shifts.
