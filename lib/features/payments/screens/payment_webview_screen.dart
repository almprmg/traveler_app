import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?) ?? const {};
    final url = args['url']?.toString() ?? '';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (currentUrl) {
            setState(() => _loading = false);
            _checkResultUrl(currentUrl);
          },
          onNavigationRequest: (req) {
            _checkResultUrl(req.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  void _checkResultUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('paymentsuccess') ||
        lower.contains('payment_success') ||
        lower.contains('success=true')) {
      Get.back(result: 'success');
    } else if (lower.contains('paymentfailure') ||
        lower.contains('payment_failure') ||
        lower.contains('success=false')) {
      Get.back(result: 'failure');
    } else if (lower.contains('paymentcancel') ||
        lower.contains('payment_cancel')) {
      Get.back(result: 'cancel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('payment'.tr),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCancel01,
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () => Get.back(result: 'cancel'),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            Container(
              color: AppTheme.white.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text('loading_payment'.tr, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
