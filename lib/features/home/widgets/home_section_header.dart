import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Reusable home page section header — title on the leading side, optional
/// "see all" trailing link.
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

  static const EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(
    AppTheme.spacing24,
    AppTheme.spacing8,
    AppTheme.spacing24,
    AppTheme.spacing12,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _defaultPadding,
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.h4.copyWith(fontWeight: AppTypography.bold),
          ),
          const Spacer(),
          if (onSeeAll != null) _SeeAllLink(onTap: onSeeAll!),
        ],
      ),
    );
  }
}

class _SeeAllLink extends StatelessWidget {
  final VoidCallback onTap;
  const _SeeAllLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            'see_all'.tr,
            style: AppTypography.labelMedium.copyWith(
              color: AppTheme.textTertiary,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(width: AppTheme.spacing2),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: AppTheme.textTertiary,
            size: 14,
          ),
        ],
      ),
    );
  }
}
