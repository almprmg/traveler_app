import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/transports/controller/transports_controller.dart';
import 'package:traveler_app/features/transports/model/transport_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_detail_layout.dart';

class TransportDetailScreen extends StatelessWidget {
  const TransportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransportDetailController>();
    return Obx(() {
      if (c.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final t = c.transport.value;
      if (t == null) {
        return Scaffold(body: ProductDetailErrorState(onRetry: c.fetch));
      }
      return ProductDetailLayout(
        imageUrl: t.imageUrl,
        shareTitle: t.title,
        shareUrl: '${AppConstants.baseUrl}/transports/${t.slug}',
        bottomBar: Obx(
          () => ProductDetailBookingBar(
            priceLabel: 'starting_from'.tr,
            price: c.currentPrice(),
            buttonLabel: 'book_now'.tr,
            onPressed: () => Get.toNamed(
              bookingCreateRoute,
              arguments: {
                'product_type': 'transports',
                'product_id': t.id,
                'product_title': t.title,
                'unit_price': c.currentPrice(),
                'transport_type': c.selectedMode.value,
              },
            ),
          ),
        ),
        child: _TransportContent(transport: t, controller: c),
      );
    });
  }
}

class _TransportContent extends StatelessWidget {
  final TransportDetail transport;
  final TransportDetailController controller;
  const _TransportContent({
    required this.transport,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [transport.address, transport.location, transport.country]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    final chips = <String>[
      if (transport.carType != null) transport.carType!,
      if (transport.distanceKm != null) transport.distanceKm!,
      if (transport.minStay != null) transport.minStay!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleRow(
          title: transport.title,
          trailing: Obx(
            () => MoneyWithIcon(
              money: controller.currentPrice(),
              precision: 0,
              textSize: 18,
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.extraBold,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        ProductDetailSubtitle(subtitle),
        if (transport.gallery.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailGallery(images: transport.gallery),
        ],
        if (chips.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('property_details'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailChips(labels: chips),
        ],
        if (transport.pricing.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('choose_transport_mode'.tr),
          const SizedBox(height: AppTheme.spacing12),
          _ModePicker(
            pricing: transport.pricing,
            controller: controller,
          ),
        ],
        if (transport.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailExpandableDescription(html: transport.description),
        ],
        if (transport.faqs.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('faqs'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...transport.faqs.map((f) => ProductDetailFaqItem(
                title: f.title,
                content: f.content,
              )),
        ],
        const SizedBox(height: AppTheme.spacing24),
        ProductDetailSectionHeader('rating_and_reviews'.tr),
        const SizedBox(height: AppTheme.spacing8),
        ProductDetailRatingSummary(
          rating: transport.rating,
          reviewsCount: transport.reviewsCount,
        ),
        if (transport.reviews.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ...transport.reviews.take(3).map((r) => ProductDetailReviewCard(
                userName: r.userName,
                rating: r.rating,
                comment: r.comment,
              )),
        ],
      ],
    );
  }
}

class _ModePicker extends StatelessWidget {
  final Map<String, TransportPrice> pricing;
  final TransportDetailController controller;

  const _ModePicker({required this.pricing, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: AppTheme.spacing8,
        runSpacing: AppTheme.spacing8,
        children: pricing.entries.map((e) {
          final selected = controller.selectedMode.value == e.key;
          final price = e.value.salePrice ?? e.value.price;
          return _ModeChip(
            label: '${e.key.toUpperCase()} • ${price.toStringAsFixed(0)}',
            selected: selected,
            onTap: () => controller.selectedMode.value = e.key,
          );
        }).toList(),
      );
    });
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primary : AppTheme.white,
      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.cardBorder,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: selected ? AppTheme.white : AppTheme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
      ),
    );
  }
}
