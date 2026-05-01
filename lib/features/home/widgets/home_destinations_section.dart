import 'package:flutter/material.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeDestinationsSection extends StatelessWidget {
  final List<Destination> destinations;

  const HomeDestinationsSection({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: destinations.length,
        itemBuilder: (_, i) {
          final d = destinations[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                AppCachedImage(
                  imageUrl: d.imageUrl,
                  width: 70,
                  height: 70,
                  borderRadius: BorderRadius.circular(50),
                ),
                const SizedBox(height: 6),
                Text(
                  d.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
