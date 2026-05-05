import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/base/sky_background.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// A flat hero header used at the top of detail screens. Shows the product
/// image with a soft sky background underneath and a back/menu pair.
class ProductHero extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onMenu;
  final double height;

  const ProductHero({
    super.key,
    required this.imageUrl,
    this.title = '',
    this.onMenu,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          const Positioned.fill(child: SkyBackground(coverFull: true)),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: AppCachedImage(imageUrl: imageUrl, fit: BoxFit.contain),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: HugeIcons.strokeRoundedArrowLeft01,
                    onTap: () => Get.back(),
                  ),
                  if (title.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: AppTypography.h4.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  _CircleIconButton(
                    icon: HugeIcons.strokeRoundedMoreVerticalCircle01,
                    onTap: onMenu ?? () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      shape: const CircleBorder(
        side: BorderSide(color: AppTheme.cardBorder, width: 1),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: HugeIcon(icon: icon, color: AppTheme.textPrimary, size: 18),
        ),
      ),
    );
  }
}

/// Title + heart card underneath the hero (matches Mountain Climbing layout).
class ProductTitleCard extends StatelessWidget {
  final String title;
  final String? location;
  final bool isFavourite;
  final VoidCallback? onFavourite;

  const ProductTitleCard({
    super.key,
    required this.title,
    this.location,
    this.isFavourite = false,
    this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                ),
                if (location != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedLocation01,
                        color: AppTheme.textTertiary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isFavourite
                  ? AppTheme.error.withValues(alpha: 0.1)
                  : AppTheme.background,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: onFavourite,
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedFavourite,
                color: isFavourite ? AppTheme.error : AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats row (Total Distance, Weather, Sunset). Each cell is independently
/// optional; pass nulls to skip.
class ProductStatsRow extends StatelessWidget {
  final List<({String label, String value})> stats;

  const ProductStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 32, color: AppTheme.cardBorder),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats[i].label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats[i].value,
                    style: AppTypography.h4.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DetailBadge extends StatelessWidget {
  final String text;
  final Color? color;
  const DetailBadge({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: c,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final Widget? trailing;

  const DetailSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color iconColor;
  final List<List<dynamic>>? hugeIcon;

  const BulletList({
    super.key,
    required this.items,
    this.icon = Icons.check_circle_outline,
    this.iconColor = AppTheme.success,
    this.hugeIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        'no_data'.tr,
        style: AppTypography.bodyMedium.copyWith(color: AppTheme.textTertiary),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final it in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hugeIcon != null)
                  HugeIcon(icon: hugeIcon!, color: iconColor, size: 18)
                else
                  Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Expanded(child: Text(it, style: AppTypography.bodyMedium)),
              ],
            ),
          ),
      ],
    );
  }
}

class DetailFaqList extends StatelessWidget {
  final List<({String title, String content})> items;
  const DetailFaqList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final f in items)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radius16),
              border: Border.all(color: AppTheme.cardBorder, width: 1),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: const Border(),
                tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                title: Text(
                  f.title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        f.content,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class DetailRatingPill extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  const DetailRatingPill({
    super.key,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: AppTheme.gold,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewsCount ${'reviews'.tr})',
          style: AppTypography.bodySmall.copyWith(color: AppTheme.textTertiary),
        ),
      ],
    );
  }
}

/// Bottom CTA bar — pill-shaped, full-width or side-by-side with price.
class StartJourneyBar extends StatelessWidget {
  final double? price;
  final String? priceLabel;
  final String buttonLabel;
  final VoidCallback onPressed;

  const StartJourneyBar({
    super.key,
    required this.onPressed,
    this.price,
    this.priceLabel,
    this.buttonLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: price == null
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    buttonLabel.isEmpty ? 'start_journey'.tr : buttonLabel,
                  ),
                ),
              )
            : Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (priceLabel != null)
                        Text(
                          priceLabel!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      MoneyWithIcon(
                        money: price!,
                        precision: 0,
                        textSize: 20,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onPressed,
                    child: Text(
                      buttonLabel.isEmpty ? 'start_journey'.tr : buttonLabel,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class DetailErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const DetailErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlert02,
            color: AppTheme.textTertiary,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text('failed_to_load'.tr, style: AppTypography.bodyMedium),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text('retry'.tr)),
        ],
      ),
    );
  }
}

/// Compact horizontal gallery used in detail screens.
class DetailGalleryStrip extends StatelessWidget {
  final List<String> images;
  final VoidCallback? onSeeAll;
  const DetailGalleryStrip({super.key, required this.images, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    return DetailSection(
      title: 'gallery'.tr,
      trailing: onSeeAll == null
          ? null
          : GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'see_all'.tr,
                style: AppTypography.labelMedium.copyWith(
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      child: SizedBox(
        height: 78,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) => ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius16),
            child: AppCachedImage(
              imageUrl: images[i],
              width: 78,
              height: 78,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

/// Backwards-compatible alias used by older code paths.
class ProductHeroSliver extends StatelessWidget {
  final String imageUrl;
  final List<Widget>? actions;
  final double height;

  const ProductHeroSliver({
    super.key,
    required this.imageUrl,
    this.actions,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ProductHero(imageUrl: imageUrl, height: height),
    );
  }
}

/// Backwards-compatible alias.
class BookNowBar extends StatelessWidget {
  final double price;
  final String? priceLabel;
  final String buttonLabel;
  final VoidCallback onPressed;
  const BookNowBar({
    super.key,
    required this.price,
    required this.onPressed,
    this.priceLabel,
    this.buttonLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return StartJourneyBar(
      price: price,
      priceLabel: priceLabel,
      buttonLabel: buttonLabel.isEmpty ? 'book_now'.tr : buttonLabel,
      onPressed: onPressed,
    );
  }
}
