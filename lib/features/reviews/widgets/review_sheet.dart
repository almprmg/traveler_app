import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:traveler_app/features/reviews/service/reviews_service.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

Future<bool> showReviewSheet(
  BuildContext context, {
  required String productType,
  required String productId,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ReviewSheet(
      productType: productType,
      productId: productId,
    ),
  );
  return result == true;
}

class _ReviewSheet extends StatefulWidget {
  final String productType;
  final String productId;
  const _ReviewSheet({required this.productType, required this.productId});

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  double _rating = 5;
  final _ctrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().isEmpty) {
      setState(() => _error = 'review_required'.tr);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final res = await Get.find<ReviewsService>().submitReview(
      productType: widget.productType,
      productId: widget.productId,
      rating: _rating,
      review: _ctrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (res.ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = res.message ?? 'review_failed'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('write_review'.tr, style: AppTypography.h4),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 1; i <= 5; i++)
                      IconButton(
                        onPressed: () =>
                            setState(() => _rating = i.toDouble()),
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: i <= _rating
                              ? AppTheme.gold
                              : AppTheme.borderMedium,
                          size: 32,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ctrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'review_hint'.tr,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.white,
                        ),
                      )
                    : Text('submit_review'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
