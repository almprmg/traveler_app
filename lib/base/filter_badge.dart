import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

const _kBadgeRadius = AppTheme.radius20;
const _kAnimDuration = Duration(milliseconds: 220);
const _kAnimCurve = Curves.easeInOut;

/// Reusable badge chip for filter sections.
/// White with border when unselected, blue gradient when selected.
class FilterBadge extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterBadge({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: _kAnimCurve,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(_kBadgeRadius),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.border,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_kBadgeRadius),
          child: Stack(
            children: [
              /// Gradient fills the entire badge
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: _kAnimDuration,
                  curve: _kAnimCurve,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),

              /// Content with fixed padding
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSize(
                      duration: _kAnimDuration,
                      curve: _kAnimCurve,
                      child: isSelected
                          ? Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: AppTheme.spacing6,
                              ),
                              child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedTick02,
                                  size: 11,
                                  color: AppTheme.primary,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: _kAnimDuration,
                      curve: _kAnimCurve,
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected
                            ? AppTheme.white
                            : AppTheme.textSecondary,
                        fontWeight: isSelected
                            ? AppTypography.semiBold
                            : AppTypography.regular,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
