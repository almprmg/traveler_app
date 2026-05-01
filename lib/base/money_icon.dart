import 'package:flutter/material.dart';
import 'package:traveler_app/base/sar_log.dart';
import 'package:get/get.dart';

import '../controllers/localization_controller.dart';

class MoneyWithIcon extends StatelessWidget {
  final double money;
  final int precision;
  final Color? color;
  final double iconSize;
  final double textSize;
  final FontWeight fontWeight;
  final TextDecoration? decoration;

  const MoneyWithIcon({
    super.key,
    this.money = 0.0,
    this.precision = 2,
    this.color,
    this.iconSize = 16.0,
    this.textSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = Get.find<LocalizationController>().isLtr;
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLtr)
          SARLogo(height: iconSize, width: iconSize, color: effectiveColor),
        if (isLtr) const SizedBox(width: 4),
        Text(
          money.toStringAsFixed(precision),
          style: TextStyle(
            color: effectiveColor,
            fontSize: textSize,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationColor: effectiveColor,
          ),
        ),
        if (!isLtr) const SizedBox(width: 4),
        if (!isLtr)
          SARLogo(height: iconSize, width: iconSize, color: effectiveColor),
      ],
    );
  }
}
