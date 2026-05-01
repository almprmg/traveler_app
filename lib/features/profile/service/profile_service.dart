import 'dart:convert';
import 'package:get/get.dart';
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
  }) async {
    final response = await apiClient.putData(AppConstants.profileUrl, {
      'name': name,
      'phone': phone,
    });
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    }
    return null;
  }
}
