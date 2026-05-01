import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class GhostFab extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GhostFab({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(AppTheme.radius24),
      elevation: 2,
      shadowColor: AppTheme.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius24),
            border: Border.all(color: AppTheme.border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedAdd01,
                size: 20,
                color: AppTheme.primary,
              ),
              const Gap(AppTheme.spacing8),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
