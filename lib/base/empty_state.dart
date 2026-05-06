import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_button.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:gap/gap.dart';

class EmptyState extends StatelessWidget {
  final String? title;
  final String? description;
  final String? svgAsset;
  final String? lottieAsset;
  final double? imageWidth;
  final double? imageHeight;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final ButtonType buttonType;
  final ButtonSize buttonSize;
  final IconData? buttonIcon;
  final Widget? buttonWidgetIcon;

  // Keep onRefresh for backward compatibility or simple refresh actions
  final VoidCallback? onRefresh;

  const EmptyState({
    super.key,
    this.title,
    this.description,
    this.svgAsset,
    this.lottieAsset,
    this.imageWidth,
    this.imageHeight,
    this.buttonLabel,
    this.onButtonPressed,
    this.buttonType = ButtonType.ghost,
    this.buttonSize = ButtonSize.medium,
    this.buttonIcon,
    this.buttonWidgetIcon,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.25, 0.65, 1.0],
          colors: [
            AppTheme.background,
            AppTheme.white,
            AppTheme.white,
            AppTheme.background,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing20,
          vertical: AppTheme.spacing24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAsset ?? 'assets/json/no_flights.json',
              width: imageWidth ?? 210,
              height: imageHeight ?? 210,
            ),
            Text(
              title ?? 'no_data'.tr,
              style: AppTypography.h4.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(AppTheme.spacing2),
            Text(
              description ?? 'no_data_desc'.tr,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTypography.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            // Render specific button if provided
            if (buttonLabel != null && onButtonPressed != null) ...[
              const Gap(AppTheme.spacing24),
              AppButton(
                text: buttonLabel!,
                onPressed: onButtonPressed!,
                type: buttonType,
                size: ButtonSize.small,
                icon: buttonIcon,
                widgetIcon: buttonWidgetIcon,
                iconPosition: IconPosition.start,
              ),
            ]
            // Fallback to refresh button if only onRefresh is provided
            else if (onRefresh != null) ...[
              const Gap(AppTheme.spacing24),
              AppButton(
                text: 'refresh'.tr,
                onPressed: onRefresh,
                widgetIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedRefresh,
                  size: 18,
                  color: AppTheme.textPrimary,
                ),
                type: ButtonType.ghost,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
