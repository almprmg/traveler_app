import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/features/home/model/home_model.dart';
import 'package:traveler_app/features/home/widgets/home_section_header.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class HomePromoSection extends StatefulWidget {
  final List<HomeBanner> banners;
  const HomePromoSection({super.key, required this.banners});

  @override
  State<HomePromoSection> createState() => _HomePromoSectionState();
}

class _HomePromoSectionState extends State<HomePromoSection> {
  final _controller = PageController(viewportFraction: 0.92);
  int _index = 0;

  static const double _bannerHeight = 160;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(title: 'special_offers'.tr),
        SizedBox(
          height: _bannerHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => _PromoCard(banner: widget.banners[i]),
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: AppTheme.spacing12),
          _PageIndicator(count: widget.banners.length, activeIndex: _index),
        ],
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final HomeBanner banner;
  const _PromoCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppCachedImage(imageUrl: banner.imageUrl, fit: BoxFit.cover),
            const _BannerOverlay(),
            if (banner.title.isNotEmpty) _BannerTitle(title: banner.title),
          ],
        ),
      ),
    );
  }
}

class _BannerOverlay extends StatelessWidget {
  const _BannerOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.primary.withValues(alpha: 0.8),
            AppTheme.primary.withValues(alpha: 0.2),
          ],
        ),
      ),
    );
  }
}

class _BannerTitle extends StatelessWidget {
  final String title;
  const _BannerTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.h3.copyWith(
              color: AppTheme.white,
              fontWeight: AppTypography.extraBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _PageIndicator({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => _IndicatorDot(active: i == activeIndex),
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  final bool active;
  const _IndicatorDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active
            ? AppTheme.primary
            : AppTheme.primary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
