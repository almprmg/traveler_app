import 'package:get/get.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/auth/model/auth_model.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/features/profile/controller/profile_controller.dart';
import 'package:traveler_app/features/profile/model/profile_model.dart';
import 'package:traveler_app/routes.dart';

class AuthOtpController extends GetxController {
  final AuthService _authService;

  AuthOtpController({required AuthService authService})
      : _authService = authService;

  final isLoading = false.obs;
  final isResending = false.obs;
  final errorMessage = Rxn<String>();

  String get phone => (Get.arguments as Map?)?['phone'] ?? '';
  String get mode => (Get.arguments as Map?)?['mode'] ?? 'login';

  Future<void> verify(String otp) async {
    if (otp.length < 4 || otp.length != 4) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      if (mode == 'reset') {
        // Forgot password OTP — keep existing email-based reset flow
        final email = (Get.arguments as Map?)?['email'] ?? '';
        final result = await _authService.verifyOtp(email, otp);
        if (result != null && result['success'] == true) {
          Get.toNamed(
            resetPasswordRoute,
            arguments: {'email': email, 'otp': otp},
          );
        } else {
          errorMessage.value =
              result?['message']?.toString() ?? 'otp_invalid'.tr;
        }
      } else {
        // Phone login flow
        final result = await _authService.loginWithOtp('+966$phone', otp);
        if (result != null && result['success'] == true) {
          final authResponse = AuthResponse.fromJson(
            (result['data'] as Map<String, dynamic>?) ?? result,
          );
          await Get.find<AuthController>().saveToken(authResponse.token);
          final user = authResponse.user;
          Get.find<ProfileController>().profile.value = ProfileModel(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            avatar: user.avatar,
          );
          if (user.name.isEmpty || user.email.isEmpty) {
            Get.offAllNamed(editProfileRoute, arguments: {'setup': true});
          } else {
            Get.offAllNamed(navRoute);
          }
        } else {
          errorMessage.value =
              result?['message']?.toString() ?? 'otp_invalid'.tr;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resend() async {
    isResending.value = true;
    errorMessage.value = null;
    try {
      if (mode == 'reset') {
        final email = (Get.arguments as Map?)?['email'] ?? '';
        await _authService.resendOtp(email);
      } else {
        await _authService.sendOtp('+966$phone');
      }
    } finally {
      isResending.value = false;
    }
  }
}
