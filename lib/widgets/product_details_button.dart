import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Ghost-style "Details" pill used at the bottom-end of product cards.
class ProductDetailsButton extends StatelessWidget {
  const ProductDetailsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'details'.tr,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textPrimary,
              fontSize: 10,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(width: AppTheme.spacing2),
          HugeIcon(
            icon: isRtl
                ? HugeIcons.strokeRoundedArrowLeft01
                : HugeIcons.strokeRoundedArrowRight01,
            color: AppTheme.textPrimary,
            size: 12,
          ),
        ],
      ),
    );
  }
}

/// Reusable rating pill (star + number) for top-end of product cards.
class ProductRatingPill extends StatelessWidget {
  final double rating;
  const ProductRatingPill({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedStar,
            color: AppTheme.gold,
            size: 14,
          ),
          const SizedBox(width: AppTheme.spacing2),
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.extraBold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable category/badge pill — solid white with subtle border.
class ProductBadgePill extends StatelessWidget {
  final String label;
  const ProductBadgePill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(color: AppTheme.cardBorder, width: 0.5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSmall.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }
}
