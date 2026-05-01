import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class SearchBoxWidget extends StatelessWidget {
  final VoidCallback onTap;
  final List<String> hints;
  final double height;

  const SearchBoxWidget({
    super.key,
    required this.onTap,
    this.hints = const [],
    this.height = 55.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeHints = hints.isNotEmpty ? hints : ['...'];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius12),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
          border: Border.all(color: AppTheme.borderMedium),
        ),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 20,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '${'search_for'.tr} ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Flexible(
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: activeHints
                          .map(
                            (hint) => FadeAnimatedText(
                              hint,
                              duration: const Duration(milliseconds: 4000),
                              fadeInEnd: 0.2,
                              fadeOutBegin: 0.8,
                              textStyle: AppTypography.bodyMedium.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
