import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/app_text_field.dart';
import 'package:traveler_app/features/auth/controller/auth_register_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthRegisterController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'create_account'.tr,
                  style: AppTypography.h2.copyWith(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'register_subtitle'.tr,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: c.nameController,
                  labelText: 'name_label'.tr,
                  hintText: 'name_hint'.tr,
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'name_required'.tr : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: c.emailController,
                  labelText: 'email_label'.tr,
                  hintText: 'email_hint'.tr,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'email_required'.tr;
                    if (!GetUtils.isEmail(v)) return 'email_invalid'.tr;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: c.phoneController,
                  labelText: 'phone_label'.tr,
                  hintText: 'phone_hint'.tr,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'phone_required'.tr : null,
                ),
                const SizedBox(height: 16),
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
                    text: 'register'.tr,
                    onPressed: c.isLoading.value ? null : c.register,
                    isLoading: c.isLoading.value,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppTheme.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('login'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
