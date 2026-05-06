class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ProfileModel(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar_url'] ?? data['avatar'],
    );
  }
}
