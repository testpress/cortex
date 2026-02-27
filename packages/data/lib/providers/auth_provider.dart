import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_dto.dart';

part 'auth_provider.g.dart';

/// Provider for the currently authenticated user.
/// In a real app, this would be managed by an AuthService/SessionManager.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  UserDto build() {
    // Current mock user matching the 'current_user' ID used in repositories.
    return const UserDto(
      id: 'current_user',
      name: 'Aditya Vardhan',
      email: 'aditya.v@example.com',
      isPro: true,
    );
  }

  void logout() {
    // Placeholder for logout logic
    state = const UserDto(id: 'guest', name: 'Guest');
  }
}
