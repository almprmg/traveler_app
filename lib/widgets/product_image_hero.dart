import 'package:flutter/material.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/util/app_theme.dart';

/// Top hero of a product card — image with a soft bottom fade to white so it
/// blends seamlessly into the card's white content area below.
class ProductImageHero extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double fadeHeight;
  final Widget? topEndOverlay;
  final Widget? bottomEndOverlay;

  const ProductImageHero({
    super.key,
    required this.imageUrl,
    this.height = 190,
    this.fadeHeight = 70,
    this.topEndOverlay,
    this.bottomEndOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: fadeHeight,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FFFFFF), Color(0xCCFFFFFF), AppTheme.white],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          if (topEndOverlay != null)
            PositionedDirectional(
              top: AppTheme.spacing12,
              end: AppTheme.spacing12,
              child: topEndOverlay!,
            ),
          if (bottomEndOverlay != null)
            PositionedDirectional(
              bottom: AppTheme.spacing12 + fadeHeight * 0.45,
              end: AppTheme.spacing12,
              child: bottomEndOverlay!,
            ),
        ],
      ),
    );
  }
}
