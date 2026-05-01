import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthRegisterController extends GetxController {
  final AuthService _authService;

  AuthRegisterController({required AuthService authService})
      : _authService = authService;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final result = await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      if (result != null && result['success'] == true) {
        Get.toNamed(
          otpRoute,
          arguments: {'email': emailController.text.trim(), 'mode': 'verify'},
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
