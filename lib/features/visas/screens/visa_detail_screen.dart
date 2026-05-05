import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/product_detail_widgets.dart';
import 'package:traveler_app/features/visas/controller/visas_controller.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class VisaDetailScreen extends StatelessWidget {
  const VisaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VisaDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final v = c.visa.value;
        if (v == null) return DetailErrorView(onRetry: c.fetch);
        return CustomScrollView(
          slivers: [
            ProductHeroSliver(imageUrl: v.bannerUrl ?? v.imageUrl),
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
                        if (v.category != null) DetailBadge(text: v.category!),
                        if (v.visaMode != null)
                          DetailBadge(
                            text: v.visaMode!,
                            color: AppTheme.success,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(v.title, style: AppTypography.h2),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: AppTheme.textTertiary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          v.country,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DetailSection(
                title: 'visa_info'.tr,
                child: Column(
                  children: [
                    if (v.validity != null)
                      _InfoRow(
                        label: 'visa_validity'.tr,
                        value: v.validity!,
                      ),
                    if (v.processing != null)
                      _InfoRow(
                        label: 'visa_processing'.tr,
                        value: v.processing!,
                      ),
                    if (v.maximumStay != null)
                      _InfoRow(
                        label: 'visa_max_stay'.tr,
                        value: v.maximumStay!,
                      ),
                    if (v.visaMode != null)
                      _InfoRow(
                        label: 'visa_mode_label'.tr,
                        value: v.visaMode!,
                      ),
                  ],
                ),
              ),
            ),
            if (v.includes.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'includes'.tr,
                  child: BulletList(
                    items: v.includes,
                    hugeIcon: HugeIcons.strokeRoundedCheckmarkCircle02,
                    iconColor: AppTheme.success,
                  ),
                ),
              ),
            if (v.faqs.isNotEmpty)
              SliverToBoxAdapter(
                child: DetailSection(
                  title: 'faqs'.tr,
                  child: DetailFaqList(
                    items: v.faqs
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
        final v = c.visa.value;
        if (v == null) return const SizedBox.shrink();
        return BookNowBar(
          price: v.cost,
          priceLabel: 'visa_cost'.tr,
          buttonLabel: 'apply_now'.tr,
          onPressed: () => Get.toNamed(
            bookingCreateRoute,
            arguments: {
              'product_type': 'visa',
              'product_id': v.id,
              'product_title': v.title,
              'unit_price': v.cost,
            },
          ),
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
