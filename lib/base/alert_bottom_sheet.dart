import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:traveler_app/base/app_bottom_sheet.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

enum AlertType { error, warning, success, failure }

class AlertBottomSheet extends StatelessWidget {
  final AlertType alertType;
  final String title;
  final String? message;
  final VoidCallback? onDone;
  final String doneButtonText;

  final VoidCallback? onSecondaryAction;
  final String? secondaryButtonText;
  final String? customAsset;
  final bool? repeat;
  final ButtonType? primaryButtonType;

  const AlertBottomSheet({
    super.key,
    required this.alertType,
    required this.title,
    this.message,
    this.onDone,
    this.doneButtonText = 'Done',
    this.onSecondaryAction,
    this.secondaryButtonText,
    this.customAsset,
    this.repeat,
    this.primaryButtonType,
  });

  @override
  Widget build(BuildContext context) {
    final animationPath = customAsset ?? _getAnimationPath(alertType);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing24,
        AppTheme.spacing12,
        AppTheme.spacing24,
        AppTheme.spacing20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              addRepaintBoundary: true,
              animationPath,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              repeat: repeat ?? (alertType == AlertType.warning),
              decoder: animationPath.endsWith('.lottie')
                  ? LottieComposition.decodeZip
                  : null,
            ),
          ),
          const Gap(AppTheme.spacing16),
          Text(
            title.tr,
            style: AppTypography.h4.copyWith(
              fontWeight: AppTypography.semiBold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const Gap(AppTheme.spacing8),
            Text(
              message!.tr,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const Gap(AppTheme.spacing24),
          if (onSecondaryAction != null && secondaryButtonText != null)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: doneButtonText.tr,
                    onPressed: () {
                      Get.back();
                      onDone?.call();
                    },
                    type: _getButtonType(alertType),
                    size: ButtonSize.medium,
                    width: double.infinity,
                    borderRadius: AppTheme.radius12,
                  ),
                ),
                const Gap(AppTheme.spacing12),
                Expanded(
                  child: AppButton(
                    text: secondaryButtonText!.tr,
                    onPressed: () {
                      Get.back();
                      onSecondaryAction?.call();
                    },
                    type: ButtonType.ghost,
                    size: ButtonSize.medium,
                    width: double.infinity,
                    borderRadius: AppTheme.radius12,
                  ),
                ),
              ],
            )
          else
            AppButton(
              text: doneButtonText.tr,
              onPressed: () {
                Get.back();
                onDone?.call();
              },
              type: _getButtonType(alertType),
              size: ButtonSize.medium,
              width: double.infinity,
              borderRadius: AppTheme.radius12,
            ),
        ],
      ),
    );
  }

  ButtonType _getButtonType(AlertType type) {
    if (primaryButtonType != null) return primaryButtonType!;
    switch (type) {
      case AlertType.success:
        return ButtonType.success;
      case AlertType.error:
      case AlertType.failure:
        return ButtonType.danger;
      case AlertType.warning:
        return ButtonType.ghost;
    }
  }

  // Maps each alert state to a Lottie that actually exists under
  // assets/json/. Error and failure share the failed-payment animation
  // since the project doesn't ship a generic error.json.
  String _getAnimationPath(AlertType type) {
    switch (type) {
      case AlertType.success:
        return 'assets/json/success.json';
      case AlertType.error:
        return 'assets/json/error.json';
      case AlertType.warning:
        return 'assets/json/Question.json';
      case AlertType.error:
      case AlertType.failure:
        return 'assets/json/error.json';
    }
  }
}

/// ==== Helper class to easily show alert bottom sheets ====

class AlertBottomSheets {
  static Future<void> _show(AlertBottomSheet sheet) {
    return AppBottomSheet.show(showCloseButton: false, child: sheet);
  }

  static Future<void> showSuccess(
    BuildContext buildContext, {
    required String title,
    String? message,
    VoidCallback? onDone,
    String doneButtonText = 'done',
    VoidCallback? onSecondaryAction,
    String? secondaryButtonText,
    String? customAsset,
  }) {
    return _show(
      AlertBottomSheet(
        alertType: AlertType.success,
        title: title,
        message: message,
        onDone: onDone,
        doneButtonText: doneButtonText,
        onSecondaryAction: onSecondaryAction,
        secondaryButtonText: secondaryButtonText,
        customAsset: customAsset,
      ),
    );
  }

  static Future<void> showError({
    required String title,
    String? message,
    VoidCallback? onDone,
    String doneButtonText = 'try_again',
    VoidCallback? onSecondaryAction,
    String? secondaryButtonText,
    String? customAsset,
  }) {
    return _show(
      AlertBottomSheet(
        alertType: AlertType.error,
        title: title,
        message: message,
        onDone: onDone,
        doneButtonText: doneButtonText,
        onSecondaryAction: onSecondaryAction,
        secondaryButtonText: secondaryButtonText,
        customAsset: customAsset,
      ),
    );
  }

  static Future<void> showWarning({
    required String title,
    String? message,
    VoidCallback? onDone,
    String doneButtonText = 'understood',
    VoidCallback? onSecondaryAction,
    String? secondaryButtonText,
    String? customAsset,
    bool? repeat,
    ButtonType? primaryButtonType,
  }) {
    return _show(
      AlertBottomSheet(
        alertType: AlertType.warning,
        title: title,
        message: message,
        onDone: onDone,
        doneButtonText: doneButtonText,
        onSecondaryAction: onSecondaryAction,
        secondaryButtonText: secondaryButtonText,
        customAsset: customAsset,
        repeat: repeat,
        primaryButtonType: primaryButtonType,
      ),
    );
  }

  static Future<void> showFailure({
    required String title,
    String? message,
    VoidCallback? onDone,
    String doneButtonText = 'Close',
    VoidCallback? onSecondaryAction,
    String? secondaryButtonText,
    String? customAsset,
  }) {
    return _show(
      AlertBottomSheet(
        alertType: AlertType.failure,
        title: title,
        message: message,
        onDone: onDone,
        doneButtonText: doneButtonText,
        onSecondaryAction: onSecondaryAction,
        secondaryButtonText: secondaryButtonText,
        customAsset: customAsset,
      ),
    );
  }
}
