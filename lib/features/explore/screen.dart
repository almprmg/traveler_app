import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/hotels/controller/hotels_controller.dart';
import 'package:traveler_app/features/hotels/widgets/hotel_card.dart';
import 'package:traveler_app/features/tours/controller/tours_controller.dart';
import 'package:traveler_app/features/tours/widgets/tour_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/widgets/app_search_field.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('explore'.tr),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(text: 'popular_tours'.tr),
              Tab(text: 'hotels'.tr),
            ],
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _ToursTab(),
            _HotelsTab(),
          ],
        ),
      ),
    );
  }
}

class _ToursTab extends StatelessWidget {
  const _ToursTab();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ToursController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: AppSearchField(onChanged: c.search),
        ),
        Expanded(
          child: Obx(() {
            if (c.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (c.tours.isEmpty) {
              return EmptyState(onRefresh: c.fetch);
            }
            return RefreshIndicator(
              onRefresh: c.fetch,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: c.tours.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => TourCard(
                  tour: c.tours[i],
                  onTap: () => Get.toNamed(
                    tourDetailRoute,
                    arguments: {'slug': c.tours[i].slug},
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HotelsTab extends StatelessWidget {
  const _HotelsTab();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HotelsController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: AppSearchField(onChanged: c.search),
        ),
        Expanded(
          child: Obx(() {
            if (c.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (c.hotels.isEmpty) {
              return EmptyState(onRefresh: c.fetch);
            }
            return RefreshIndicator(
              onRefresh: c.fetch,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: c.hotels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => HotelCard(
                  hotel: c.hotels[i],
                  onTap: () => Get.toNamed(
                    hotelDetailRoute,
                    arguments: {'slug': c.hotels[i].slug},
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
