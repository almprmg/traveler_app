import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_cash_image.dart';
import 'package:traveler_app/base/empty_state.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/app_typography.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    final response =
        await Get.find<ApiClient>().getData(AppConstants.wishlistUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final list = body['data'] as List? ?? [];
      _items = list.cast<Map<String, dynamic>>();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _remove(String type, String id) async {
    await Get.find<ApiClient>()
        .deleteData(AppConstants.wishlistToggleUrl(type, id), null);
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('wishlist'.tr)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(onRefresh: _fetch)
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      final name = item['name'] ?? item['title'] ?? '';
                      final image = item['image_url'] ?? '';
                      final type = item['type'] ?? '';
                      final id = item['id']?.toString() ?? '';
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radius12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radius8),
                              child: AppCachedImage(
                                imageUrl: image,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.h5),
                                  const SizedBox(height: 4),
                                  Text(
                                    type,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.red),
                              onPressed: () => _remove(type, id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
