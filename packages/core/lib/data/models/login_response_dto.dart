import 'package:flutter/foundation.dart';

@immutable
class LoginResponseDto {
  const LoginResponseDto({
    required this.token,
    required this.isNewUser,
  });

  final String token;
  final bool isNewUser;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final token = json['token']?.toString() ?? '';
    if (token.isEmpty) {
      throw const FormatException(
        'Authentication succeeded but no token was returned.',
      );
    }

    return LoginResponseDto(
      token: token,
      isNewUser: json['is_new_user'] == true,
    );
  }
}
