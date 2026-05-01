import 'package:get/get.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';

class ReservationsController extends GetxController {
  final ReservationsService reservationsService;

  ReservationsController({required this.reservationsService});
}
