import 'package:flutter/material.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeSectionLabel extends StatelessWidget {
  final String label;

  const HomeSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
