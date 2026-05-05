import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/destinations/controller/destinations_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:hugeicons/hugeicons.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DestinationDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final d = c.destination.value;
        if (d == null) return DetailErrorView(onRetry: c.fetch);
        return CustomScrollView(
          slivers: [
            ProductHeroSliver(imageUrl: d.imageUrl),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name, style: AppTypography.h2),
                    const SizedBox(height: 8),
                    if (d.description.isNotEmpty)
                      Text(
                        d.description,
                        style: AppTypography.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
            if (d.tours.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'popular_tours'.tr,
                  child: Column(
                    children: [
                      for (final t in d.tours)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => Get.toNamed(
                              tourDetailRoute,
                              arguments: {'slug': t.slug},
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radius16),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.horizontal(
                                      left: Radius.circular(
                                          AppTheme.radius16),
                                    ),
                                    child: AppCachedImage(
                                      imageUrl: t.imageUrl,
                                      width: 110,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            t.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodyLarge
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const HugeIcon(icon: HugeIcons.strokeRoundedStar, size: 14,
                                                color: AppTheme.gold,),
                                              const SizedBox(width: 2),
                                              Text(
                                                t.rating.toStringAsFixed(1),
                                                style: AppTypography
                                                    .bodySmall
                                                    .copyWith(
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                              const Spacer(),
                                              MoneyWithIcon(
                                                money: t.price,
                                                precision: 0,
                                                textSize: 14,
                                                color: AppTheme.primary,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      }),
    );
  }
}
