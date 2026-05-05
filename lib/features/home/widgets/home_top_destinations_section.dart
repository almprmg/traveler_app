import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_destination_card.dart';
import 'package:traveler_app/features/home/widgets/home_section_header.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeTopDestinationsSection extends StatelessWidget {
  final List<Destination> destinations;
  const HomeTopDestinationsSection({super.key, required this.destinations});

  static const double _listHeight = 180;

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'top_destinations'.tr,
          onSeeAll: () => Get.toNamed(destinationsRoute),
        ),
        SizedBox(
          height: _listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            itemCount: destinations.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppTheme.spacing12),
            itemBuilder: (_, i) =>
                HomeDestinationCard(destination: destinations[i]),
          ),
        ),
      ],
    );
  }
}
