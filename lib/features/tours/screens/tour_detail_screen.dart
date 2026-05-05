import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/tours/controller/tour_detail_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class TourDetailScreen extends StatelessWidget {
  const TourDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TourDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final tour = c.tour.value;
        if (tour == null) return DetailErrorView(onRetry: c.fetch);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProductHero(
                imageUrl: tour.imageUrl,
                title: 'summary'.tr,
              ),
            ),
            SliverToBoxAdapter(
              child: ProductTitleCard(
                title: tour.title,
                location: tour.location ?? tour.destination,
              ),
            ),
            SliverToBoxAdapter(
              child: ProductStatsRow(
                stats: [
                  if (tour.duration != null)
                    (label: 'duration'.tr, value: tour.duration!),
                  (
                    label: 'rating'.tr,
                    value: tour.rating.toStringAsFixed(1),
                  ),
                  (label: 'reviews'.tr, value: '${tour.reviewsCount}'),
                ],
              ),
            ),
            if (tour.description.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: HtmlWidget(
                    tour.description,
                    textStyle: AppTypography.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            if (tour.gallery.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailGalleryStrip(images: tour.gallery),
              ),
            if (tour.includes.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'includes'.tr,
                  child: BulletList(
                    items: tour.includes,
                    hugeIcon: HugeIcons.strokeRoundedCheckmarkCircle02,
                    iconColor: AppTheme.success,
                  ),
                ),
              ),
            if (tour.excludes.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'excludes'.tr,
                  child: BulletList(
                    items: tour.excludes,
                    hugeIcon: HugeIcons.strokeRoundedCancel01,
                    iconColor: AppTheme.error,
                  ),
                ),
              ),
            if (tour.itinerary.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'itinerary'.tr,
                  child: DetailFaqList(
                    items: tour.itinerary
                        .map((i) => (title: i.title, content: i.content))
                        .toList(),
                  ),
                ),
              ),
            if (tour.faqs.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'faqs'.tr,
                  child: DetailFaqList(
                    items: tour.faqs
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
        final tour = c.tour.value;
        if (tour == null) return const SizedBox.shrink();
        return StartJourneyBar(
          buttonLabel: 'start_journey'.tr,
          onPressed: () => Get.toNamed(
            bookingCreateRoute,
            arguments: {
              'product_type': 'tour',
              'product_id': tour.id,
              'product_title': tour.title,
              'unit_price': tour.price,
            },
          ),
        );
      }),
    );
  }
}
