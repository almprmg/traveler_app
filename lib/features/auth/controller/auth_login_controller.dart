import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/auth/model/auth_model.dart';
import 'package:traveler_app/features/auth/service/auth_service.dart';
import 'package:traveler_app/routes.dart';

class AuthLoginController extends GetxController {
  final AuthService _authService;

  AuthLoginController({required AuthService authService})
      : _authService = authService;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  // Stored email for OTP / forgot-password flow
  String pendingEmail = '';

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      if (result != null && result['success'] == true) {
        final data = result['data'];
        final authResponse = AuthResponse.fromJson(data);
        await Get.find<AuthController>().saveToken(authResponse.token);
        Get.offAllNamed(navRoute);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() => Get.toNamed(registerRoute);
  void goToForgotPassword() => Get.toNamed(forgotPasswordRoute);
}
