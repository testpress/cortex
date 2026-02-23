class UserDto {
  final String id;
  final String name;
  final String? email;
  final String? avatar;
  final bool isPro;

  const UserDto({
    required this.id,
    required this.name,
    this.email,
    this.avatar,
    this.isPro = false,
  });
}
