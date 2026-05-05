import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/esim/controller/esim_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class EsimBrowseScreen extends StatefulWidget {
  const EsimBrowseScreen({super.key});

  @override
  State<EsimBrowseScreen> createState() => _EsimBrowseScreenState();
}

class _EsimBrowseScreenState extends State<EsimBrowseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final EsimBrowseController _c;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _c = Get.find<EsimBrowseController>();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('esim'.tr),
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(text: 'esim_countries'.tr),
            Tab(text: 'esim_regions'.tr),
          ],
        ),
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingBag01,
              color: AppTheme.textPrimary,
              size: 22,
            ),
            tooltip: 'esim_orders'.tr,
            onPressed: () => Get.toNamed(esimOrdersRoute),
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSmartPhone01,
              color: AppTheme.textPrimary,
              size: 22,
            ),
            tooltip: 'esim_profiles'.tr,
            onPressed: () => Get.toNamed(esimProfilesRoute),
          ),
        ],
      ),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return TabBarView(
          controller: _tab,
          children: [
            _CountriesGrid(controller: _c),
            _RegionsList(controller: _c),
          ],
        );
      }),
    );
  }
}

class _CountriesGrid extends StatelessWidget {
  final EsimBrowseController controller;
  const _CountriesGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.countries.isEmpty) {
      return EmptyState(onRefresh: controller.fetch);
    }
    return RefreshIndicator(
      onRefresh: controller.fetch,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: controller.countries.length,
        itemBuilder: (_, i) {
          final c = controller.countries[i];
          return GestureDetector(
            onTap: () => Get.toNamed(
              esimPackagesRoute,
              arguments: {'country': c.code, 'name': c.name},
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
                border: Border.all(color: AppTheme.cardBorder, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (c.flagUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AppCachedImage(
                        imageUrl: c.flagUrl!,
                        width: 44,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    c.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${c.packagesCount} ${'esim_packages'.tr}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  Text(
                    'from ${c.minPrice.toStringAsFixed(2)} ${'usd'.tr}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RegionsList extends StatelessWidget {
  final EsimBrowseController controller;
  const _RegionsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.regions.isEmpty) {
      return EmptyState(onRefresh: controller.fetch);
    }
    return RefreshIndicator(
      onRefresh: controller.fetch,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.regions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final r = controller.regions[i];
          return GestureDetector(
            onTap: () => Get.toNamed(
              esimPackagesRoute,
              arguments: {'region': r.slug, 'name': r.name},
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radius16),
                border: Border.all(color: AppTheme.cardBorder, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryWithOpacity,
                      shape: BoxShape.circle,
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedGlobe02,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name,
                            style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700)),
                        Text('${r.packagesCount} ${'esim_packages'.tr}',
                            style: AppTypography.labelSmall.copyWith(
                                color: AppTheme.textTertiary)),
                      ],
                    ),
                  ),
                  Text(
                    'from ${r.minPrice.toStringAsFixed(2)}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
