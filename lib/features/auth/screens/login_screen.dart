import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/app_text_field.dart';
import 'package:traveler_app/features/auth/controller/auth_login_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:hugeicons/hugeicons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthLoginController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'welcome_back'.tr,
                  style: AppTypography.h2.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'explore_the_world'.tr,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                AppTextField(
                  controller: c.emailController,
                  labelText: 'email_label'.tr,
                  hintText: 'email_hint'.tr,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedMail01, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'email_required'.tr;
                    if (!GetUtils.isEmail(v)) return 'email_invalid'.tr;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => AppTextField(
                    controller: c.passwordController,
                    labelText: 'password_label'.tr,
                    hintText: 'password_hint'.tr,
                    obscureText: c.obscurePassword.value,
                    prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedLockKey, size: 20),
                    suffixIcon: IconButton(icon: HugeIcon(icon: c.obscurePassword.value
                             ? HugeIcons.strokeRoundedView : HugeIcons.strokeRoundedViewOff, size: 20),
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
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: c.goToForgotPassword,
                    child: Text('forgot_password'.tr),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => AppButton(
                    text: 'login'.tr,
                    onPressed: c.isLoading.value ? null : c.login,
                    isLoading: c.isLoading.value,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont_have_account'.tr,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: c.goToRegister,
                      child: Text('register'.tr),
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
