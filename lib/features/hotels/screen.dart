import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_header.dart';
import 'package:traveler_app/base/circle_icon_button.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/hotels/controller/hotels_controller.dart';
import 'package:traveler_app/features/hotels/widgets/hotel_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/widgets/app_search_field.dart';
import 'package:traveler_app/widgets/filter_bottom_sheet.dart';
import 'package:traveler_app/widgets/search_forms.dart';

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
    _c.fetch();
  }

  void _openFilter() {
    showFilterBottomSheet(
      context,
      form: HotelSearchForm(
        destinations:
            Get.find<HomeController>().homeData.value?.destinations ?? [],
        onSearch: (_) {
          Navigator.of(context).pop();
          _c.fetch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppHeader(
        title: 'hotels'.tr,
        actions: [
          CircleIconButton(
            icon: HugeIcons.strokeRoundedFilterHorizontal,
            onTap: _openFilter,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacing16,
              AppTheme.spacing12,
              AppTheme.spacing16,
              AppTheme.spacing8,
            ),
            child: AppSearchField(onChanged: _c.search),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  itemCount: _c.hotels.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppTheme.spacing12),
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
}
