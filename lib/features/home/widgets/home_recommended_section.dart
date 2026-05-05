import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_recommended_card.dart';
import 'package:traveler_app/features/home/widgets/home_section_header.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeRecommendedSection extends StatelessWidget {
  final List<Tour> tours;
  const HomeRecommendedSection({super.key, required this.tours});

  static const double _listHeight = 268;

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'recommended'.tr,
          onSeeAll: () => Get.toNamed(toursRoute),
        ),
        SizedBox(
          height: _listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            itemCount: tours.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppTheme.spacing12),
            itemBuilder: (_, i) => HomeRecommendedCard(tour: tours[i]),
          ),
        ),
      ],
    );
  }
}
