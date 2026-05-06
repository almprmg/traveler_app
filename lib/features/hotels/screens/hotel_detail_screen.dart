import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/hotels/controller/hotel_detail_controller.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key});

  static const double _heroHeight = 360;
  static const double _cardOverlap = 32;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HotelDetailController>();
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final hotel = c.hotel.value;
        if (hotel == null) {
          return _ErrorState(onRetry: c.fetch);
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _heroHeight,
              child: AppCachedImage(
                imageUrl: hotel.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  children: [
                    SizedBox(height: _heroHeight - _cardOverlap),
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
                      child: _DetailContent(hotel: hotel),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: _heroHeight - 18,
              left: 0,
              right: 0,
              child: const Center(child: _ImageHandle()),
            ),
            Positioned(
              top: topInset + AppTheme.spacing8,
              left: AppTheme.spacing16,
              right: AppTheme.spacing16,
              child: _TopBar(hotel: hotel),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final hotel = c.hotel.value;
        if (c.isLoading.value || hotel == null) {
          return const SizedBox.shrink();
        }
        return _BookingBar(hotel: hotel);
      }),
    );
  }
}

class _TopBar extends StatelessWidget {
  final HotelDetail hotel;
  const _TopBar({required this.hotel});

  Future<void> _share() async {
    final url = '${AppConstants.baseUrl}/hotels/${hotel.slug}';
    final message =
        '${hotel.name}\n\n$url\n\n${'download_app'.tr}: ${AppConstants.baseUrl}';
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

class _DetailContent extends StatelessWidget {
  final HotelDetail hotel;
  const _DetailContent({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitlePriceRow(hotel: hotel),
        const SizedBox(height: AppTheme.spacing4),
        _LocationRow(hotel: hotel),
        if (hotel.gallery.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          _Gallery(gallery: hotel.gallery),
        ],
        if (hotel.policies.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          _SectionHeader(title: 'property_details'.tr),
          const SizedBox(height: AppTheme.spacing12),
          _PropertyChips(policies: hotel.policies),
        ],
        if (hotel.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          _ExpandableDescription(html: hotel.description),
        ],
        const SizedBox(height: AppTheme.spacing24),
        _SectionHeader(title: 'rating_and_reviews'.tr),
        const SizedBox(height: AppTheme.spacing8),
        _RatingSummary(
          rating: hotel.rating,
          reviewsCount: hotel.reviewsCount,
        ),
        if (hotel.reviews.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ...hotel.reviews.take(3).map((r) => _ReviewCard(review: r)),
        ],
      ],
    );
  }
}

class _TitlePriceRow extends StatelessWidget {
  final HotelDetail hotel;
  const _TitlePriceRow({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            hotel.name,
            style: AppTypography.h2.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyWithIcon(
                money: hotel.pricePerNight,
                precision: 0,
                textSize: 18,
                color: AppTheme.textPrimary,
                fontWeight: AppTypography.extraBold,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  '/${'night'.tr}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppTheme.textTertiary,
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

class _LocationRow extends StatelessWidget {
  final HotelDetail hotel;
  const _LocationRow({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final parts = [hotel.address, hotel.location, hotel.country]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(
      parts,
      style: AppTypography.bodySmall.copyWith(color: AppTheme.textTertiary),
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> gallery;
  const _Gallery({required this.gallery});

  static const int _visibleCount = 4;
  static const double _size = 76;

  @override
  Widget build(BuildContext context) {
    final visible = gallery.take(_visibleCount).toList();
    final more = gallery.length - _visibleCount;
    return SizedBox(
      height: _size,
      child: Row(
        children: [
          for (int i = 0; i < visible.length; i++) ...[
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

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

class _PropertyChips extends StatelessWidget {
  final List<HotelPolicy> policies;
  const _PropertyChips({required this.policies});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: [
        for (final p in policies.take(6))
          _Chip(label: p.title),
      ],
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

class _ExpandableDescription extends StatefulWidget {
  final String html;
  const _ExpandableDescription({required this.html});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _expanded ? double.infinity : 72,
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

class _RatingSummary extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  const _RatingSummary({required this.rating, required this.reviewsCount});

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

class _ReviewCard extends StatelessWidget {
  final HotelReview review;
  const _ReviewCard({required this.review});

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
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppTheme.primary,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Text(
                  review.userName,
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
                review.rating.toStringAsFixed(1),
                style: AppTypography.labelSmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            review.comment,
            style: AppTypography.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  final HotelDetail hotel;
  const _BookingBar({required this.hotel});

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
                'price_per_night'.tr,
                style: AppTypography.labelSmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
              MoneyWithIcon(
                money: hotel.pricePerNight,
                precision: 0,
                textSize: 20,
                color: AppTheme.textPrimary,
                fontWeight: AppTypography.extraBold,
              ),
            ],
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.toNamed(
                bookingCreateRoute,
                arguments: {
                  'product_type': 'hotel',
                  'product_id': hotel.id,
                  'product_title': hotel.name,
                  'unit_price': hotel.pricePerNight,
                },
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text('book_now'.tr),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

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
