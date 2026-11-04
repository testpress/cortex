## Tasks

- [x] Add and test `AppConfig.showWhatsAppOtpOption` for the three specified hosts and compile-time opt-in.
- [x] Support resend channel selection in OTP generation: omit `channel` for the initial request, send `sms` or `whatsapp` for resends, and test the resulting payloads.
- [x] Use one `generateOtp` method with an optional channel across the auth layers.
- [x] Update and test the OTP screen: show localized SMS and WhatsApp resend options on configured hosts and preserve existing countdown and request feedback.
- [x] Give the SMS-only resend action a semantic label and minimum 48dp target, preserving the existing inline layout.
- [x] Validate that the channel-specific resend options render.
- [x] Format, analyze, and run focused host, API payload, and OTP UI tests.
