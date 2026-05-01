import 'package:flutter/material.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeToursSection extends StatelessWidget {
  final List<Tour> tours;

  const HomeToursSection({super.key, required this.tours});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tours.length,
        itemBuilder: (_, i) {
          final t = tours[i];
          return Container(
            width: 160,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppTheme.lightShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedImage(
                  imageUrl: t.imageUrl,
                  height: 110,
                  width: double.infinity,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MoneyWithIcon(
                            money: t.price,
                            precision: 0,
                            textSize: 12,
                            color: AppTheme.primary,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 12, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                t.rating.toString(),
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
