import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_dto.dart';
import '../sources/mock_data.dart';

part 'auth_provider.g.dart';

/// Provider for the currently authenticated user.
/// In a real app, this would be managed by an AuthService/SessionManager.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  UserDto build() {
    return mockCurrentUser;
  }

  void logout() {
    // Placeholder for logout logic
    state = const UserDto(id: 'guest', name: 'Guest');
  }

  void updateProfile(UserDto newUser) {
    state = newUser;
  }
}
