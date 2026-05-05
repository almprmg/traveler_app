import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeActivitiesStrip extends StatelessWidget {
  const HomeActivitiesStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ActivityItem>[
      _ActivityItem(
        label: 'tab_tour'.tr,
        icon: HugeIcons.strokeRoundedLocation04,
        color: const Color(0xFF61B6F7),
        onTap: () => Get.toNamed(toursRoute),
      ),
      _ActivityItem(
        label: 'tab_hotel'.tr,
        icon: HugeIcons.strokeRoundedHotel01,
        color: const Color(0xFFF6B756),
        onTap: () => Get.toNamed(hotelsRoute),
      ),
      _ActivityItem(
        label: 'tab_activities'.tr,
        icon: HugeIcons.strokeRoundedActivity01,
        color: const Color(0xFF7CC58A),
        onTap: () => Get.toNamed(activitiesRoute),
      ),
      _ActivityItem(
        label: 'tab_visa'.tr,
        icon: HugeIcons.strokeRoundedPassport,
        color: const Color(0xFFB28BE3),
        onTap: () => Get.toNamed(visasRoute),
      ),
      _ActivityItem(
        label: 'tab_transport'.tr,
        icon: HugeIcons.strokeRoundedCar01,
        color: const Color(0xFFE3826B),
        onTap: () => Get.toNamed(transportsRoute),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text(
              'browse_by_activity'.tr,
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final it in items) _ActivityCircle(item: it),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String label;
  final List<List<dynamic>> icon;
  final Color color;
  final VoidCallback onTap;
  _ActivityItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ActivityCircle extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityCircle({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: HugeIcon(icon: item.icon, color: item.color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
