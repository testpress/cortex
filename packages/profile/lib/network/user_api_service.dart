import 'package:core/data/data.dart';
import 'package:dio/dio.dart';

class UserApiService {
  UserApiService(this._dio);

  final Dio _dio;

  Future<UserDto> fetchCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.userProfile);
    final data = _asJsonMap(response.data);

    final firstName = (data['first_name'] as String?)?.trim() ?? '';
    final lastName = (data['last_name'] as String?)?.trim() ?? '';
    final fallbackName = '$firstName $lastName'.trim();
    final displayName = (data['display_name'] as String?)?.trim();
    final backendName = (data['name'] as String?)?.trim();
    final resolvedName = (displayName?.isNotEmpty ?? false)
        ? displayName!
        : (backendName?.isNotEmpty ?? false)
        ? backendName!
        : fallbackName;

    return UserDto(
      id: data['id']?.toString() ?? '',
      name: resolvedName,
      email: data['email']?.toString(),
      phone: data['phone']?.toString(),
      avatar:
          data['photo']?.toString() ??
          data['large_image']?.toString() ??
          data['avatar']?.toString(),
      isPro: data['is_pro'] ?? false,
      joinedDate: data['joined_date'] != null
          ? DateTime.tryParse(data['joined_date'].toString())
          : null,
    );
  }

  Map<String, dynamic> _asJsonMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.cast<String, dynamic>();
    throw const AuthException('Malformed response from server.');
  }
}
