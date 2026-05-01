import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/home/widgets/home_app_bar.dart';
import 'package:traveler_app/features/home/widgets/home_banner_section.dart';
import 'package:traveler_app/features/home/widgets/home_destinations_section.dart';
import 'package:traveler_app/features/home/widgets/home_hotels_section.dart';
import 'package:traveler_app/features/home/widgets/home_section_label.dart';
import 'package:traveler_app/features/home/widgets/home_skeleton.dart';
import 'package:traveler_app/features/home/widgets/home_tours_section.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const HomeSkeletonScreen();
          }
          final data = controller.homeData.value;
          if (data == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('failed_to_load'.tr),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchHome,
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: controller.fetchHome,
            child: CustomScrollView(
              slivers: [
                const HomeAppBar(),
                SliverToBoxAdapter(
                  child: HomeBannerSection(banners: data.banners),
                ),
                SliverToBoxAdapter(
                  child: HomeSectionLabel(
                    label: 'destinations'.tr,
                    onViewAll: () => Get.toNamed(toursRoute),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HomeDestinationsSection(
                    destinations: data.destinations,
                  ),
                ),
                SliverToBoxAdapter(
                  child: HomeSectionLabel(
                    label: 'popular_tours'.tr,
                    onViewAll: () => Get.toNamed(toursRoute),
                  ),
                ),
                SliverToBoxAdapter(child: HomeToursSection(tours: data.tours)),
                SliverToBoxAdapter(
                  child: HomeSectionLabel(
                    label: 'hotels'.tr,
                    onViewAll: () => Get.toNamed(hotelsRoute),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HomeHotelsSection(hotels: data.hotels),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
