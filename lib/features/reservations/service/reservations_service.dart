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

  Future<bool> cancelBooking(String id) async {
    final response = await apiClient.postData(
        AppConstants.bookingCancelUrl(id), null);
    return response.statusCode == 200;
  }
}
