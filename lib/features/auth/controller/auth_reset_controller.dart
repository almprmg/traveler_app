import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthResetController extends GetxController {
  final AuthService _authService;

  AuthResetController({required AuthService authService})
      : _authService = authService;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  String get email => (Get.arguments as Map?)?['email'] ?? '';
  String get otp => (Get.arguments as Map?)?['otp'] ?? '';

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> reset() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final success = await _authService.resetPassword(
        email: email,
        otp: otp,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      if (success) {
        Get.offAllNamed(loginRoute);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
