import 'dart:io';
import 'package:get/get.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/features/profile/model/profile_model.dart';
import 'package:traveler_app/features/profile/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService;

  ProfileController({required this.profileService});

  final profile = Rxn<ProfileModel>();
  final isLoading = false.obs;
  final isUploadingAvatar = false.obs;
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      profile.value = await profileService.getProfile();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? email,
  }) async {
    isLoading.value = true;
    try {
      final updated = await profileService.updateProfile(
        name: name,
        phone: phone,
        email: email,
      );
      if (updated != null) profile.value = updated;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> uploadAvatar(File file) async {
    isUploadingAvatar.value = true;
    try {
      final url = await profileService.uploadAvatar(file);
      if (url != null) {
        // Refetch profile to get updated avatar
        await fetchProfile();
        return true;
      }
      return false;
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  Future<bool> deleteAccount() async {
    isDeleting.value = true;
    try {
      return await Get.find<AuthService>().deleteAccount();
    } finally {
      isDeleting.value = false;
    }
  }
}
