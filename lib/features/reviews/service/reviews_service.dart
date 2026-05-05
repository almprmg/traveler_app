import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';

class ReviewsService extends GetxService {
  final ApiClient apiClient;
  ReviewsService({required this.apiClient});

  /// Returns true on success.
  Future<({bool ok, String? message})> submitReview({
    required String productType,
    required String productId,
    required double rating,
    required String review,
  }) async {
    final response = await apiClient.postData(AppConstants.reviewsUrl, {
      'product_type': productType,
      'product_id': int.tryParse(productId) ?? productId,
      'rating': rating,
      'review': review,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (ok: true, message: null);
    }
    try {
      final body = json.decode(response.body);
      return (ok: false, message: body['message']?.toString());
    } catch (_) {
      return (ok: false, message: null);
    }
  }
}
