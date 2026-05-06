import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_header.dart';
import 'package:traveler_app/base/circle_icon_button.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/tours/controller/tours_controller.dart';
import 'package:traveler_app/features/tours/widgets/tour_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/widgets/active_filters_bar.dart';
import 'package:traveler_app/widgets/app_search_field.dart';
import 'package:traveler_app/widgets/filter_bottom_sheet.dart';
import 'package:traveler_app/widgets/search_forms.dart';
import 'package:traveler_app/widgets/sort_bottom_sheet.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  late final ToursController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<ToursController>();
    _c.fetch();
  }

  void _openFilter() {
    showFilterBottomSheet(
      context,
      form: TourSearchForm(
        destinations:
            Get.find<HomeController>().homeData.value?.destinations ?? [],
        onSearch: (args) {
          _c.selectedDestinationId.value = args['destination_id']?.toString();
          _c.selectedDestinationName.value = args['destination_name'];
          _c.selectedTourType.value = args['tour_type'];
          _c.selectedMonth.value = args['month'] != null
              ? DateTime.tryParse(args['month'])
              : null;
          _c.selectedDuration.value = args['duration'];
          Navigator.of(context).pop();
          _c.fetch();
        },
      ),
    );
  }

  String? _sortLabelFor(String? key) {
    switch (key) {
      case 'price_asc':
        return 'price_asc'.tr;
      case 'price_desc':
        return 'price_desc'.tr;
      case 'rating':
        return 'rating'.tr;
      case 'newest':
        return 'newest'.tr;
      default:
        return null;
    }
  }

  String _formatMonth(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}';
  }

  void _openSort() {
    showSortBottomSheet(
      context,
      currentValue: _c.selectedSort.value,
      options: [
        SortOption(key: 'price_asc', label: 'price_asc'.tr),
        SortOption(key: 'price_desc', label: 'price_desc'.tr),
        SortOption(key: 'rating', label: 'rating'.tr),
        SortOption(key: 'newest', label: 'newest'.tr),
      ],
      onApply: (sort) {
        _c.selectedSort.value = sort;
        _c.fetch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppHeader(
        title: 'popular_tours'.tr,
        actions: [
          CircleIconButton(
            icon: HugeIcons.strokeRoundedSorting01,
            onTap: _openSort,
          ),
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
          Obx(() {
            final filters = <ActiveFilter>[];
            final destName = _c.selectedDestinationName.value;
            if (destName != null && destName.isNotEmpty) {
              filters.add(ActiveFilter(
                label: destName,
                onRemove: () {
                  _c.selectedDestinationId.value = null;
                  _c.selectedDestinationName.value = null;
                  _c.fetch();
                },
              ));
            }
            final tourType = _c.selectedTourType.value;
            if (tourType != null && tourType.isNotEmpty) {
              filters.add(ActiveFilter(
                label: tourType,
                onRemove: () {
                  _c.selectedTourType.value = null;
                  _c.fetch();
                },
              ));
            }
            final month = _c.selectedMonth.value;
            if (month != null) {
              filters.add(ActiveFilter(
                label: _formatMonth(month),
                onRemove: () {
                  _c.selectedMonth.value = null;
                  _c.fetch();
                },
              ));
            }
            final duration = _c.selectedDuration.value;
            if (duration != null && duration.isNotEmpty) {
              filters.add(ActiveFilter(
                label: duration,
                onRemove: () {
                  _c.selectedDuration.value = null;
                  _c.fetch();
                },
              ));
            }
            final sortLabel = _sortLabelFor(_c.selectedSort.value);
            if (sortLabel != null) {
              filters.add(ActiveFilter(
                label: sortLabel,
                onRemove: () {
                  _c.selectedSort.value = null;
                  _c.fetch();
                },
              ));
            }
            return ActiveFiltersBar(
              filters: filters,
              onClearAll: filters.isEmpty ? null : _c.clearFilters,
            );
          }),
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_c.tours.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                    vertical: AppTheme.spacing8,
                  ),
                  itemCount: _c.tours.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppTheme.spacing12),
                  itemBuilder: (_, i) => TourCard(
                    tour: _c.tours[i],
                    onTap: () => Get.toNamed(
                      tourDetailRoute,
                      arguments: {'slug': _c.tours[i].slug},
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
