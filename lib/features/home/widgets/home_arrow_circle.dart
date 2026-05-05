import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeArrowCircle extends StatelessWidget {
  final double size;
  final Color background;
  final Color iconColor;
  final double iconSize;

  const HomeArrowCircle({
    super.key,
    this.size = 28,
    this.background = AppTheme.backgroundLight,
    this.iconColor = AppTheme.textPrimary,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: HugeIcon(
        icon: isRtl
            ? HugeIcons.strokeRoundedArrowLeft01
            : HugeIcons.strokeRoundedArrowRight01,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
