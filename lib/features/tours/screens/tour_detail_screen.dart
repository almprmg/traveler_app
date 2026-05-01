import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/tours/controller/tour_detail_controller.dart';
import 'package:traveler_app/features/tours/model/tour_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class TourDetailScreen extends StatelessWidget {
  const TourDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TourDetailController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final tour = c.tour.value;
        if (tour == null) {
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
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: AppCachedImage(
                  imageUrl: tour.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tour.categoryName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryWithOpacity,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radius4),
                        ),
                        child: Text(
                          tour.categoryName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      tour.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 18, color: AppTheme.gold),
                            const SizedBox(width: 4),
                            Text(
                              '${tour.rating.toStringAsFixed(1)} (${tour.reviewsCount})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (tour.duration != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_outlined,
                                  size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${tour.duration} ${'days'.tr}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        if (tour.location != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                tour.location!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        if (tour.destination != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flag_outlined,
                                  size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                tour.destination!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (tour.gallery.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildGallery(tour.gallery),
                    ],
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),
                    _sectionTitle('description'.tr),
                    const SizedBox(height: 8),
                    HtmlWidget(
                      tour.description,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.6),
                    ),
                    if (tour.includes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _sectionTitle('includes'.tr),
                      const SizedBox(height: 8),
                      ...tour.includes.map(
                        (item) => _bulletRow(
                          item,
                          Icons.check_circle_outline,
                          AppTheme.success,
                        ),
                      ),
                    ],
                    if (tour.excludes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle('excludes'.tr),
                      const SizedBox(height: 8),
                      ...tour.excludes.map(
                        (item) => _bulletRow(
                          item,
                          Icons.cancel_outlined,
                          AppTheme.error,
                        ),
                      ),
                    ],
                    if (tour.itinerary.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('itinerary'.tr),
                      const SizedBox(height: 12),
                      ...tour.itinerary.asMap().entries.map(
                            (e) => _ItineraryTile(
                              day: e.key + 1,
                              item: e.value,
                            ),
                          ),
                    ],
                    if (tour.faqs.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('faqs'.tr),
                      const SizedBox(height: 12),
                      ...tour.faqs.map((f) => _FaqTile(faq: f)),
                    ],
                    if (tour.reviews.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('reviews'.tr),
                      const SizedBox(height: 12),
                      ...tour.reviews.map((r) => _ReviewCard(review: r)),
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
        if (c.isLoading.value || c.tour.value == null) {
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
                  Text('price_per_person'.tr,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  MoneyWithIcon(
                    money: c.tour.value!.price,
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
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text('book_now'.tr),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      );

  Widget _bulletRow(String text, IconData icon, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text, style: const TextStyle(fontSize: 14))),
          ],
        ),
      );

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

class _ItineraryTile extends StatelessWidget {
  final int day;
  final TourItineraryItem item;
  const _ItineraryTile({required this.day, required this.item});

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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryWithOpacity,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                if (item.content.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.content,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final TourFaq faq;
  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(widget.faq.title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          childrenPadding:
              const EdgeInsets.fromLTRB(14, 0, 14, 12),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          trailing: Icon(
            _expanded ? Icons.remove : Icons.add,
            size: 18,
            color: AppTheme.primary,
          ),
          children: [
            Text(widget.faq.content,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final TourReview review;
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
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName
                      : 'anonymous'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 14, color: AppTheme.gold),
                  const SizedBox(width: 2),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
                fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            review.createdAt,
            style: const TextStyle(
                fontSize: 11, color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }
}
