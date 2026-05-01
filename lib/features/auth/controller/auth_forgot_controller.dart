import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthForgotController extends GetxController {
  final AuthService _authService;

  AuthForgotController({required AuthService authService})
      : _authService = authService;

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final result =
          await _authService.forgotPassword(emailController.text.trim());
      if (result != null && result['success'] == true) {
        Get.toNamed(
          otpRoute,
          arguments: {
            'email': emailController.text.trim(),
            'mode': 'reset',
          },
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
