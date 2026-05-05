import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/packages/controller/packages_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PackageDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final p = c.pkg.value;
        if (p == null) return DetailErrorView(onRetry: c.fetch);
        return CustomScrollView(
          slivers: [
            ProductHeroSliver(imageUrl: p.imageUrl),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (p.duration != null) DetailBadge(text: p.duration!),
                        if (p.isFeatured)
                          DetailBadge(
                            text: 'featured'.tr,
                            color: AppTheme.gold,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(p.title, style: AppTypography.h2),
                    const SizedBox(height: 6),
                    if (p.shortDesc != null)
                      Text(
                        p.shortDesc!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 10),
                    DetailRatingPill(
                      rating: p.rating,
                      reviewsCount: p.reviewsCount,
                    ),
                  ],
                ),
              ),
            ),
            if (p.destinations.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'destinations'.tr,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.destinations
                        .map((d) => DetailBadge(
                              text: d,
                              color: AppTheme.success,
                            ))
                        .toList(),
                  ),
                ),
              ),
            if (p.content.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'description'.tr,
                  child: Text(p.content, style: AppTypography.bodyMedium),
                ),
              ),
            if (p.highlights.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'highlights'.tr,
                  child: BulletList(
                    items: p.highlights,
                    hugeIcon: HugeIcons.strokeRoundedStar,
                    iconColor: AppTheme.gold,
                  ),
                ),
              ),
            if (p.includes.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'includes'.tr,
                  child: BulletList(
                    items: p.includes,
                    hugeIcon: HugeIcons.strokeRoundedCheckmarkCircle02,
                    iconColor: AppTheme.success,
                  ),
                ),
              ),
            if (p.excludes.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'excludes'.tr,
                  child: BulletList(
                    items: p.excludes,
                    hugeIcon: HugeIcons.strokeRoundedCancel01,
                    iconColor: AppTheme.error,
                  ),
                ),
              ),
            if (p.itinerary.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'itinerary'.tr,
                  child: DetailFaqList(
                    items: p.itinerary
                        .map((i) => (title: i.title, content: i.content))
                        .toList(),
                  ),
                ),
              ),
            if (p.faqs.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'faqs'.tr,
                  child: DetailFaqList(
                    items: p.faqs
                        .map((f) => (title: f.title, content: f.content))
                        .toList(),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final p = c.pkg.value;
        if (p == null) return const SizedBox.shrink();
        return BookNowBar(
          price: p.salePrice ?? p.price,
          priceLabel: 'price_per_person'.tr,
          onPressed: () => Get.toNamed(
            bookingCreateRoute,
            arguments: {
              'product_type': 'package',
              'product_id': p.id,
              'product_title': p.title,
              'unit_price': p.salePrice ?? p.price,
            },
          ),
        );
      }),
    );
  }
}
