import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/activities/model/activity_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_details_button.dart';
import 'package:traveler_app/widgets/product_image_hero.dart';

class ActivityCard extends StatelessWidget {
  final ActivityListItem activity;
  final VoidCallback onTap;

  const ActivityCard({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 0.75),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius20 - 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ProductImageHero(
                imageUrl: activity.imageUrl,
                height: 170,
                fadeHeight: 55,
                bottomEndOverlay: GhostRatingPill(rating: activity.rating),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing12,
                  0,
                  AppTheme.spacing12,
                  AppTheme.spacing12,
                ),
                child: _Body(activity: activity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ActivityListItem activity;
  const _Body({required this.activity});

  @override
  Widget build(BuildContext context) {
    final hasSale =
        activity.salePrice != null && activity.salePrice! < activity.price;
    final price = hasSale ? activity.salePrice! : activity.price;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activity.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
            height: 1.25,
          ),
        ),
        if (activity.days > 0 || activity.nights > 0) ...[
          const SizedBox(height: AppTheme.spacing2),
          _DurationRow(days: activity.days, nights: activity.nights),
        ],
        const SizedBox(height: AppTheme.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _PriceRow(
                price: price,
                originalPrice: hasSale ? activity.price : null,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            const ProductDetailsButton(),
          ],
        ),
      ],
    );
  }
}

class _DurationRow extends StatelessWidget {
  final int days;
  final int nights;
  const _DurationRow({required this.days, required this.nights});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedClock01,
          color: AppTheme.textTertiary,
          size: 12,
        ),
        const SizedBox(width: AppTheme.spacing4),
        Text(
          '${days}D / ${nights}N',
          style: AppTypography.labelSmall.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final double price;
  final double? originalPrice;
  const _PriceRow({required this.price, this.originalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (originalPrice != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              originalPrice!.toStringAsFixed(0),
              style: AppTypography.labelSmall.copyWith(
                color: AppTheme.textTertiary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
        ],
        MoneyWithIcon(
          money: price,
          precision: 0,
          textSize: 15,
          color: AppTheme.textPrimary,
          fontWeight: AppTypography.extraBold,
        ),
      ],
    );
  }
}
