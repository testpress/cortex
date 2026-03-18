class AuthTokenResponse {
  const AuthTokenResponse({
    required this.token,
    this.refreshToken,
  });

  final String token;
  final String? refreshToken;

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString().trim();
    final refresh = json['refresh']?.toString().trim();

    if (token == null || token.isEmpty) {
      throw const FormatException('Missing token in auth response.');
    }

    return AuthTokenResponse(
      token: token,
      refreshToken: (refresh == null || refresh.isEmpty) ? null : refresh,
    );
  }
}
