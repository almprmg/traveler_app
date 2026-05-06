import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        image: 'assets/images/tour_icon.webp',
        onTap: () => Get.toNamed(toursRoute),
      ),
      _ActivityItem(
        label: 'tab_hotel'.tr,
        image: 'assets/images/hotel_icon.webp',
        onTap: () => Get.toNamed(hotelsRoute),
      ),
      _ActivityItem(
        label: 'tab_transport'.tr,
        image: 'assets/images/transport_icon.webp',
        onTap: () => Get.toNamed(transportsRoute),
      ),
      _ActivityItem(
        label: 'tab_visa'.tr,
        image: 'assets/images/visa_icon.webp',
        onTap: () => Get.toNamed(visasRoute),
      ),
      _ActivityItem(
        label: 'tab_activities'.tr,
        image: 'assets/images/Activities_icon.webp',
        onTap: () => Get.toNamed(activitiesRoute),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              'browse_by_activity'.tr,
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 8),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _ActivityCard(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String label;
  final String image;
  final VoidCallback onTap;
  _ActivityItem({
    required this.label,
    required this.image,
    required this.onTap,
  });
}

class _ActivityCard extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Material(
        color: AppTheme.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    item.image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
