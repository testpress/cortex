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
