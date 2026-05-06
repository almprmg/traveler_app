import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/activities/controller/activities_controller.dart';
import 'package:traveler_app/features/activities/model/activity_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_detail_layout.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ActivityDetailController>();
    return Obx(() {
      if (c.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final a = c.activity.value;
      if (a == null) {
        return Scaffold(body: ProductDetailErrorState(onRetry: c.fetch));
      }
      return ProductDetailLayout(
        imageUrl: a.imageUrl,
        shareTitle: a.title,
        shareUrl: '${AppConstants.baseUrl}/activities/${a.slug}',
        bottomBar: ProductDetailBookingBar(
          priceLabel: 'price_per_person'.tr,
          price: a.price,
          buttonLabel: 'book_now'.tr,
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
        child: _ActivityContent(activity: a),
      );
    });
  }
}

class _ActivityContent extends StatelessWidget {
  final ActivityDetail activity;
  const _ActivityContent({required this.activity});

  @override
  Widget build(BuildContext context) {
    final subtitle = [activity.location, activity.country]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    final chips = <String>[
      if (activity.duration != null) activity.duration!,
      if (activity.country != null) activity.country!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleRow(
          title: activity.title,
          trailing: MoneyWithIcon(
            money: activity.price,
            precision: 0,
            textSize: 18,
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        ProductDetailSubtitle(subtitle),
        if (activity.gallery.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailGallery(images: activity.gallery),
        ],
        if (chips.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('property_details'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailChips(labels: chips),
        ],
        if (activity.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailExpandableDescription(html: activity.description),
        ],
        if (activity.highlights.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('highlights'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: activity.highlights,
            icon: HugeIcons.strokeRoundedStar,
            iconColor: AppTheme.gold,
          ),
        ],
        if (activity.includes.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailSectionHeader('includes'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: activity.includes,
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            iconColor: AppTheme.success,
          ),
        ],
        if (activity.excludes.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailSectionHeader('excludes'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: activity.excludes,
            icon: HugeIcons.strokeRoundedCancel01,
            iconColor: AppTheme.error,
          ),
        ],
        if (activity.plan.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('plan'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...activity.plan.map((p) => ProductDetailFaqItem(
                title: p.title,
                content: p.content,
              )),
        ],
        if (activity.faqs.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailSectionHeader('faqs'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...activity.faqs.map((f) => ProductDetailFaqItem(
                title: f.title,
                content: f.content,
              )),
        ],
        const SizedBox(height: AppTheme.spacing24),
        ProductDetailSectionHeader('rating_and_reviews'.tr),
        const SizedBox(height: AppTheme.spacing8),
        ProductDetailRatingSummary(
          rating: activity.rating,
          reviewsCount: activity.reviewsCount,
        ),
        if (activity.reviews.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ...activity.reviews.take(3).map((r) => ProductDetailReviewCard(
                userName: r.userName,
                rating: r.rating,
                comment: r.comment,
              )),
        ],
      ],
    );
  }
}
