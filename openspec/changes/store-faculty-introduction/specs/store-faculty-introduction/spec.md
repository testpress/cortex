## ADDED Requirements

### Requirement: Instructor Overview Row
The system SHALL display an instructor overview row on the store product detail page when the product includes one or more faculty members.

#### Scenario: Product with multiple faculty members
- **WHEN** user views a product with multiple faculty members
- **THEN** system displays overlapping avatars and a summary formatted as "Taught by {First Name} and {Count} more"

#### Scenario: Product with a single faculty member
- **WHEN** user views a product with a single faculty member
- **THEN** system displays the avatar and "Taught by {Faculty Name}"

#### Scenario: Product without faculty members
- **WHEN** product has no assigned faculty members
- **THEN** overview row is omitted consuming zero layout space

#### Scenario: Tapping overview row
- **WHEN** user taps the instructor overview row
- **THEN** system scrolls the product detail view down to the "Meet your faculty" section

### Requirement: Meet Your Faculty Section
The system SHALL display a "Meet your faculty" section below the course curriculum and description on the product detail page.

#### Scenario: Display instructor cards
- **WHEN** section is displayed
- **THEN** system renders vertical cards showing instructor avatar, video badge, name, subjects, experience, and short bio snippet

#### Scenario: Expand faculty list
- **WHEN** product has more than 4 faculty members
- **THEN** system displays the first 4 cards with an expand button toggling full list visibility

### Requirement: Faculty Profile Screen
The system SHALL navigate to a dedicated full-page screen when an instructor card is selected.

#### Scenario: View faculty profile
- **WHEN** user selects an instructor card
- **THEN** system navigates to `FacultyProfileScreen` displaying the top header, 16:9 intro video player, credentials, highlights, qualifications, and biography

#### Scenario: Faculty without video
- **WHEN** faculty member has no introduction video
- **THEN** video container is omitted and profile content is displayed directly below the header

#### Scenario: Switch course introduction video
- **WHEN** instructor teaches multiple courses with separate intro videos and user selects an alternative course
- **THEN** active video player reloads to play the selected course video with a "Now showing" indicator
