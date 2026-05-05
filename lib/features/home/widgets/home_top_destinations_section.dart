import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_section_header.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomeTopDestinationsSection extends StatelessWidget {
  final List<Destination> destinations;
  const HomeTopDestinationsSection({super.key, required this.destinations});

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
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: destinations.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final d = destinations[i];
              return GestureDetector(
                onTap: () => Get.toNamed(
                  destinationDetailRoute,
                  arguments: {'slug': d.slug, 'destination_name': d.name},
                ),
                child: SizedBox(
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radius20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppCachedImage(imageUrl: d.imageUrl, fit: BoxFit.cover),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00000000), Color(0xB3000000)],
                              stops: [0.45, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Text(
                            d.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
