import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveryTypeIcon extends StatelessWidget {
  final String? code;
  final double size;
  final Color? color;

  const DeliveryTypeIcon({
    super.key,
    required this.code,
    this.size = 28,
    this.color,
  });

  String get _asset {
    final c = code?.toLowerCase() ?? '';
    if (c.contains('pickup')) return 'assets/svg/fitment-options/pickup.svg';
    if (c.contains('deliver')) return 'assets/svg/fitment-options/delivery.svg';
    return 'assets/svg/fitment-options/shipping.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _asset,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
