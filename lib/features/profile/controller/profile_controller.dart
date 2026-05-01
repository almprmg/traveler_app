import 'package:get/get.dart';
import 'package:traveler_app/features/profile/model/profile_model.dart';
import 'package:traveler_app/features/profile/service/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService;

  ProfileController({required this.profileService});

  final profile = Rxn<ProfileModel>();
  final isLoading = false.obs;

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
  }) async {
    isLoading.value = true;
    try {
      final updated = await profileService.updateProfile(
        name: name,
        phone: phone,
      );
      if (updated != null) profile.value = updated;
    } finally {
      isLoading.value = false;
    }
  }
}
