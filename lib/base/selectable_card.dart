import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traveler_app/util/app_theme.dart';

/// A global selectable card wrapper.
///
/// Wraps [child] with an animated glass-style border and shows
/// [assets/svg/verified.svg] in the trailing position when [isSelected].
///
/// Usage:
/// ```dart
/// SelectableCard(
///   isSelected: _selectedIndex == i,
///   onTap: () => setState(() => _selectedIndex = i),
///   child: Row(children: [ ... ]),
/// )
/// ```
///
/// Parameters:
/// - [isSelected]   — drives border + badge visibility
/// - [onTap]        — tap callback
/// - [child]        — your card content (fills the row)
/// - [padding]      — defaults to 16 on all sides
/// - [margin]       — defaults to bottom: 8
/// - [borderRadius] — defaults to [AppTheme.radius12]
/// - [showVerified] — set false to hide the verified badge (default true)
class SelectableCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool showVerified;

  const SelectableCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppTheme.radius12;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: margin ?? const EdgeInsets.only(bottom: AppTheme.spacing8),
        padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.white.withValues(alpha: isSelected ? 0.92 : 0.55),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryLight.withValues(alpha: 0.4)
                : AppTheme.white.withValues(alpha: 0.6),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            if (isSelected && showVerified) ...[
              const SizedBox(width: AppTheme.spacing8),
              SvgPicture.asset(
                'assets/svg/verified.svg',
                width: 22,
                height: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
