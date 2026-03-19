import 'package:core/data/data.dart';
import 'package:dio/dio.dart';

class UserApiService {
  UserApiService(this._dio);

  final Dio _dio;

  Future<UserDto> fetchCurrentUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.userProfile);
      return _mapUserDto(response.data);
    } on DioException catch (error) {
      throw AuthException.fromDio(error);
    }
  }

  Future<UserDto> updateCurrentUser({
    required String name,
    String? phone,
  }) async {
    try {
      final (firstName, lastName) = _splitName(name);
      final payload = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
      };
      if (phone != null && phone.trim().isNotEmpty) {
        payload['phone'] = phone.trim();
      }

      final response = await _dio.patch(ApiEndpoints.userProfile, data: payload);
      return _mapUserDto(response.data);
    } on DioException catch (error) {
      throw AuthException.fromDio(error);
    }
  }

  UserDto _mapUserDto(dynamic raw) {
    final data = _asJsonMap(raw);

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

  (String, String) _splitName(String fullName) {
    final normalized = fullName
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .join(' ');
    if (normalized.isEmpty) return ('', '');
    final parts = normalized.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return (firstName, lastName);
  }

  Map<String, dynamic> _asJsonMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.cast<String, dynamic>();
    throw AuthException.malformedResponse();
  }
}
