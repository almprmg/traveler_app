import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class InstallmentCard extends StatelessWidget {
  final Widget logo;
  final Color? logoTint;
  final Widget description;

  final VoidCallback? onTap;

  final bool compact;

  const InstallmentCard({
    super.key,
    required this.logo,
    required this.description,
    this.logoTint,
    this.onTap,
    this.compact = false,
  });

  TextStyle get _descStyle => AppTypography.caption.copyWith(
    color: AppTheme.textPrimary,
    fontWeight: FontWeight.w500,
    height: 1.3,
    fontSize: 11,
  );

  @override
  Widget build(BuildContext context) {
    final isLtr = Get.find<LocalizationController>().isLtr;

    if (compact) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radius12),
            border: Border.all(color: AppTheme.border, width: 0.75),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: logoTint ?? AppTheme.white,
                  borderRadius: BorderRadius.circular(AppTheme.radius4),
                ),
                child: Align(alignment: Alignment.centerLeft, child: logo),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: _descStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  child: description,
                ),
              ),
              HugeIcon(
                icon: isLtr
                    ? HugeIcons.strokeRoundedArrowRight01
                    : HugeIcons.strokeRoundedArrowLeft01,
                color: AppTheme.textSecondary,
                size: 14,
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing12),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(color: AppTheme.border, width: 0.75),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 22,
                  decoration: BoxDecoration(
                    color: logoTint ?? AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radius4),
                  ),
                  child: Align(alignment: Alignment.centerLeft, child: logo),
                ),
                HugeIcon(
                  icon: isLtr
                      ? HugeIcons.strokeRoundedArrowRight01
                      : HugeIcons.strokeRoundedArrowLeft01,
                  color: AppTheme.textSecondary,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing8),
            DefaultTextStyle.merge(style: _descStyle, child: description),
          ],
        ),
      ),
    );
  }
}
