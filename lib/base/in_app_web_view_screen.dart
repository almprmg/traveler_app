import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

final Set<Factory<OneSequenceGestureRecognizer>> _kWebViewGestures =
    <Factory<OneSequenceGestureRecognizer>>{
      Factory<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer(),
      ),
      Factory<HorizontalDragGestureRecognizer>(
        () => HorizontalDragGestureRecognizer(),
      ),
      Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
      Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
    };

/// Lightweight in-app browser screen with a floating circular close button
/// at the top. Used for opening external promotional / info pages without
/// leaving the app.
class InAppWebViewScreen extends StatefulWidget {
  final String url;

  const InAppWebViewScreen({super.key, required this.url});

  static Future<void> open(String url) {
    return Get.to<void>(
      () => InAppWebViewScreen(url: url),
      transition: Transition.downToUp,
      opaque: true,
    )!;
  }

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (!mounted) return;
            setState(() => _progress = p);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: WebViewWidget(
                controller: _controller,
                gestureRecognizers: _kWebViewGestures,
              ),
            ),
            if (_loading && _progress < 100)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _progress / 100,
                  minHeight: 2,
                  backgroundColor: AppTheme.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primary,
                  ),
                ),
              ),
            PositionedDirectional(
              top: AppTheme.spacing12,
              end: AppTheme.spacing16,
              child: Material(
                color: AppTheme.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Get.back<void>(),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border, width: 1),
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: AppTheme.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
