import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/features/categories/controller/categories_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final CategoriesController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.find<CategoriesController>();
    _c.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('categories'.tr)),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: Obx(() => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: CategoriesController.types.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final t = CategoriesController.types[i];
                    final selected = _c.selectedType.value == t;
                    return ChoiceChip(
                      label: Text(
                        'category_type_$t'.tr,
                        style: TextStyle(
                          color:
                              selected ? AppTheme.white : AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      selected: selected,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.white,
                      onSelected: (_) => _c.selectType(t),
                    );
                  },
                )),
          ),
          Expanded(
            child: Obx(() {
              if (_c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final g = _c.group.value;
              if (g == null || g.categories.isEmpty) {
                return EmptyState(onRefresh: _c.fetch);
              }
              return RefreshIndicator(
                onRefresh: _c.fetch,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: g.categories.length,
                  itemBuilder: (_, i) {
                    final cat = g.categories[i];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        toursRoute,
                        arguments: {'category_id': cat.id},
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radius16),
                          border: Border.all(color: AppTheme.cardBorder, width: 1),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const HugeIcon(
                                icon: HugeIcons.strokeRoundedFolder01,
                                color: AppTheme.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall.copyWith(
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
            }),
          ),
        ],
      ),
    );
  }
}
