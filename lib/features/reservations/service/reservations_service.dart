import 'package:traveler_app/data/api/api_client.dart';
import 'package:get/get.dart';

class ReservationsService extends GetxService {
  final ApiClient apiClient;

  ReservationsService({required this.apiClient});
}
