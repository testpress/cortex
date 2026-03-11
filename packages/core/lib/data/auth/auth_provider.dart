import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'auth_provider.g.dart';

/// Provider for the currently authenticated user.
/// In a real app, this would be managed by an AuthService/SessionManager.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  UserDto build() {
    return const UserDto(id: '', name: '');
  }

  void logout() {
    state = const UserDto(id: '', name: '');
  }

  void updateProfile(UserDto newUser) {
    state = newUser;
  }
}
