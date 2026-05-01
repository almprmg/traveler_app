import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/nav/controller/nav_controller.dart';
import 'package:traveler_app/features/nav/widgets/nav_item.dart';

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
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'home'.tr,
                isSelected: nav.currentIndex == 0,
                onTap: () => nav.changeTab(0),
              ),
              NavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'explore'.tr,
                isSelected: nav.currentIndex == 1,
                onTap: () => nav.changeTab(1),
              ),
              NavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'reservations'.tr,
                isSelected: nav.currentIndex == 2,
                onTap: () => nav.changeTab(2),
              ),
              NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
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
