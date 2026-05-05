import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_image_scrim.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeHotelCard extends StatelessWidget {
  final Hotel hotel;
  const HomeHotelCard({super.key, required this.hotel});

  static const double _width = 240;
  static const double _height = 250;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(hotelDetailRoute, arguments: {'slug': hotel.slug}),
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 0.75),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius20 - 1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppCachedImage(imageUrl: hotel.imageUrl, fit: BoxFit.cover),
              const HomeImageScrim(),
              Positioned(
                top: AppTheme.spacing8,
                right: AppTheme.spacing8,
                child: _RatingPill(rating: hotel.rating),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  child: _CardBody(
                    name: hotel.name,
                    location: hotel.location,
                    pricePerNight: hotel.pricePerNight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      mainAxisSize: MainAxisSize.min,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _PriceRow(pricePerNight: pricePerNight)),
            const SizedBox(width: AppTheme.spacing8),
            const _DetailsButton(),
          ],
        ),
      ],
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton();

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
