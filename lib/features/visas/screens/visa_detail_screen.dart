import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/visas/controller/visas_controller.dart';
import 'package:traveler_app/features/visas/model/visa_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_detail_layout.dart';

class VisaDetailScreen extends StatelessWidget {
  const VisaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VisaDetailController>();
    return Obx(() {
      if (c.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final v = c.visa.value;
      if (v == null) {
        return Scaffold(body: ProductDetailErrorState(onRetry: c.fetch));
      }
      return ProductDetailLayout(
        imageUrl: v.bannerUrl ?? v.imageUrl,
        shareTitle: v.title,
        shareUrl: '${AppConstants.baseUrl}/visas/${v.slug}',
        bottomBar: ProductDetailBookingBar(
          priceLabel: 'visa_cost'.tr,
          price: v.cost,
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
        ),
        child: _VisaContent(visa: v),
      );
    });
  }
}

class _VisaContent extends StatelessWidget {
  final VisaDetail visa;
  const _VisaContent({required this.visa});

  @override
  Widget build(BuildContext context) {
    final chips = <String>[
      if (visa.category != null) visa.category!,
      if (visa.visaMode != null) visa.visaMode!,
    ];
    final infoRows = <(String, String)>[
      if (visa.validity != null) ('visa_validity'.tr, visa.validity!),
      if (visa.processing != null) ('visa_processing'.tr, visa.processing!),
      if (visa.maximumStay != null) ('visa_max_stay'.tr, visa.maximumStay!),
      if (visa.visaMode != null) ('visa_mode_label'.tr, visa.visaMode!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleRow(
          title: visa.title,
          trailing: MoneyWithIcon(
            money: visa.cost,
            precision: 0,
            textSize: 18,
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        ProductDetailSubtitle(visa.country),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailChips(labels: chips),
        ],
        if (infoRows.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('visa_info'.tr),
          const SizedBox(height: AppTheme.spacing12),
          for (final row in infoRows)
            _InfoRow(label: row.$1, value: row.$2),
        ],
        if (visa.includes.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('includes'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailBulletList(
            items: visa.includes,
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            iconColor: AppTheme.success,
          ),
        ],
        if (visa.faqs.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('faqs'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ...visa.faqs.map((f) => ProductDetailFaqItem(
                title: f.title,
                content: f.content,
              )),
        ],
      ],
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
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }
}
