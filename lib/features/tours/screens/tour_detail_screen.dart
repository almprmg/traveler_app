import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/tours/controller/tour_detail_controller.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_detail_layout.dart';

class TourDetailScreen extends StatelessWidget {
  const TourDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TourDetailController>();
    return Obx(() {
      if (c.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final tour = c.tour.value;
      if (tour == null) {
        return Scaffold(body: ProductDetailErrorState(onRetry: c.fetch));
      }
      return ProductDetailLayout(
        imageUrl: tour.imageUrl,
        shareTitle: tour.title,
        shareUrl: '${AppConstants.baseUrl}/tours/${tour.slug}',
        bottomBar: ProductDetailBookingBar(
          priceLabel: 'price_per_person'.tr,
          price: tour.price,
          buttonLabel: 'book_now'.tr,
          onPressed: () => Get.toNamed(
            bookingCreateRoute,
            arguments: {
              'product_type': 'tour',
              'product_id': tour.id,
              'product_title': tour.title,
              'unit_price': tour.price,
            },
          ),
        ),
        child: _TourContent(tour: tour),
      );
    });
  }
}

class _TourContent extends StatelessWidget {
  final TourDetail tour;
  const _TourContent({required this.tour});

  @override
  Widget build(BuildContext context) {
    final subtitle = [tour.location, tour.destination]
        .where((s) => s != null && s.isNotEmpty)
        .join(' • ');
    final chips = <String>[
      if (tour.duration != null) tour.duration!,
      if (tour.categoryName != null) tour.categoryName!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleRow(
          title: tour.title,
          trailing: MoneyWithIcon(
            money: tour.price,
            precision: 0,
            textSize: 18,
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        ProductDetailSubtitle(subtitle),
        if (tour.gallery.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailGallery(images: tour.gallery),
        ],
        if (chips.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('property_details'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailChips(labels: chips),
        ],
        if (tour.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailExpandableDescription(html: tour.description),
        ],
        if (tour.includes.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('includes'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: tour.includes,
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            iconColor: AppTheme.success,
          ),
        ],
        if (tour.excludes.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailSectionHeader('excludes'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: tour.excludes,
            icon: HugeIcons.strokeRoundedCancel01,
            iconColor: AppTheme.error,
          ),
        ],
        if (tour.itinerary.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('itinerary'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...tour.itinerary.map((i) => ProductDetailFaqItem(
                title: i.title,
                content: i.content,
              )),
        ],
        if (tour.faqs.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailSectionHeader('faqs'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...tour.faqs.map((f) => ProductDetailFaqItem(
                title: f.title,
                content: f.content,
              )),
        ],
        const SizedBox(height: AppTheme.spacing24),
        ProductDetailSectionHeader('rating_and_reviews'.tr),
        const SizedBox(height: AppTheme.spacing8),
        ProductDetailRatingSummary(
          rating: tour.rating,
          reviewsCount: tour.reviewsCount,
        ),
        if (tour.reviews.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ...tour.reviews.take(3).map((r) => ProductDetailReviewCard(
                userName: r.userName,
                rating: r.rating,
                comment: r.comment,
              )),
        ],
      ],
    );
  }
}
