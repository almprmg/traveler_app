import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/sunny_sky.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/home/widgets/home_activities_strip.dart';
import 'package:traveler_app/features/home/widgets/home_app_bar.dart';
import 'package:traveler_app/features/home/widgets/home_popular_hotels_section.dart';
import 'package:traveler_app/features/home/widgets/home_promo_section.dart';
import 'package:traveler_app/features/home/widgets/home_recommended_section.dart';
import 'package:traveler_app/features/home/widgets/home_search_pill.dart';
import 'package:traveler_app/features/home/widgets/home_skeleton.dart';
import 'package:traveler_app/features/home/widgets/home_top_destinations_section.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _scrolled = false;

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    final scrolled = n.metrics.pixels > 4;
    if (scrolled != _scrolled) {
      setState(() => _scrolled = scrolled);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          SkyBackground(
            child: SafeArea(
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
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedSmartphoneLostWifi,
                          size: 48,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'failed_to_load'.tr,
                          style: AppTypography.bodyMedium,
                        ),
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
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onScroll,
                    child: CustomScrollView(
                      slivers: [
                        const HomeAppBar(),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        const SliverToBoxAdapter(child: HomeSearchPill()),
                        const SliverToBoxAdapter(child: HomeActivitiesStrip()),
                        SliverToBoxAdapter(
                          child: HomeRecommendedSection(tours: data.tours),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverToBoxAdapter(
                          child: HomePromoSection(banners: data.banners),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverToBoxAdapter(
                          child: HomeTopDestinationsSection(
                            destinations: data.destinations,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        SliverToBoxAdapter(
                          child: HomePopularHotelsSection(hotels: data.hotels),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 110)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                color: _scrolled ? AppTheme.white : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
