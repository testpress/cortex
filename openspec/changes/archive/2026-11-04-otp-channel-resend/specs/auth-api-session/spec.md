## ADDED Requirements

### Requirement: OTP generation delivery channel
The auth API service SHALL preserve the existing initial default-SMS OTP request and SHALL support explicit delivery channels for OTP resend requests.

#### Scenario: Initial OTP generation
- **WHEN** a user submits a phone number to begin OTP login
- **THEN** the app SHALL send the existing OTP generation request without a `channel` field
- **AND** the backend SHALL use its default SMS delivery channel

#### Scenario: Resend OTP through SMS
- **WHEN** a user requests another OTP through SMS
- **THEN** the OTP generation request SHALL include `channel: sms`
- **AND** the phone number and country code identity SHALL remain unchanged

#### Scenario: Resend OTP through WhatsApp
- **WHEN** a user requests another OTP through WhatsApp
- **THEN** the OTP generation request SHALL include `channel: whatsapp`
- **AND** the phone number and country code identity SHALL remain unchanged
