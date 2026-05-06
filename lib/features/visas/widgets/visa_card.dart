import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/visas/model/visa_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_details_button.dart';
import 'package:traveler_app/widgets/product_image_hero.dart';

class VisaCard extends StatelessWidget {
  final VisaListItem visa;
  final VoidCallback onTap;

  const VisaCard({super.key, required this.visa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius20),
          border: Border.all(color: AppTheme.cardBorder, width: 0.75),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius20 - 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ProductImageHero(
                imageUrl: visa.imageUrl,
                topEndOverlay: visa.category != null
                    ? ProductBadgePill(label: visa.category!)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing16,
                  0,
                  AppTheme.spacing16,
                  AppTheme.spacing16,
                ),
                child: _Body(visa: visa),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final VisaListItem visa;
  const _Body({required this.visa});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visa.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyLarge.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        _CountryRow(country: visa.country),
        if (visa.validity != null || visa.processing != null) ...[
          const SizedBox(height: AppTheme.spacing4),
          _MetaRow(visa: visa),
        ],
        const SizedBox(height: AppTheme.spacing12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: MoneyWithIcon(
                money: visa.cost,
                precision: 0,
                textSize: 16,
                color: AppTheme.textPrimary,
                fontWeight: AppTypography.extraBold,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            const ProductDetailsButton(),
          ],
        ),
      ],
    );
  }
}

class _CountryRow extends StatelessWidget {
  final String country;
  const _CountryRow({required this.country});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedLocation01,
          color: AppTheme.textTertiary,
          size: 12,
        ),
        const SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: Text(
            country,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final VisaListItem visa;
  const _MetaRow({required this.visa});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (visa.validity != null) '${'visa_validity'.tr}: ${visa.validity!}',
      if (visa.processing != null)
        '${'visa_processing'.tr}: ${visa.processing!}',
    ];
    return Text(
      parts.join('  •  '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.labelSmall.copyWith(color: AppTheme.textSecondary),
    );
  }
}
