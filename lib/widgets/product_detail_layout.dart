import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Shared chrome for product detail screens (hotel/tour/activity/visa/etc.).
///
/// Renders:
///  • a 360px hero image at the top of the [Stack]
///  • glass back/share circle buttons floating over the image (back uses
///    chevron + RTL-aware)
///  • a small white handle pill at the bottom of the image
///  • a scrollable white card with rounded top corners that overlaps the image
///  • optional [bottomBar] sticky at the bottom of the screen.
class ProductDetailLayout extends StatelessWidget {
  final String imageUrl;
  final String shareTitle;
  final String shareUrl;
  final Widget child;
  final Widget? bottomBar;
  final double heroHeight;
  final double cardOverlap;

  const ProductDetailLayout({
    super.key,
    required this.imageUrl,
    required this.shareTitle,
    required this.shareUrl,
    required this.child,
    this.bottomBar,
    this.heroHeight = 360,
    this.cardOverlap = 32,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomBar == null ? 24 : 120),
              child: Column(
                children: [
                  SizedBox(height: heroHeight - cardOverlap),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radius24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacing20,
                      AppTheme.spacing24,
                      AppTheme.spacing20,
                      AppTheme.spacing20,
                    ),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: heroHeight - 18,
            left: 0,
            right: 0,
            child: const Center(child: _ImageHandle()),
          ),
          Positioned(
            top: topInset + AppTheme.spacing8,
            left: AppTheme.spacing16,
            right: AppTheme.spacing16,
            child: _TopBar(
              shareTitle: shareTitle,
              shareUrl: shareUrl,
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

class _TopBar extends StatelessWidget {
  final String shareTitle;
  final String shareUrl;
  const _TopBar({required this.shareTitle, required this.shareUrl});

  Future<void> _share() async {
    final message =
        '$shareTitle\n\n$shareUrl\n\n${'download_app'.tr}: ${AppConstants.baseUrl}';
    await Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    return Row(
      children: [
        _GlassCircleButton(
          icon: isLtr
              ? HugeIcons.strokeRoundedArrowLeft02
              : HugeIcons.strokeRoundedArrowRight02,
          onTap: () => Get.back(),
        ),
        const Spacer(),
        _GlassCircleButton(
          icon: HugeIcons.strokeRoundedShare08,
          onTap: _share,
        ),
      ],
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  const _GlassCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: AppTheme.white.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.white.withValues(alpha: 0.7),
                  width: 1,
                ),
              ),
              child: HugeIcon(
                icon: icon,
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageHandle extends StatelessWidget {
  const _ImageHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ---------------- Reusable detail content sections ----------------

/// Section header — bold title used above each detail section.
class ProductDetailSectionHeader extends StatelessWidget {
  final String title;
  const ProductDetailSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h5.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: AppTypography.bold,
      ),
    );
  }
}

/// Title (left) + optional trailing widget like a price.
class ProductDetailTitleRow extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const ProductDetailTitleRow({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.h2.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppTheme.spacing12),
          Padding(padding: const EdgeInsets.only(top: 4), child: trailing!),
        ],
      ],
    );
  }
}

/// Subtle subtitle line (e.g., location/country).
class ProductDetailSubtitle extends StatelessWidget {
  final String text;
  const ProductDetailSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(color: AppTheme.textTertiary),
    );
  }
}

/// 4-thumbnail gallery, the last shows "+N more" overlay when there are
/// extra images.
class ProductDetailGallery extends StatelessWidget {
  final List<String> images;
  final int visibleCount;
  final double thumbHeight;

