import 'package:get/get.dart';
import 'package:traveler_app/controllers/auth_controller.dart';
import 'package:traveler_app/features/reservations/model/reservation_model.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';

class ReservationsController extends GetxController {
  final ReservationsService reservationsService;

  ReservationsController({required this.reservationsService});

  final upcoming = <ReservationListItem>[].obs;
  final completed = <ReservationListItem>[].obs;
  final cancelled = <ReservationListItem>[].obs;
  final isLoading = false.obs;
  final selectedTab = 0.obs;

  Future<void> fetchAll() async {
    if (!Get.find<AuthController>().isLoggedIn()) return;
    isLoading.value = true;
    try {
      final results = await Future.wait([
        reservationsService.getBookings(status: 'upcoming'),
        reservationsService.getBookings(status: 'completed'),
        reservationsService.getBookings(status: 'cancelled'),
      ]);
      upcoming.value = results[0];
      completed.value = results[1];
      cancelled.value = results[2];
    } finally {
      isLoading.value = false;
    }
  }

  List<ReservationListItem> get currentList {
    switch (selectedTab.value) {
      case 1:
        return completed;
      case 2:
        return cancelled;
      default:
        return upcoming;
    }
  }
}
