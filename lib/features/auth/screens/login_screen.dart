import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/features/auth/controller/auth_login_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthLoginController>();
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/sky_background.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: 80,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.white,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(AppTheme.spacing24),
                        child: Form(
                          key: c.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'welcome_back'.tr,
                                style: AppTypography.h2,
                                textAlign: TextAlign.center,
                              ),
                              const Gap(AppTheme.spacing8),
                              Text(
                                'explore_the_world'.tr,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(AppTheme.spacing32),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppTheme.spacing12,
                                          vertical: AppTheme.spacing12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          border: Border.all(
                                            color: AppTheme.border,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '+966',
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                color: AppTheme.textPrimary,
                                              ),
                                        ),
                                      ),
                                      const Gap(AppTheme.spacing4),
                                      Expanded(
                                        child: TextFormField(
                                          controller: c.phoneController,
                                          keyboardType: TextInputType.phone,
                                          textDirection: TextDirection.ltr,
                                          maxLength: 9,
                                          decoration: InputDecoration(
                                            hintText: '5XXXXXXXX',
                                            counterText: '',
                                            filled: true,
                                            fillColor: AppTheme.white,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal:
                                                      AppTheme.spacing16,
                                                  vertical: AppTheme.spacing12,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: AppTheme.border,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: AppTheme.border,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: AppTheme.primary,
                                                width: 1.5,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: AppTheme.error,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: AppTheme.error,
                                                    width: 1.5,
                                                  ),
                                                ),
                                          ),
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'phone_required'.tr;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(AppTheme.spacing16),
                              Obx(() {
                                if (c.errorMessage.value == null) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    c.errorMessage.value!,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppTheme.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }),
                              const Gap(AppTheme.spacing8),
                              Obx(
                                () => AppButton(
                                  text: 'send_otp'.tr,
                                  type: ButtonType.gradient,
                                  size: ButtonSize.medium,
                                  width: double.infinity,
                                  borderRadius: AppTheme.radiusPill,
                                  onPressed:
                                      c.isLoading.value ? null : c.sendOtp,
                                  isLoading: c.isLoading.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
