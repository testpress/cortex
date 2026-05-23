import 'package:flutter/foundation.dart';

@immutable
class LoginActivityDto {
  final int id;
  final String userAgent;
  final String ipAddress;
  final String device;
  final String deviceName;
  final String browser;
  final String os;
  final DateTime lastUsed;
  final String location;
  final bool currentDevice;

  const LoginActivityDto({
    required this.id,
    required this.userAgent,
    required this.ipAddress,
    required this.device,
    required this.deviceName,
    required this.browser,
    required this.os,
    required this.lastUsed,
    required this.location,
    required this.currentDevice,
  });

  factory LoginActivityDto.fromJson(Map<String, dynamic> json) {
    return LoginActivityDto(
      id: json['id'] as int,
      userAgent: json['user_agent'] as String? ?? '',
      ipAddress: json['ip_address'] as String? ?? '',
      device: json['device'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? '',
      browser: json['browser'] as String? ?? '',
      os: json['os'] as String? ?? '',
      lastUsed: DateTime.tryParse(json['last_used'] as String? ?? '') ?? DateTime.now(),
      location: json['location'] as String? ?? '',
      currentDevice: json['current_device'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginActivityDto &&
        other.id == id &&
        other.userAgent == userAgent &&
        other.ipAddress == ipAddress &&
        other.device == device &&
        other.deviceName == deviceName &&
        other.browser == browser &&
        other.os == os &&
        other.lastUsed == lastUsed &&
        other.location == location &&
        other.currentDevice == currentDevice;
  }

  @override
  int get hashCode => Object.hash(
        id,
        userAgent,
        ipAddress,
        device,
        deviceName,
        browser,
        os,
        lastUsed,
        location,
        currentDevice,
      );
}

class PaginatedLoginActivityDto {
  final int count;
  final String? next;
  final String? previous;
  final int perPage;
  final List<LoginActivityDto> results;

  PaginatedLoginActivityDto({
    required this.count,
    this.next,
    this.previous,
    required this.perPage,
    required this.results,
  });

  factory PaginatedLoginActivityDto.fromJson(Map<String, dynamic> json) {
    return PaginatedLoginActivityDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      perPage: json['per_page'] as int? ?? 20,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => LoginActivityDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
