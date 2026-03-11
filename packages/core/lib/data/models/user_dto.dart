import 'package:flutter/foundation.dart';

@immutable
class UserDto {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final bool isPro;
  final DateTime? joinedDate;

  const UserDto({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.isPro = false,
    this.joinedDate,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';

    final displayName = json['display_name']?.toString();
    final firstName = json['first_name']?.toString();
    final lastName = json['last_name']?.toString();
    final username = json['username']?.toString();
    final explicitName = json['name']?.toString();

    final fallbackName = [firstName, lastName]
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(' ')
        .trim();

    final name = [
      explicitName,
      displayName,
      fallbackName.isEmpty ? null : fallbackName,
      username,
    ].firstWhere(
      (value) => value != null && value.trim().isNotEmpty,
      orElse: () => '',
    )!;

    final avatar = (json['avatar'] ??
            json['photo'] ??
            json['large_image'] ??
            json['medium_image'] ??
            json['small_image'])
        ?.toString();

    DateTime? joinedDate;
    final joinedDateRaw = json['joined_date'] ?? json['joinedDate'];
    if (joinedDateRaw is String && joinedDateRaw.isNotEmpty) {
      joinedDate = DateTime.tryParse(joinedDateRaw);
    }

    return UserDto(
      id: id,
      name: name,
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      avatar: avatar,
      isPro: json['is_pro'] == true || json['isPro'] == true,
      joinedDate: joinedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_pro': isPro,
      'joined_date': joinedDate?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDto &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.isPro == isPro &&
        other.joinedDate == joinedDate;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        phone,
        avatar,
        isPro,
        joinedDate,
      );
}
