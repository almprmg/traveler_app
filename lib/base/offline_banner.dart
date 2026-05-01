import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/controllers/internet_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Project-wide offline banner. Wraps the active route and floats a frosted
/// glass strip at the top of the screen whenever connectivity drops, with a
/// one-tap shortcut to the device's wireless settings. Visible across every
/// route because it lives in `GetMaterialApp.builder`.
class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          final connected = Get.isRegistered<InternetController>()
              ? Get.find<InternetController>().isConnected.value
              : true;
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: connected,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                offset: connected ? const Offset(0, -1.5) : Offset.zero,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: connected ? 0 : 1,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.spacing12,
                        AppTheme.spacing20,
                        AppTheme.spacing12,
                        0,
                      ),
                      child: const _OfflineCard(),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _OfflineCard extends StatelessWidget {
  const _OfflineCard();

  Future<void> _openSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radius16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing12),
          decoration: BoxDecoration(
            color: AppTheme.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppTheme.radius16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/no_internet.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const Gap(AppTheme.spacing12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'no_internet_connection'.tr,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: AppTypography.bold,
                        height: 1.3,
                      ),
                    ),
                    const Gap(AppTheme.spacing2),
                    Text(
                      'no_internet_subtitle'.tr,
                      style: AppTypography.caption.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(AppTheme.spacing8),
              AppButton(
                text: 'open_settings'.tr,
                type: ButtonType.ghost,
                size: ButtonSize.small,
                borderRadius: 999,
                widgetIcon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSettings01,
                  size: 14,
                  color: AppTheme.textPrimary,
                ),
                onPressed: _openSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
