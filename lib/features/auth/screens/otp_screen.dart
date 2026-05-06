import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/base/custom_otp_input.dart';
import 'package:traveler_app/features/auth/controller/auth_otp_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  int _seconds = 300;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthOtpController>();
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Lottie.asset(
                                'assets/json/motion_phone.json',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Gap(AppTheme.spacing32),
                            Text(
                              'verify_otp'.tr,
                              style: AppTypography.h2,
                              textAlign: TextAlign.center,
                            ),
                            const Gap(AppTheme.spacing8),
                            Text(
                              '${'otp_sent_to'.tr} +966${c.phone}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Gap(AppTheme.spacing32),
                            Obx(
                              () => CustomOtpInput(
                                length: 4,
                                autofocus: true,
                                hasError: c.errorMessage.value != null,
                                onChanged: (value) {
                                  _otp = value;
                                  if (c.errorMessage.value != null &&
                                      value.length < 4) {
                                    c.errorMessage.value = null;
                                  }
                                },
                                onCompleted: c.isLoading.value
                                    ? null
                                    : (value) {
                                        _otp = value;
                                        c.verify(value);
                                      },
                              ),
                            ),
                            const Gap(AppTheme.spacing8),
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
                            Center(
                              child: TextButton(
                                onPressed: _seconds == 0
                                    ? () {
                                        setState(() {
                                          _seconds = 300;
                                          _timer?.cancel();
                                          _startTimer();
                                        });
                                        c.resend();
                                      }
                                    : null,
                                child: Text(
                                  _seconds == 0
                                      ? 'resend_otp'.tr
                                      : '${'resend_otp'.tr} ($_formattedTime)',
                                  style: TextStyle(
                                    color: _seconds == 0
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(AppTheme.spacing16),
                            Obx(
                              () => AppButton(
                                text: 'verify'.tr,
                                type: ButtonType.gradient,
                                size: ButtonSize.medium,
                                width: double.infinity,
                                borderRadius: AppTheme.radiusPill,
                                isLoading: c.isLoading.value ||
                                    (_otp.length == 4 &&
                                        c.errorMessage.value == null),
                                onPressed: _seconds > 0
                                    ? () {
                                        if (_otp.length == 4) {
                                          c.errorMessage.value = null;
                                          c.verify(_otp);
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            const Gap(AppTheme.spacing16),
                            AppButton(
                              text: 'change_phone_number'.tr,
                              type: ButtonType.ghost,
                              size: ButtonSize.medium,
                              width: double.infinity,
                              borderRadius: AppTheme.radiusPill,
                              onPressed: () => Get.back(),
                            ),
                          ],
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
