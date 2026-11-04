## Why

The OTP flow currently supports only one resend action. Users on selected institute hosts need the option to receive the verification code through WhatsApp as well as SMS, while SMS remains the default delivery channel.

## What Changes

- Add a host-specific `showWhatsAppOTPoption` capability for `lmsdemo.testpress.in`, `staging.testpress.in`, and `cortexlms.testpress.in`.
- Keep the initial OTP request unchanged; the backend defaults delivery to SMS when `channel` is omitted.
- On the OTP verification screen, offer SMS and WhatsApp resend actions when the capability is enabled; retain the existing SMS resend behavior on other hosts.
- Include the selected `channel` (`sms` or `whatsapp`) on every OTP resend request.
- Localize the channel-specific labels and feedback.
- Use one auth `generateOtp` method with an optional channel for both initial sends and resends.

## Capabilities

### Modified Capabilities
- `auth-api-session`: OTP generation accepts an explicit delivery channel.
- `login-ui`: OTP resend offers channel choices on configured hosts.

## Impact

- Affected code: `packages/core/lib/data/config/app_config.dart`, auth API/provider/repository files, `packages/profile/lib/screens/mobile_login_screen.dart`, `packages/profile/lib/screens/otp_screen.dart`, and core localization resources.
- The OTP generation endpoint accepts an optional `channel`; the initial request omits it to preserve the backend's default SMS delivery, while resend requests explicitly include their selected channel.
