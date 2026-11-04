## Tasks

- [x] Add and test `AppConfig.showWhatsAppOTPoption` for the three specified hosts.
- [x] Support resend channel selection in OTP generation: omit `channel` for the initial request, send `sms` or `whatsapp` for resends, and test the resulting payloads.
- [x] Use one `generateOtp` method with an optional channel across the auth layers.
- [x] Update and test the OTP screen: show localized SMS and WhatsApp resend options on configured hosts, keep SMS-only elsewhere, and preserve existing countdown and request feedback.
- [x] Format, analyze, and run focused host, API payload, and OTP UI tests.
