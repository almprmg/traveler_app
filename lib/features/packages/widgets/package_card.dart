import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/money_icon.dart';
import 'package:traveler_app/features/packages/model/package_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class PackageCard extends StatelessWidget {
  final PackageListItem pkg;
  final VoidCallback onTap;
  const PackageCard({super.key, required this.pkg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasSale = pkg.salePrice != null && pkg.salePrice! < pkg.price;
    final price = hasSale ? pkg.salePrice! : pkg.price;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radius16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radius16),
                  ),
                  child: AppCachedImage(
                    imageUrl: pkg.imageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                if (pkg.isFeatured)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.gold,
                        borderRadius: BorderRadius.circular(AppTheme.radius8),
                      ),
                      child: Text(
                        'featured'.tr,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (pkg.shortDesc != null)
                    Text(
                      pkg.shortDesc!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (pkg.duration != null) ...[
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedClock01,
                          size: 13,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          pkg.duration!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedStar,
                        size: 14,
                        color: AppTheme.gold,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        pkg.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (hasSale) ...[
                        Text(
                          pkg.price.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      MoneyWithIcon(
                        money: price,
                        precision: 0,
                        textSize: 15,
                        color: AppTheme.primary,
                      ),
                    ],
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
