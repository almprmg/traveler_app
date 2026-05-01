import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/controller/home_controller.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/util/app_theme.dart';

class HomeBannerSection extends StatelessWidget {
  final List<HomeBanner> banners;
  final HomeController controller;

  const HomeBannerSection({
    super.key,
    required this.banners,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: banners.length,
              onPageChanged: (i) => controller.bannerIndex.value = i,
              itemBuilder: (_, i) {
                final banner = banners[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppCachedImage(
                        imageUrl: banner.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Text(
                          banner.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.bannerIndex.value == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.bannerIndex.value == i
                        ? AppTheme.primary
                        : AppTheme.borderMedium,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
