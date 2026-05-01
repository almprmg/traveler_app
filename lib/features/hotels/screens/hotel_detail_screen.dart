import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/hotels/controller/hotel_detail_controller.dart';
import 'package:traveler_app/features/hotels/model/hotel_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HotelDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final hotel = c.hotel.value;
        if (hotel == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text('failed_to_load'.tr),
                TextButton(onPressed: c.fetch, child: Text('retry'.tr)),
              ],
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            _buildAppBar(hotel),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLocationRow(hotel),
                    const SizedBox(height: 10),
                    _buildRatingRow(hotel),
                    if (hotel.gallery.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildGallery(hotel.gallery),
                    ],
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text('description'.tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    HtmlWidget(
                      hotel.description,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.6),
                    ),
                    if (hotel.policies.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('policies'.tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      ...hotel.policies.map((p) => _PolicyTile(policy: p)),
                    ],
                    if (hotel.reviews.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text('reviews'.tr,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      ...hotel.reviews.map((r) => _ReviewCard(review: r)),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (c.isLoading.value || c.hotel.value == null) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            boxShadow: AppTheme.mediumShadow,
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('price_per_night'.tr,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  MoneyWithIcon(
                    money: c.hotel.value!.pricePerNight,
                    precision: 0,
                    textSize: 20,
                    color: AppTheme.primary,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  child: Text('book_now'.tr),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  SliverAppBar _buildAppBar(HotelDetail hotel) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: AppCachedImage(
          imageUrl: hotel.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLocationRow(HotelDetail hotel) {
    final parts = [hotel.address, hotel.location, hotel.country]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    if (parts.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            parts,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(HotelDetail hotel) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppTheme.gold),
        const SizedBox(width: 4),
        Text(
          '${hotel.rating.toStringAsFixed(1)} (${hotel.reviewsCount})',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildGallery(List<String> gallery) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: gallery.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius8),
          child: AppCachedImage(
            imageUrl: gallery[i],
            width: 120,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final HotelPolicy policy;
  const _PolicyTile({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(policy.title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(policy.content,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final HotelReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryWithOpacity,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(review.userName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 14, color: AppTheme.gold),
                  const SizedBox(width: 2),
                  Text(review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
