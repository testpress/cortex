import '../config/app_config.dart';

/// Builds a presigned SSO URL pointing to [nextPath] for WebViews.
///
/// Resolves the base domain from [domainUrl] (e.g. from institute settings),
/// falling back to [apiBaseUrl] or [AppConfig.apiBaseUrl]. Automatically
/// normalizes schemes (ensuring http/https), strips trailing slashes,
/// and encodes the [nextPath] query parameter.
String buildAuthenticatedSsoUrl({
  required String ssoPath,
  required String nextPath,
  String? domainUrl,
  String? apiBaseUrl,
}) {
  final encodedNextPath = Uri.encodeComponent(nextPath);

  String? formattedDomainUrl = domainUrl?.trim();

  if (formattedDomainUrl != null && formattedDomainUrl.isNotEmpty) {
    if (!formattedDomainUrl.startsWith('http://') &&
        !formattedDomainUrl.startsWith('https://')) {
      formattedDomainUrl = 'https://$formattedDomainUrl';
    }
  } else {
    final effectiveApiBase = (apiBaseUrl ?? AppConfig.apiBaseUrl).trim();
    final apiUri = Uri.tryParse(effectiveApiBase);
    if (apiUri != null && apiUri.host.isNotEmpty) {
      formattedDomainUrl = Uri(
        scheme: apiUri.scheme.isNotEmpty ? apiUri.scheme : 'https',
        host: apiUri.host,
        port: apiUri.hasPort ? apiUri.port : null,
      ).toString();
    } else {
      formattedDomainUrl = effectiveApiBase;
    }
  }

  if (formattedDomainUrl.endsWith('/')) {
    formattedDomainUrl = formattedDomainUrl.substring(
      0,
      formattedDomainUrl.length - 1,
    );
  }

  final normalizedSsoPath = ssoPath.startsWith('/') ? ssoPath : '/$ssoPath';
  final separator = normalizedSsoPath.contains('?') ? '&' : '?';

  return '$formattedDomainUrl$normalizedSsoPath${separator}next=$encodedNextPath';
}
