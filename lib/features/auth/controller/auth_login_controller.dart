import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthLoginController extends GetxController {
  final AuthService _authService;

  AuthLoginController({required AuthService authService})
    : _authService = authService;

  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final phone = phoneController.text.trim();
      final result = await _authService.sendOtp('+966$phone');
      if (result != null && result['success'] == true) {
        Get.toNamed(otpRoute, arguments: {'phone': phone, 'mode': 'login'});
      } else {
        errorMessage.value =
            result?['message']?.toString() ?? 'error_try_again'.tr;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
