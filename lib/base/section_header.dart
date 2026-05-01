import 'package:flutter/material.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/base/view_all_button.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String? actionText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.h4.copyWith(fontWeight: FontWeight.w600),
          ),
          if (onViewAll != null)
            ViewAllButton(onTap: onViewAll!, text: actionText),
        ],
      ),
    );
  }
}
