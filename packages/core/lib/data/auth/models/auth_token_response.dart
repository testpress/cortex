class AuthTokenResponse {
  const AuthTokenResponse({
    required this.token,
  });

  final String token;

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString().trim();

    if (token == null || token.isEmpty) {
      throw const FormatException('Missing token in auth response.');
    }

    return AuthTokenResponse(token: token);
  }
}
