import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/transports/model/transport_model.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_details_button.dart';
import 'package:traveler_app/widgets/product_image_hero.dart';

class TransportCard extends StatelessWidget {
  final TransportListItem transport;
  final VoidCallback onTap;

  const TransportCard({
    super.key,
    required this.transport,
    required this.onTap,
  });

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
                imageUrl: transport.imageUrl,
                height: 170,
                fadeHeight: 55,
                bottomEndOverlay: GhostRatingPill(rating: transport.rating),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing12,
                  0,
                  AppTheme.spacing12,
                  AppTheme.spacing12,
                ),
                child: _Body(transport: transport),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final TransportListItem transport;
  const _Body({required this.transport});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transport.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.extraBold,
            height: 1.25,
          ),
        ),
        if (transport.location != null) ...[
          const SizedBox(height: AppTheme.spacing2),
          _LocationRow(location: transport.location!),
        ],
        const SizedBox(height: AppTheme.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: MoneyWithIcon(
                money: transport.carPrice,
                precision: 0,
                textSize: 15,
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

class _LocationRow extends StatelessWidget {
  final String location;
  const _LocationRow({required this.location});

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
            location,
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