  const ProductDetailGallery({
    super.key,
    required this.images,
    this.visibleCount = 4,
    this.thumbHeight = 76,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    final visible = images.take(visibleCount).toList();
    final more = images.length - visibleCount;
    return SizedBox(
      height: thumbHeight,
      child: Row(
        children: [
          for (int i = 0; i < visible.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: i == visible.length - 1 ? 0 : AppTheme.spacing8,
                ),
                child: _GalleryThumb(
                  imageUrl: visible[i],
                  moreCount: i == visible.length - 1 && more > 0 ? more : 0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  final String imageUrl;
  final int moreCount;
  const _GalleryThumb({required this.imageUrl, required this.moreCount});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radius16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppCachedImage(imageUrl: imageUrl, fit: BoxFit.cover),
          if (moreCount > 0) ...[
            Container(color: AppTheme.textPrimary.withValues(alpha: 0.55)),
            Center(
              child: Text(
                '$moreCount ${'more'.tr}',
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  color: AppTheme.white,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Wrap of pill chips — used for property details, tags, includes, etc.
class ProductDetailChips extends StatelessWidget {
  final List<String> labels;
  const ProductDetailChips({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [for (final l in labels) _Chip(label: l)],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: AppTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: AppTypography.semiBold,
        ),
      ),
    );
  }
}

/// HTML description that collapses to ~3 lines with a "Read more" toggle.
class ProductDetailExpandableDescription extends StatefulWidget {
  final String html;
  final double collapsedHeight;
  const ProductDetailExpandableDescription({
    super.key,
    required this.html,
    this.collapsedHeight = 72,
  });

  @override
  State<ProductDetailExpandableDescription> createState() =>
      _ProductDetailExpandableDescriptionState();
}

class _ProductDetailExpandableDescriptionState
    extends State<ProductDetailExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.html.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _expanded ? double.infinity : widget.collapsedHeight,
            ),
            child: HtmlWidget(
              widget.html,
              textStyle: AppTypography.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'read_less'.tr : 'read_more'.tr,
            style: AppTypography.labelMedium.copyWith(
              color: AppTheme.primary,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Star + rating + reviews count line.
class ProductDetailRatingSummary extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  const ProductDetailRatingSummary({
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
        const SizedBox(width: AppTheme.spacing4),
        Text(
          rating.toStringAsFixed(2),
          style: AppTypography.h5.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(width: AppTheme.spacing8),
        Text(
          '• $reviewsCount ${'reviews'.tr}',
          style: AppTypography.bodySmall.copyWith(
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Single review card (avatar + name + star + comment).
class ProductDetailReviewCard extends StatelessWidget {
  final String userName;
  final double rating;
  final String comment;

  const ProductDetailReviewCard({
    super.key,
    required this.userName,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryWithOpacity,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppTheme.primary,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Text(
                  userName,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
              const HugeIcon(
                icon: HugeIcons.strokeRoundedStar,
                color: AppTheme.gold,
                size: 14,
              ),
              const SizedBox(width: AppTheme.spacing2),
              Text(
                rating.toStringAsFixed(1),
                style: AppTypography.labelSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            comment,
            style: AppTypography.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// FAQ-style expandable item — shows title, expands to reveal HTML content.
class ProductDetailFaqItem extends StatefulWidget {
  final String title;
  final String content;
  const ProductDetailFaqItem({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<ProductDetailFaqItem> createState() => _ProductDetailFaqItemState();
}

class _ProductDetailFaqItemState extends State<ProductDetailFaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ),
                    HugeIcon(
                      icon: _expanded
                          ? HugeIcons.strokeRoundedArrowUp01
                          : HugeIcons.strokeRoundedArrowDown01,
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: AppTheme.spacing8,
                          ),
                          child: HtmlWidget(
                            widget.content,
                            textStyle: AppTypography.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bullet list — checkmark/cancel/etc. icon + text item.
class ProductDetailBulletList extends StatelessWidget {
  final List<String> items;
  final List<List<dynamic>> icon;
  final Color iconColor;

  const ProductDetailBulletList({
    super.key,
    required this.items,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HugeIcon(icon: icon, color: iconColor, size: 18),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    item,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Standard bottom bar with a price label/value on the leading side and a
/// primary action button on the trailing side.
class ProductDetailBookingBar extends StatelessWidget {
  final String priceLabel;
  final double price;
  final String buttonLabel;
  final VoidCallback onPressed;

  const ProductDetailBookingBar({
    super.key,
    required this.priceLabel,
    required this.price,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing20,
        AppTheme.spacing12,
        AppTheme.spacing20,
        AppTheme.spacing24,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                priceLabel,
                style: AppTypography.labelSmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              _PriceText(price: price),
            ],
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceText extends StatelessWidget {
  final double price;
  const _PriceText({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      price.toStringAsFixed(0),
      style: AppTypography.h4.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: AppTypography.extraBold,
      ),
    );
  }
}

/// Detail screen error/loading state — shown when the controller fails to
/// load the entity.
class ProductDetailErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const ProductDetailErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedAlert02,
            size: 48,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text('failed_to_load'.tr),
          TextButton(onPressed: onRetry, child: Text('retry'.tr)),
        ],
      ),
    );
  }
}
