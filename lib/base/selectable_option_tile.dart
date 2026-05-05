import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

// Shared constants between SelectableOptionTile and FilterBadge
const _kTileRadius = AppTheme.radius20;
const _kTileMargin = EdgeInsets.only(bottom: AppTheme.spacing8);
const _kTilePaddingH = AppTheme.spacing16;
const _kTilePaddingV = AppTheme.spacing12;
const _kAnimDuration = Duration(milliseconds: 240);
const _kAnimCurve = Curves.easeInOut;

/// A reusable single-select option tile.
///
/// White box on grey background, animated border + radio dot (gradient when selected).
/// Use [leading] for icons (e.g. DeliveryTypeIcon), [trailing] for extra info (e.g. MoneyWithIcon).
class SelectableOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool errorHighlight;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets? margin;

  const SelectableOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.errorHighlight = false,
    this.leading,
    this.trailing,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: _kAnimCurve,
        margin: margin ?? _kTileMargin,
        padding: const EdgeInsets.symmetric(
          horizontal: _kTilePaddingH,
          vertical: _kTilePaddingV,
        ),
        decoration: BoxDecoration(
          color: errorHighlight
              ? AppTheme.error.withValues(alpha: 0.04)
              : AppTheme.white,
          borderRadius: BorderRadius.circular(_kTileRadius),
          border: Border.all(
            color: errorHighlight
                ? AppTheme.error.withValues(alpha: 0.4)
                : isSelected
                ? AppTheme.borderDark
                : AppTheme.border,
            width: errorHighlight ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            _RadioDot(isSelected: isSelected),
            if (leading != null) ...[
              const SizedBox(width: AppTheme.spacing12),
              leading!,
            ],
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: _kAnimDuration,
                curve: _kAnimCurve,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isSelected
                      ? AppTypography.semiBold
                      : AppTypography.regular,
                  color: isSelected
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
                child: Text(label),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppTheme.spacing12),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool isSelected;
  const _RadioDot({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kAnimDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isSelected
          ? ShaderMask(
              key: const ValueKey(true),
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedRadioButton,
                size: 22,
                color: Colors.white,
              ),
            )
          : HugeIcon(
              key: const ValueKey(false),
              icon: HugeIcons.strokeRoundedRadioButton,
              size: 22,
              color: AppTheme.borderMedium,
            ),
    );
  }
}
