# Delta Spec: AI Tab Dynamic Visibility

## MODIFIED Requirements

### Requirement: AI Tab Navigation
The system SHALL provide an AI tab in the primary navigation shell when AI capabilities are enabled for the institute by the backend settings.

#### Scenario: AI tab is enabled in institute settings
- **GIVEN** `InstituteSettings.enableAiChatbot` is `true`
- **WHEN** primary navigation tabs are computed via `NavTab.active(settings)`
- **THEN** `NavTab.ai` is included in the active navigation tabs list

#### Scenario: AI tab is disabled or settings unavailable
- **GIVEN** `InstituteSettings.enableAiChatbot` is `false` or settings is `null`
- **WHEN** primary navigation tabs are computed via `NavTab.active(settings)`
- **THEN** `NavTab.ai` is excluded from the active navigation tabs list

#### Scenario: Config file decoupling
- **GIVEN** client configuration JSON files (e.g., `config/elearn_brilliantpala.json`)
- **WHEN** client settings are parsed
- **THEN** `SHOW_AI_TAB` is omitted and tab visibility is driven strictly by backend institute settings
