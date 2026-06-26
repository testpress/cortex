## ADDED Requirements

### Requirement: Header — Replace "Back" text with the screen title

The header SHALL replace the "Back" text and chevron with the inline screen title and standard arrow, removing the large title below.

#### Scenario: Viewing the header
- Given the user is on a review analytics screen
- When they look at the top app bar
- Then they SHALL see a standard back arrow
- And they SHALL see the screen title inline next to the arrow
- And the large screen title below the app bar SHALL be removed

---

### Requirement: "Performance Overview" title — Reduce size

The "Performance Overview" heading SHALL be sized appropriately as a standard section heading.

#### Scenario: Viewing the Performance Overview section
- Given the user is on the Review Analytics landing screen
- When they view the Performance Overview section
- Then the heading SHALL be visually smaller than the header title

---

### Requirement: "Explore More Details" — Break out of the box

The "Explore More Details" section SHALL display its label as a standalone heading outside of any box, and its items SHALL be rendered as independent cards.

#### Scenario: Viewing the Explore More Details section
- Given the user is on the Review Analytics landing screen
- When they scroll to the Explore More Details section
- Then the section label SHALL be displayed outside and above the cards
- And the two action items SHALL be rendered as separate, independent cards

---

### Requirement: Subject-wise Performance — Reduce section title sizes

The "Overall Performance" and "Section Performance" headings SHALL be sized consistently with standard app section headings.

#### Scenario: Viewing Subject-wise Performance
- Given the user is on the Subject-wise Performance screen
- When they view the Overall or Section performance areas
- Then the section headings SHALL use a standard smaller heading size

---

### Requirement: Subject-wise Performance — Center the donut chart(s)

The section donut charts SHALL be dynamically centered if they fit on screen, or left-aligned if they overflow.

#### Scenario: Viewing section donut charts
- Given the user is viewing the Section Performance list
- When all donut cards fit within the screen width
- Then the list of cards SHALL be centered horizontally
- When the donut cards exceed the screen width
- Then the list SHALL be horizontally scrollable and left-aligned
