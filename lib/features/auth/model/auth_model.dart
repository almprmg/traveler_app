class AuthUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final bool isVerified;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.isVerified,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
    );
  }
}

class AuthResponse {
  final String token;
  final AuthUser user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: AuthUser.fromJson(json['user'] ?? {}),
    );
  }
}
