import 'package:get/get.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/auth/model/auth_model.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthOtpController extends GetxController {
  final AuthService _authService;

  AuthOtpController({required AuthService authService})
      : _authService = authService;

  final isLoading = false.obs;
  final isResending = false.obs;

  String get email => (Get.arguments as Map?)?['email'] ?? '';
  String get mode => (Get.arguments as Map?)?['mode'] ?? 'verify';

  Future<void> verify(String otp) async {
    if (otp.length < 4) return;
    isLoading.value = true;
    try {
      final result = await _authService.verifyOtp(email, otp);
      if (result != null && result['success'] == true) {
        if (mode == 'reset') {
          Get.toNamed(
            resetPasswordRoute,
            arguments: {'email': email, 'otp': otp},
          );
        } else {
          final data = result['data'];
          if (data != null && data['token'] != null) {
            final authResponse = AuthResponse.fromJson(data);
            await Get.find<AuthController>().saveToken(authResponse.token);
          }
          Get.offAllNamed(navRoute);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resend() async {
    isResending.value = true;
    try {
      await _authService.resendOtp(email);
    } finally {
      isResending.value = false;
    }
  }
}
