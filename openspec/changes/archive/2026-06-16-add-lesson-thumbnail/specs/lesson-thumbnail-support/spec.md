## ADDED Requirements

### Requirement: Cover Image Mapping
The system SHALL parse the 16:9 `cover_image` field from the backend JSON strictly into the `image` property in `LessonDto` without falling back to the `icon` field.

#### Scenario: Backend provides cover_image
- **WHEN** the backend payload contains a non-null `cover_image`
- **THEN** `LessonDto.image` is populated with the `cover_image` URL

#### Scenario: Backend lacks cover_image
- **WHEN** the backend payload does not contain `cover_image`
- **THEN** `LessonDto.image` is assigned `null`

### Requirement: Render 16:9 Lesson Thumbnail
The system SHALL display lesson items with a 16:9 image container in the UI.

#### Scenario: Lesson has a cover image
- **WHEN** rendering a lesson in the list AND `LessonDto.image` is not null
- **THEN** the UI provides a 16:9 container and fits the image gracefully using `BoxFit.cover`

#### Scenario: Lesson lacks a cover image
- **WHEN** rendering a lesson in the list AND `LessonDto.image` is null
- **THEN** the UI provides the same 16:9 container with the lesson's `typeTheme.background` color
- **AND** the local fallback vector icon is centered within it.
