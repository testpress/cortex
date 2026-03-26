import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import '../db/app_database.dart';

@immutable
class UserDto {
  final String id;
  final String name;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? avatar;
  final bool isPro;
  final DateTime? joinedDate;

  const UserDto({
    required this.id,
    required this.name,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.avatar,
    this.isPro = false,
    this.joinedDate,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'].toString(),
      name: (json['display_name'] as String?) ?? '',
      username: json['username'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['medium_image'] as String?,
      joinedDate: json['joined_date'] != null 
          ? DateTime.tryParse(json['joined_date'].toString()) 
          : null,
    );
  }

  factory UserDto.fromTableData(UsersTableData data) {
    return UserDto(
      id: data.id,
      name: data.name ?? '',
      username: data.username,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      phone: data.phone,
      avatar: data.avatar,
      joinedDate: data.joinedDate,
    );
  }

  UserDto copyWith({
    String? id,
    String? name,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatar,
    bool? isPro,
    DateTime? joinedDate,
  }) {
    return UserDto(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isPro: isPro ?? this.isPro,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDto &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.firstName == firstName &&
        other.lastName == lastName &&
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
        username,
        firstName,
        lastName,
        email,
        phone,
        avatar,
        isPro,
        joinedDate,
      );
}

/// Extension to bridge [UserDto] metadata into individual database rows.
/// This allows for easy persistence into [UsersTable].
extension UserDtoPersistence on UserDto {
  UsersTableCompanion toCompanion() {
    return UsersTableCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      username: drift.Value(username),
      firstName: drift.Value(firstName),
      lastName: drift.Value(lastName),
      email: drift.Value(email),
      phone: drift.Value(phone),
      avatar: drift.Value(avatar),
      joinedDate: drift.Value(joinedDate),
    );
  }
}

