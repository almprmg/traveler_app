import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Reusable home page section header used by promo, destinations, hotels, etc.
class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final EdgeInsets? padding;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  Text(
                    'see_all'.tr,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppTheme.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: AppTheme.textTertiary,
                    size: 14,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
