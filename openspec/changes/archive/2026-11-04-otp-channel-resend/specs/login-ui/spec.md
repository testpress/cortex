## ADDED Requirements

### Requirement: OTP resend channel actions
The OTP verification screen SHALL expose resend actions according to the current API host or the compile-time `SHOW_WHATSAPP_OTP_OPTION` flag, label each delivery channel clearly, and provide accessible interaction targets.

#### Scenario: Display OTP resend channel actions on configured hosts
- **WHEN** the current API base URL host is `lmsdemo.testpress.in`, `staging.testpress.in`, or `cortexlms.testpress.in`
- **AND** the OTP resend countdown has expired
- **THEN** the OTP verification screen SHALL offer separate localized actions to resend the code through SMS and WhatsApp

#### Scenario: Enable channel actions through compile-time configuration
- **WHEN** the app is built with `SHOW_WHATSAPP_OTP_OPTION=true`
- **AND** the OTP resend countdown has expired
- **THEN** the OTP verification screen SHALL offer separate localized actions to resend the code through SMS and WhatsApp, regardless of API host

#### Scenario: Keep SMS-only resend on other hosts
- **WHEN** the current API base URL host is not one of the configured WhatsApp OTP hosts
- **AND** the app is built without `SHOW_WHATSAPP_OTP_OPTION=true`
- **AND** the OTP resend countdown has expired
- **THEN** the OTP verification screen SHALL retain its existing SMS resend action
- **AND** the resend action SHALL have a semantic label and a hit target at least 48dp high and wide

#### Scenario: Keep the existing SMS-only resend layout
- **WHEN** SMS-only resend is shown
- **THEN** the prompt and resend action SHALL remain in the existing inline layout

#### Scenario: Resend countdown and busy feedback
- **WHEN** either channel-specific resend action is available
- **THEN** both actions SHALL respect the existing resend countdown and busy state
- **AND** successful resend feedback SHALL identify the selected delivery channel
