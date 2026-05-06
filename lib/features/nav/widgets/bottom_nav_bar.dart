import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/features/nav/controller/nav_controller.dart';
import 'package:traveler_app/features/nav/widgets/nav_item.dart';
import 'package:traveler_app/util/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();
    final bottom = MediaQuery.of(context).padding.bottom;

    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: Border.all(color: AppTheme.cardBorder, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              NavItem(
                icon: HugeIcons.strokeRoundedHome01,
                activeIcon: HugeIcons.strokeRoundedHome01,
                label: 'home'.tr,
                isSelected: nav.currentIndex == 0,
                onTap: () => nav.changeTab(0),
              ),
              NavItem(
                icon: HugeIcons.strokeRoundedDiscoverCircle,
                activeIcon: HugeIcons.strokeRoundedDiscoverCircle,
                label: 'explore'.tr,
                isSelected: nav.currentIndex == 1,
                onTap: () => nav.changeTab(1),
              ),
              NavItem(
                icon: HugeIcons.strokeRoundedCalendar03,
                activeIcon: HugeIcons.strokeRoundedCalendar03,
                label: 'reservations'.tr,
                isSelected: nav.currentIndex == 2,
                onTap: () => nav.changeTab(2),
              ),
              NavItem(
                icon: HugeIcons.strokeRoundedUser,
                activeIcon: HugeIcons.strokeRoundedUser,
                label: 'profile'.tr,
                isSelected: nav.currentIndex == 3,
                onTap: () => nav.changeTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
