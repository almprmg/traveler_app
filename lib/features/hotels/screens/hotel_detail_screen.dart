import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/hotels/controller/hotel_detail_controller.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:traveler_app/widgets/product_detail_layout.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HotelDetailController>();
    return Obx(() {
      if (c.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final hotel = c.hotel.value;
      if (hotel == null) {
        return Scaffold(body: ProductDetailErrorState(onRetry: c.fetch));
      }
      return ProductDetailLayout(
        imageUrl: hotel.imageUrl,
        shareTitle: hotel.name,
        shareUrl: '${AppConstants.baseUrl}/hotels/${hotel.slug}',
        bottomBar: _BookingBar(hotel: hotel),
        child: _HotelContent(hotel: hotel),
      );
    });
  }
}

class _HotelContent extends StatelessWidget {
  final HotelDetail hotel;
  const _HotelContent({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final location = [hotel.address, hotel.location, hotel.country]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleRow(
          title: hotel.name,
          trailing: _PriceLabel(
            price: hotel.pricePerNight,
            suffix: '/${'night'.tr}',
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        ProductDetailSubtitle(location),
        if (hotel.gallery.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailGallery(images: hotel.gallery),
        ],
        if (hotel.policies.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing24),
          ProductDetailSectionHeader('property_details'.tr),
          const SizedBox(height: AppTheme.spacing12),
          ProductDetailChips(
            labels: hotel.policies.take(6).map((p) => p.title).toList(),
          ),
        ],
        if (hotel.description.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ProductDetailExpandableDescription(html: hotel.description),
        ],
        const SizedBox(height: AppTheme.spacing24),
        ProductDetailSectionHeader('rating_and_reviews'.tr),
        const SizedBox(height: AppTheme.spacing8),
        ProductDetailRatingSummary(
          rating: hotel.rating,
          reviewsCount: hotel.reviewsCount,
        ),
        if (hotel.reviews.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacing16),
          ...hotel.reviews.take(3).map((r) => ProductDetailReviewCard(
                userName: r.userName,
                rating: r.rating,
                comment: r.comment,
              )),
        ],
      ],
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final double price;
  final String suffix;
  const _PriceLabel({required this.price, required this.suffix});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        MoneyWithIcon(
          money: price,
          precision: 0,
          textSize: 18,
          color: AppTheme.textPrimary,
          fontWeight: AppTypography.extraBold,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            suffix,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ),
      ],
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
