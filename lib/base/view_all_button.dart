import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;

  const ViewAllButton({super.key, required this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppTheme.border.withValues(alpha: 0.4)),
            ),
            child: Text(
              text ?? 'view_all'.tr,
              style: AppTypography.bodySmall.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
