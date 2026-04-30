# Capability: LMS Navigation Shell

## MODIFIED Requirements

### Requirement: Client-specific profile slot
The navigation shell SHALL adapt its primary destinations based on the active client configuration and tenant requirements.

#### Scenario: Standard Client Navigation
- **WHEN** the client configuration does not enable the Info experience and is not in restricted mode
- **THEN** the shell MUST display the standard primary destinations: Home, Study, Explore, Profile.

#### Scenario: Info-enabled Standard Navigation
- **WHEN** the client configuration enables the Info experience and is not in restricted mode
- **THEN** the shell MUST support 5 destinations: Home, Study, Explore, Info, Profile.

#### Scenario: Brilliant Pala Restricted Navigation
- **WHEN** the client is identified as "brilliantpala"
- **THEN** the shell MUST display exactly these destinations: Home, Study, Exam, Info.
- **AND** the "Explore" and "Profile" tabs SHALL be removed from the primary navigation.
