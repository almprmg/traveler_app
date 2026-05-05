import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/transports/controller/transports_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class TransportDetailScreen extends StatelessWidget {
  const TransportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransportDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final t = c.transport.value;
        if (t == null) return DetailErrorView(onRetry: c.fetch);

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductHero(imageUrl: t.imageUrl),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (t.carType != null) DetailBadge(text: t.carType!),
                            if (t.distanceKm != null)
                              DetailBadge(
                                text: t.distanceKm!,
                                color: AppTheme.success,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(t.title, style: AppTypography.h2),
                        const SizedBox(height: 6),
                        if (t.location != null || t.address != null)
                          Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedLocation01,
                                color: AppTheme.textTertiary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  t.address ?? t.location ?? '',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        DetailRatingPill(
                          rating: t.rating,
                          reviewsCount: t.reviewsCount,
                        ),
                      ],
                    ),
                  ),
                  if (t.pricing.isNotEmpty)
                    DetailSection(
                      title: 'choose_transport_mode'.tr,
                      child: Obx(() {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: t.pricing.entries.map((e) {
                            final selected = c.selectedMode.value == e.key;
                            final price = e.value.salePrice ?? e.value.price;
                            return ChoiceChip(
                              label: Text(
                                '${e.key.toUpperCase()} - ${price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: selected
                                      ? AppTheme.white
                                      : AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              selected: selected,
                              selectedColor: AppTheme.primary,
                              backgroundColor: AppTheme.white,
                              onSelected: (_) => c.selectedMode.value = e.key,
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  if (t.description.isNotEmpty)
                    DetailSection(
                      title: 'description'.tr,
                      child: Text(
                        t.description,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                  if (t.faqs.isNotEmpty)
                    DetailSection(
                      title: 'faqs'.tr,
                      child: DetailFaqList(
                        items: t.faqs
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
              child: Obx(() {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.white,
                    border: Border(
                      top: BorderSide(color: AppTheme.border, width: 0.5),
                    ),
                  ),
                  child: BookNowBar(
                    price: c.currentPrice(),
                    priceLabel: 'starting_from'.tr,
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
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
