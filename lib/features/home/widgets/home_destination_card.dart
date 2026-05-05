import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeDestinationCard extends StatelessWidget {
  final Destination destination;
  const HomeDestinationCard({super.key, required this.destination});

  static const double _width = 130;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        destinationDetailRoute,
        arguments: {
          'slug': destination.slug,
          'destination_name': destination.name,
        },
      ),
      child: SizedBox(
        width: _width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppCachedImage(
                imageUrl: destination.imageUrl,
                fit: BoxFit.cover,
              ),
              const _BottomScrim(),
              _DestinationLabel(name: destination.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0xB3000000)],
          stops: [0.45, 1.0],
        ),
      ),
    );
  }
}

class _DestinationLabel extends StatelessWidget {
  final String name;
  const _DestinationLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppTheme.spacing12,
      right: AppTheme.spacing12,
      bottom: AppTheme.spacing12,
      child: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyLarge.copyWith(
          color: AppTheme.white,
          fontWeight: AppTypography.extraBold,
        ),
      ),
    );
  }
}
