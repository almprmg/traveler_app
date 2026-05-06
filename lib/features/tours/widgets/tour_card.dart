import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_details_button.dart';
import 'package:traveler_app/widgets/product_image_hero.dart';

class TourCard extends StatelessWidget {
  final TourListItem tour;
  final VoidCallback onTap;

  const TourCard({super.key, required this.tour, required this.onTap});

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
                imageUrl: tour.imageUrl,
                height: 170,
                fadeHeight: 55,
                topEndOverlay: tour.categoryName != null
                    ? ProductBadgePill(label: tour.categoryName!)
                    : null,
                bottomEndOverlay: _GhostRatingPill(rating: tour.rating),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing12,
                  0,
                  AppTheme.spacing12,
                  AppTheme.spacing12,
                ),
                child: _Body(tour: tour),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TourListItem tour;
  const _Body({required this.tour});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tour.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
            height: 1.25,
          ),
        ),
        if (tour.location != null) ...[
          const SizedBox(height: AppTheme.spacing2),
          _LocationRow(location: tour.location!),
        ],
        const SizedBox(height: AppTheme.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: MoneyWithIcon(
                money: tour.price,
                precision: 0,
                textSize: 15,
                color: AppTheme.textPrimary,
                fontWeight: AppTypography.extraBold,
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

class _LocationRow extends StatelessWidget {
  final String location;
  const _LocationRow({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedLocation01,
          color: AppTheme.textTertiary,
          size: 12,
        ),
        const SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _GhostRatingPill extends StatelessWidget {
  final double rating;
  const _GhostRatingPill({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(
          color: AppTheme.white.withValues(alpha: 0.4),
          width: 0.75,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/svg/star_icon.svg", width: 14, height: 14),
          const SizedBox(width: AppTheme.spacing2),
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.white,
              fontWeight: AppTypography.extraBold,
            ),
          ),
        ],
      ),
    );
  }
}
