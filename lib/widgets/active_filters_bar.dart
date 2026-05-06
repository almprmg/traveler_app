import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class ActiveFilter {
  final String label;
  final VoidCallback onRemove;
  const ActiveFilter({required this.label, required this.onRemove});
}

/// Horizontal strip showing a "Active filters" caption + a row of chips for
/// each currently-applied filter. Each chip carries an `×` to remove that
/// single filter. Hides itself when [filters] is empty.
class ActiveFiltersBar extends StatelessWidget {
  final List<ActiveFilter> filters;
  final VoidCallback? onClearAll;

  const ActiveFiltersBar({super.key, required this.filters, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing16,
        AppTheme.spacing4,
        AppTheme.spacing16,
        AppTheme.spacing8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'active_filters'.tr,
                style: AppTypography.labelMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const Spacer(),
              if (onClearAll != null)
                GestureDetector(
                  onTap: onClearAll,
                  child: Text(
                    'clear_filters'.tr,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppTheme.primary,
                      fontWeight: AppTypography.semiBold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in filters) ...[
                  _FilterChip(filter: f),
                  const SizedBox(width: AppTheme.spacing8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final ActiveFilter filter;
  const _FilterChip({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppTheme.spacing12,
        AppTheme.spacing4,
        AppTheme.spacing6,
        AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filter.label,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          GestureDetector(
            onTap: filter.onRemove,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const HugeIcon(
                icon: HugeIcons.strokeRoundedCancel01,
                color: AppTheme.error,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
