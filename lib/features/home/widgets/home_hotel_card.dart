import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeHotelCard extends StatelessWidget {
  final Hotel hotel;
  const HomeHotelCard({super.key, required this.hotel});

  static const double _width = 240;
  static const double _imageHeight = 140;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(hotelDetailRoute, arguments: {'slug': hotel.slug}),
      child: Container(
        width: _width,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHero(imageUrl: hotel.imageUrl, rating: hotel.rating),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              child: _CardBody(
                name: hotel.name,
                location: hotel.location,
                pricePerNight: hotel.pricePerNight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHero extends StatelessWidget {
  final String imageUrl;
  final double rating;

  const _CardHero({required this.imageUrl, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppCachedImage(
          imageUrl: imageUrl,
          height: HomeHotelCard._imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: AppTheme.spacing8,
          right: AppTheme.spacing8,
          child: _RatingPill(rating: rating),
        ),
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  final double rating;
  const _RatingPill({required this.rating});

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

class _CardBody extends StatelessWidget {
  final String name;
  final String location;
  final double pricePerNight;

  const _CardBody({
    required this.name,
    required this.location,
    required this.pricePerNight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        _LocationRow(location: location),
        const SizedBox(height: AppTheme.spacing8),
        _PriceRow(pricePerNight: pricePerNight),
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
          textSize: 16,
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
