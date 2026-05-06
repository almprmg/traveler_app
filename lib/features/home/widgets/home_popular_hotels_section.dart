import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_hotel_card.dart';
import 'package:traveler_app/features/home/widgets/home_section_header.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomePopularHotelsSection extends StatelessWidget {
  final List<Hotel> hotels;
  const HomePopularHotelsSection({super.key, required this.hotels});

  static const double _listHeight = 230;

  @override
  Widget build(BuildContext context) {
    if (hotels.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'popular_hotels'.tr,
          onSeeAll: () => Get.toNamed(hotelsRoute),
        ),
        SizedBox(
          height: _listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            itemCount: hotels.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppTheme.spacing12),
            itemBuilder: (_, i) => HomeHotelCard(hotel: hotels[i]),
          ),
        ),
      ],
    );
  }
}
