# Design

## Context

OTP generation is exposed through the core auth provider, repository, and API service. The initial phone-login screen calls that API without a delivery-channel argument; the backend interprets omission as SMS. The OTP screen currently offers one resend action. `AppConfig.apiBaseUrl` is a compile-time URL and is shared by auth and settings requests.

## Goals / Non-Goals

**Goals:**
- Keep delivery selection in the existing auth generation path and preserve the initial request payload.
- Gate the additional resend action using the parsed API host, not substring matching.
- Allow build-time opt-in without changing the existing host allowlist behavior.
- Reuse current resend timing and busy/error feedback.
- Preserve the existing inline SMS-only layout and provide a minimum 48dp target for its resend action.

**Non-Goals:**
- Change OTP verification, registration, or backend behavior.
- Add configurable hosts or a general channel-selection framework.

## Decisions

- Parse the API base URL with `Uri.tryParse` and compare normalized `host` values against the three exact configured hosts. Also allow `SHOW_WHATSAPP_OTP_OPTION=true` to enable channel actions on other hosts. This avoids enabling the feature for lookalike domains by default while retaining an explicit build-time opt-in.
- Represent supported delivery channels with a typed enum and serialize its lowercase name. Keep the argument optional so the initial flow omits it; pass a channel explicitly only from resend actions.
- Use the same `generateOtp` method across the API service, repository, and provider. An optional channel avoids duplicate resend pass-through methods while preserving the distinct initial and resend payloads.
- Use the existing OTP resend screen and countdown. On configured hosts, expose separate SMS and WhatsApp actions; elsewhere retain a single SMS action. This avoids introducing a second screen or timer state.
- Keep the SMS-only prompt and resend action in the existing inline `Row`. Give the resend action a semantic label and at least a 48dp square hit target.
- Keep configuration immutable in production. Widget tests use an optional immutable screen-level override rather than mutating global AppConfig state.
- Add localization entries to all supported core ARB files and regenerate the existing localization outputs rather than editing generated code manually.

## Risks / Trade-offs

- [The backend may reject an unexpected channel value] → Use the agreed lowercase values `sms` and `whatsapp`; validate request payloads with focused service tests.
- [A host spelling or URL parsing difference can hide the WhatsApp action] → Test exact matches, non-matches, case normalization, and URLs with paths/trailing slashes; support explicit compile-time opt-in for other builds.
- [Two resend buttons may need more vertical space] → Stack them using existing full-width design-system buttons and preserve scroll behavior.

## Migration Plan

No persisted data or endpoint migration is required. Deploy the client change after the backend supports the WhatsApp channel. Rolling back the client restores the existing SMS-only resend UI and default-SMS initial request.
