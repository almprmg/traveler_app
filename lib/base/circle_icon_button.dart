import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';

/// Project-wide circular icon button used in app headers, top bars, and
/// any place that needs a back/close/utility action in a 44×44 white
/// circle with a hairline border (matches the product-details header).
///
/// Set [isGradient] to render the primary gradient background with a
/// white glyph instead of the default white-bg/hairline look.
class CircleIconButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final bool isGradient;
  final Color? iconColor;
  final Color? backgroundColor;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 38,
    this.iconSize = 18,
    this.isGradient = false,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor =
        iconColor ?? (isGradient ? AppTheme.white : AppTheme.textPrimary);
    final resolvedBg =
        backgroundColor ?? (isGradient ? Colors.transparent : AppTheme.white);

    return Material(
      color: resolvedBg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isGradient ? AppTheme.primaryGradient : null,
            border: isGradient
                ? null
                : Border.all(color: AppTheme.border, width: 1),
          ),
          child: HugeIcon(icon: icon, color: resolvedIconColor, size: iconSize),
        ),
      ),
    );
  }
}
