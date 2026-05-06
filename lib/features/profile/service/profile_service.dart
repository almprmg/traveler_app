import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/profile/model/profile_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class ProfileService extends GetxService {
  final ApiClient apiClient;

  ProfileService({required this.apiClient});

  Future<ProfileModel?> getProfile() async {
    final response = await apiClient.getData(AppConstants.profileUrl);
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<ProfileModel?> updateProfile({
    required String name,
    required String phone,
    String? email,
  }) async {
    final response = await apiClient.putData(AppConstants.profileUrl, {
      'name': name,
      'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
    });
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  /// Uploads avatar; returns the new avatar URL on success.
  Future<String?> uploadAvatar(XFile file) async {
    final bytes = await file.readAsBytes();
    final fileName = file.name.isNotEmpty ? file.name : 'avatar.jpg';
    final response = await apiClient.uploadBytes(
      '${AppConstants.profileUrl}/avatar',
      bytes,
      fileName,
      fieldName: 'file',
      isImage: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      if (data is Map) {
        return data['avatar_url']?.toString() ?? data['avatar']?.toString();
      }
    }
    return null;
  }
}
