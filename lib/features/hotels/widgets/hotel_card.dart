import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_details_button.dart';
import 'package:traveler_app/widgets/product_image_hero.dart';

class HotelCard extends StatelessWidget {
  final HotelListItem hotel;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.hotel, required this.onTap});

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
                imageUrl: hotel.imageUrl,
                height: 170,
                fadeHeight: 55,
                bottomEndOverlay: GhostRatingPill(rating: hotel.rating),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing12,
                  0,
                  AppTheme.spacing12,
                  AppTheme.spacing12,
                ),
                child: _Body(hotel: hotel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final HotelListItem hotel;
  const _Body({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotel.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
            height: 1.25,
          ),
        ),
        if (hotel.location != null) ...[
          const SizedBox(height: AppTheme.spacing2),
          _LocationRow(location: hotel.location!),
        ],
        const SizedBox(height: AppTheme.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _PriceRow(pricePerNight: hotel.pricePerNight)),
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

class _PriceRow extends StatelessWidget {
  final double pricePerNight;
  const _PriceRow({required this.pricePerNight});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MoneyWithIcon(
          money: pricePerNight,
          precision: 0,
          textSize: 15,
          color: AppTheme.textPrimary,
          fontWeight: AppTypography.extraBold,
        ),
        const SizedBox(width: AppTheme.spacing4),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            'per_night'.tr,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
