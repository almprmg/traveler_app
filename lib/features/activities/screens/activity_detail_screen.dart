import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/activities/controller/activities_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ActivityDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final a = c.activity.value;
        if (a == null) return DetailErrorView(onRetry: c.fetch);

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHero(imageUrl: a.imageUrl),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (a.duration != null)
                              DetailBadge(text: a.duration!),
                            if (a.location != null)
                              DetailBadge(
                                text: a.location!,
                                color: AppTheme.success,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(a.title, style: AppTypography.h2),
                        const SizedBox(height: 6),
                        if (a.country != null)
                          Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedLocation01,
                                color: AppTheme.textTertiary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                a.country!,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        DetailRatingPill(
                          rating: a.rating,
                          reviewsCount: a.reviewsCount,
                        ),
                      ],
                    ),
                  ),
                  if (a.description.isNotEmpty)
                    DetailSection(
                      title: 'description'.tr,
                      child: HtmlWidget(
                        a.description,
                        textStyle: AppTypography.bodyMedium,
                      ),
                    ),
                  if (a.highlights.isNotEmpty)
                    DetailSection(
                      title: 'highlights'.tr,
                      child: BulletList(
                        items: a.highlights,
                        hugeIcon: HugeIcons.strokeRoundedStar,
                        iconColor: AppTheme.gold,
                      ),
                    ),
                  if (a.includes.isNotEmpty)
                    DetailSection(
                      title: 'includes'.tr,
                      child: BulletList(
                        items: a.includes,
                        hugeIcon: HugeIcons.strokeRoundedCheckmarkCircle02,
                        iconColor: AppTheme.success,
                      ),
                    ),
                  if (a.excludes.isNotEmpty)
                    DetailSection(
                      title: 'excludes'.tr,
                      child: BulletList(
                        items: a.excludes,
                        hugeIcon: HugeIcons.strokeRoundedCancel01,
                        iconColor: AppTheme.error,
                      ),
                    ),
                  if (a.plan.isNotEmpty)
                    DetailSection(
                      title: 'plan'.tr,
                      child: DetailFaqList(
                        items: a.plan
                            .map((p) => (title: p.title, content: p.content))
                            .toList(),
                      ),
                    ),
                  if (a.faqs.isNotEmpty)
                    DetailSection(
                      title: 'faqs'.tr,
                      child: DetailFaqList(
                        items: a.faqs
                            .map((f) => (title: f.title, content: f.content))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  border: Border(
                    top: BorderSide(color: AppTheme.border, width: 0.5),
                  ),
                ),
                child: BookNowBar(
                  price: a.price,
                  priceLabel: 'price_per_person'.tr,
                  onPressed: () => Get.toNamed(
                    bookingCreateRoute,
                    arguments: {
                      'product_type': 'activities',
                      'product_id': a.id,
                      'product_title': a.title,
                      'unit_price': a.price,
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
