import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_arrow_circle.dart';
import 'package:traveler_app/features/home/widgets/home_travelled_badge.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeRecommendedCard extends StatelessWidget {
  final Tour tour;
  const HomeRecommendedCard({super.key, required this.tour});

  static const double _width = 220;
  static const double _height = 268;
  static const double _imageHeight = 130;

  @override
  Widget build(BuildContext context) {
    final seed = tour.slug.hashCode;
    final travelled = 5000 + Random(seed).nextInt(5001);

    return GestureDetector(
      onTap: () =>
          Get.toNamed(tourDetailRoute, arguments: {'slug': tour.slug}),
      child: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHero(imageUrl: tour.imageUrl, height: _imageHeight),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                child: _CardBody(
                  title: tour.title,
                  location: tour.title,
                  travelledCount: travelled,
                  seed: seed,
                ),
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
  final double height;

  const _CardHero({required this.imageUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppCachedImage(
          imageUrl: imageUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const Positioned(
          top: AppTheme.spacing8,
          right: AppTheme.spacing8,
          child: _FavoriteButton(),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing6),
      decoration: BoxDecoration(
        color: AppTheme.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedFavourite,
        color: AppTheme.error,
        size: 16,
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final String title;
  final String location;
  final int travelledCount;
  final int seed;

  const _CardBody({
    required this.title,
    required this.location,
    required this.travelledCount,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        _LocationRow(location: location),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: HomeTravelledBadge(count: travelledCount, seed: seed),
            ),
            const SizedBox(width: AppTheme.spacing8),
            const HomeArrowCircle(),
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
