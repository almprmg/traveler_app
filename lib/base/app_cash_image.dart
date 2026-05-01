import 'package:traveler_app/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/url_handler.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color skeletonBaseColor;
  final Color skeletonHighlightColor;
  final Widget? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.skeletonBaseColor = const Color(0xFFE0E0E0),
    this.skeletonHighlightColor = const Color(0xFFF5F5F5),
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: imageUrl?.endsWith(".svg") == true
          ? SvgPicture.network(imageUrl!, fit: fit)
          : CachedNetworkImage(
              imageUrl: imageUrl != null ? UrlHandler.handleUrl(imageUrl!) : '',
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => _buildSkeletonLoader(),
              errorWidget: (context, url, error) =>
                  errorWidget ?? _buildErrorWidget(),
            ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHighlight,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: AppTheme.background,
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedImage01,
        color: AppTheme.borderMedium,
        size: 24,
      ),
    );
  }
}
