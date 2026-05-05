import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_recommended_card.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

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
        const _SectionHeader(),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing24,
        AppTheme.spacing8,
        AppTheme.spacing24,
        AppTheme.spacing12,
      ),
      child: Row(
        children: [
          Text(
            'recommended'.tr,
            style: AppTypography.h4.copyWith(fontWeight: AppTypography.bold),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed(toursRoute),
            child: Row(
              children: [
                Text(
                  'see_all'.tr,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppTheme.textTertiary,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing2),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppTheme.textTertiary,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
