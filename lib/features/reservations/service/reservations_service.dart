import 'dart:convert';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/features/reservations/model/reservation_model.dart';
import 'package:traveler_app/util/app_constants.dart';

class ReservationsService extends GetxService {
  final ApiClient apiClient;

  ReservationsService({required this.apiClient});

  Future<List<ReservationListItem>> getBookings({String? status}) async {
    final params = <String, String>{};
    if (status != null) params['status'] = status;

    final uri = Uri.parse(AppConstants.bookingsUrl)
        .replace(queryParameters: params.isEmpty ? null : params)
        .toString();

    final response = await apiClient.getData(uri);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final list = body['data'] as List? ?? [];
      return list.map((e) => ReservationListItem.fromJson(e)).toList();
    }
    return [];
  }

  Future<ReservationDetail?> getBookingDetail(String id) async {
    final response =
        await apiClient.getData(AppConstants.bookingDetailUrl(id));
    if (response.statusCode == 200) {
      return ReservationDetail.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<bool> cancelBooking(String id, {String? reason}) async {
    final response = await apiClient.postData(
        AppConstants.bookingCancelUrl(id),
        reason == null ? null : {'reason': reason});
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> createBooking({
    required String productType,
    required String productId,
    required String startDate,
    String? endDate,
    required int adultQty,
    int? childQty,
    String? transportType,
    required String firstName,
    String? lastName,
    required String phone,
    required String email,
    String? address,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'product_type': productType,
      'product_id': int.tryParse(productId) ?? productId,
      'start_date': startDate,
      'adult_qty': adultQty,
      'first_name': firstName,
      'phone': phone,
      'email': email,
    };
    if (endDate != null) body['end_date'] = endDate;
    if (childQty != null) body['child_qty'] = childQty;
    if (transportType != null) body['transport_type'] = transportType;
    if (lastName != null) body['last_name'] = lastName;
    if (address != null) body['address'] = address;
    if (notes != null) body['notes'] = notes;

    final response = await apiClient.postData(AppConstants.bookingsUrl, body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      return decoded['data'] is Map<String, dynamic>
          ? decoded['data'] as Map<String, dynamic>
          : decoded as Map<String, dynamic>;
    }
    return null;
  }

  Future<String?> getInvoiceUrl(String id) async {
    final response = await apiClient.getData(
        '${AppConstants.bookingsUrl}/$id/invoice');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'] ?? body;
      if (data is Map) return data['invoice_url']?.toString();
    }
    return null;
  }
}
