import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeSearchPill extends StatelessWidget {
  const HomeSearchPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Material(
        color: AppTheme.white,
        shape: const StadiumBorder(
          side: BorderSide(color: AppTheme.cardBorder, width: 1),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => Get.toNamed(exploreRoute),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: AppTheme.textTertiary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'home_search_hint'.tr,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
