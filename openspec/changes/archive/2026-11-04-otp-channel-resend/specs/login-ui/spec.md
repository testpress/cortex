## ADDED Requirements

### Requirement: OTP resend channel actions
The OTP verification screen SHALL expose resend actions according to the current API host and SHALL label each delivery channel clearly.

#### Scenario: Display OTP resend channel actions on configured hosts
- **WHEN** the current API base URL host is `lmsdemo.testpress.in`, `staging.testpress.in`, or `cortexlms.testpress.in`
- **AND** the OTP resend countdown has expired
- **THEN** the OTP verification screen SHALL offer separate localized actions to resend the code through SMS and WhatsApp

#### Scenario: Keep SMS-only resend on other hosts
- **WHEN** the current API base URL host is not one of the configured WhatsApp OTP hosts
- **AND** the OTP resend countdown has expired
- **THEN** the OTP verification screen SHALL retain its existing SMS resend action

#### Scenario: Resend countdown and busy feedback
- **WHEN** either channel-specific resend action is available
- **THEN** both actions SHALL respect the existing resend countdown and busy state
- **AND** successful resend feedback SHALL identify the selected delivery channel
