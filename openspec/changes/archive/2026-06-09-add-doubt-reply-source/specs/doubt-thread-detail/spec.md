## MODIFIED Requirements

### Requirement: Chronological Reply Thread
The system SHALL display all replies in chronological order, clearly distinguishing mentor replies with a "Mentor" badge and the mentor's avatar. 
- **AI Bot Identification**: If a reply has a `source` of "Bot" (or equivalent AI source), the system SHALL override the author's display name to "AI Bot Response".
- **Bot Mentor Badge**: If a reply has a `source` of "Bot" AND `isMentor` is true, the system SHALL display a "Bot" badge instead of the standard "Mentor" badge.

#### Scenario: Viewing AI Bot replies
- **WHEN** an AI Bot has responded to the doubt and `isMentor` is true
- **THEN** the reply appears in the thread with the display name "AI Bot Response" and a "Bot" badge instead of the usual author name and "Mentor" badge.

#### Scenario: Viewing mentor replies
- **WHEN** a human mentor has responded to the doubt
- **THEN** the reply appears in the thread with a "Mentor" badge and the author's actual name.
