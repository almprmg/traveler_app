import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Row(
          children: [
            _CircleButton(
              icon: HugeIcons.strokeRoundedFilterHorizontal,
              onTap: () {},
            ),
            const Spacer(),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedLocation01,
              color: AppTheme.primary,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              'home_default_location'.tr,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            _CircleButton(
              icon: HugeIcons.strokeRoundedNotification03,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      shape: const CircleBorder(
        side: BorderSide(color: AppTheme.cardBorder, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: HugeIcon(
            icon: icon,
            color: AppTheme.textPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}
