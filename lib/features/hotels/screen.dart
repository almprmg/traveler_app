import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/hotels/controller/hotels_controller.dart';
import 'package:traveler_app/features/hotels/widgets/hotel_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:hugeicons/hugeicons.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  late final HotelsController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<HotelsController>();
    // Always fetch fresh when this screen is opened as a route
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('hotels'.tr),
        actions: [
          IconButton(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedFilterHorizontal),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: _c.search,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_c.hotels.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _c.hotels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => HotelCard(
                    hotel: _c.hotels[i],
                    onTap: () => Get.toNamed(
                      hotelDetailRoute,
                      arguments: {'slug': _c.hotels[i].slug},
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('filters'.tr,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Text('sort_by'.tr,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _filterChip('price_asc'.tr, 'price_asc'),
                _filterChip('price_desc'.tr, 'price_desc'),
                _filterChip('rating'.tr, 'rating'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _c.fetch();
              },
              child: Text('apply'.tr),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _c.clearFilters();
                Get.back();
              },
              child: Text('clear_filters'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return Obx(
      () => FilterChip(
        label: Text(label),
        selected: _c.selectedSort.value == value,
        onSelected: (_) => _c.selectedSort.value = value,
        selectedColor: AppTheme.primaryWithOpacity,
        checkmarkColor: AppTheme.primary,
      ),
    );
  }
}
