import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/app_text_field.dart';
import 'package:traveler_app/features/auth/controller/auth_reset_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthResetController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'reset_password'.tr,
                  style: AppTypography.h2.copyWith(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'reset_password_subtitle'.tr,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => AppTextField(
                    controller: c.passwordController,
                    labelText: 'password_label'.tr,
                    hintText: 'password_hint'.tr,
                    obscureText: c.obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        c.obscurePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () =>
                          c.obscurePassword.value = !c.obscurePassword.value,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'password_required'.tr;
                      if (v.length < 8) return 'password_min_length'.tr;
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => AppTextField(
                    controller: c.confirmPasswordController,
                    labelText: 'confirm_password_label'.tr,
                    hintText: 'confirm_password_hint'.tr,
                    obscureText: c.obscureConfirm.value,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        c.obscureConfirm.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () =>
                          c.obscureConfirm.value = !c.obscureConfirm.value,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'password_required'.tr;
                      if (v != c.passwordController.text) {
                        return 'passwords_dont_match'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => AppButton(
                    text: 'reset_password'.tr,
                    onPressed: c.isLoading.value ? null : c.reset,
                    isLoading: c.isLoading.value,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
