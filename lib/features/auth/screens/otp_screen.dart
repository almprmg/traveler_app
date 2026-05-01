import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/custom_otp_input.dart';
import 'package:traveler_app/features/auth/controller/auth_otp_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthOtpController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'verify_otp'.tr,
                style: AppTypography.h2.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                '${'otp_sent_to'.tr} ${c.email}',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 40),
              Obx(
                () => CustomOtpInput(
                  length: 6,
                  autofocus: true,
                  hasError: false,
                  onCompleted: c.isLoading.value ? null : c.verify,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => AppButton(
                  text: 'verify'.tr,
                  isLoading: c.isLoading.value,
                  onPressed: c.isLoading.value ? null : () {},
                  width: double.infinity,
                  size: ButtonSize.large,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppButton(
                  text: c.isResending.value ? 'resending'.tr : 'resend_otp'.tr,
                  isLoading: c.isResending.value,
                  onPressed: c.isResending.value ? null : c.resend,
                  type: ButtonType.ghost,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
