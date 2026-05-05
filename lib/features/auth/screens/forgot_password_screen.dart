import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/app_text_field.dart';
import 'package:traveler_app/features/auth/controller/auth_forgot_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthForgotController>();
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
                  'forgot_password'.tr,
                  style: AppTypography.h2.copyWith(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'forgot_password_subtitle'.tr,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 32),
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
                const SizedBox(height: 32),
                Obx(
                  () => AppButton(
                    text: 'send_otp'.tr,
                    onPressed: c.isLoading.value ? null : c.submit,
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
