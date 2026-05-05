import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

/// Stacked initial avatars + a pill showing how many travelled.
/// Initials are deterministically picked per [seed] so each card stays unique
/// across a list while remaining stable per item.
class HomeTravelledBadge extends StatelessWidget {
  final int count;
  final int seed;

  const HomeTravelledBadge({
    super.key,
    required this.count,
    required this.seed,
  });

  static const _avatarColors = <Color>[
    Color(0xFFF6B756),
    Color(0xFF7CC58A),
    Color(0xFFB28BE3),
  ];

  static const _enPool = <String>[
    'A', 'M', 'S', 'J', 'K', 'L', 'N', 'R', 'T', 'D', 'B', 'P', 'O', 'E', 'H',
  ];
  static const _arPool = <String>[
    'أ', 'م', 'س', 'ج', 'ك', 'ل', 'ن', 'ر', 'ت', 'د', 'ب', 'ف', 'ع', 'ه', 'ح',
  ];

  List<String> _pickInitials(List<String> pool, int n) {
    final r = Random(seed);
    final remaining = List<String>.of(pool);
    final picked = <String>[];
    for (var i = 0; i < n && remaining.isNotEmpty; i++) {
      picked.add(remaining.removeAt(r.nextInt(remaining.length)));
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode == 'ar';
    final initials = _pickInitials(
      isArabic ? _arPool : _enPool,
      _avatarColors.length,
    );
    final formatted = NumberFormat.decimalPattern(
      Get.locale?.toString(),
    ).format(count);

    return Row(
      children: [
        _AvatarStack(initials: initials, colors: _avatarColors),
        const SizedBox(width: AppTheme.spacing2),
        _TravelledPill(formatted: formatted),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final List<String> initials;
  final List<Color> colors;

  const _AvatarStack({required this.initials, required this.colors});

  static const double _diameter = 22;
  static const double _overlap = 14;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _overlap * (colors.length - 1) + _diameter,
      height: _diameter,
      child: Stack(
        children: [
          for (var i = 0; i < colors.length; i++)
            Positioned(
              left: i * _overlap,
              child: _AvatarCircle(
                color: colors[i],
                initial: initials[i],
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Color color;
  final String initial;

  const _AvatarCircle({required this.color, required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.white, width: 2),
      ),
      child: Text(
        initial,
        style: AppTypography.labelSmall.copyWith(
          color: AppTheme.white,
          fontWeight: AppTypography.extraBold,
          height: 1.0,
        ),
      ),
    );
  }
}

class _TravelledPill extends StatelessWidget {
  final String formatted;
  const _TravelledPill({required this.formatted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: Row(
        children: [
          Text(
            formatted,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.primary,
              fontSize: 9,
              fontWeight: AppTypography.extraBold,
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            'travelled'.tr,
            style: AppTypography.labelSmall.copyWith(
              color: AppTheme.primary,
              fontSize: 9,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }
}
