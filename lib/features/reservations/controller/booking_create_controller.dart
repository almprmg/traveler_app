import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:traveler_app/features/payments/model/payment_method_model.dart';
import 'package:traveler_app/features/payments/service/payments_service.dart';
import 'package:traveler_app/features/reservations/service/reservations_service.dart';

class BookingCreateController extends GetxController {
  final ReservationsService _bookingService;
  final PaymentsService _paymentsService;

  BookingCreateController({
    required ReservationsService bookingService,
    required PaymentsService paymentsService,
  })  : _bookingService = bookingService,
        _paymentsService = paymentsService;

  // Form state
  final productType = ''.obs;
  final productId = ''.obs;
  final productTitle = ''.obs;
  final unitPrice = 0.0.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final adultQty = 1.obs;
  final childQty = 0.obs;
  final transportType = Rxn<String>();
  final firstName = ''.obs;
  final lastName = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final address = ''.obs;
  final notes = ''.obs;

  final isSubmitting = false.obs;
  final lastError = Rxn<String>();

  void seedFromArgs() {
    final args = Get.arguments;
    if (args is Map) {
      productType.value = args['product_type']?.toString() ?? '';
      productId.value = args['product_id']?.toString() ?? '';
      productTitle.value = args['product_title']?.toString() ?? '';
      unitPrice.value = (args['unit_price'] as num?)?.toDouble() ?? 0;
      transportType.value = args['transport_type']?.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    seedFromArgs();
  }

  double get total {
    final base = unitPrice.value * adultQty.value;
    final children = unitPrice.value * 0.5 * childQty.value;
    return base + children;
  }

  /// Returns booking id on success or null on failure.
  Future<String?> submit() async {
    if (productId.value.isEmpty || startDate.value == null) {
      lastError.value = 'missing_required_fields'.tr;
      return null;
    }
    if (firstName.value.trim().isEmpty ||
        phone.value.trim().isEmpty ||
        email.value.trim().isEmpty) {
      lastError.value = 'missing_required_fields'.tr;
      return null;
    }

    isSubmitting.value = true;
    lastError.value = null;
    try {
      final fmt = DateFormat('yyyy-MM-dd');
      final result = await _bookingService.createBooking(
        productType: productType.value,
        productId: productId.value,
        startDate: fmt.format(startDate.value!),
        endDate: endDate.value == null ? null : fmt.format(endDate.value!),
        adultQty: adultQty.value,
        childQty: childQty.value > 0 ? childQty.value : null,
        transportType: transportType.value,
        firstName: firstName.value.trim(),
        lastName: lastName.value.trim().isEmpty ? null : lastName.value.trim(),
        phone: phone.value.trim(),
        email: email.value.trim(),
        address: address.value.trim().isEmpty ? null : address.value.trim(),
        notes: notes.value.trim().isEmpty ? null : notes.value.trim(),
      );
      if (result == null) {
        lastError.value = 'booking_failed'.tr;
        return null;
      }
      return result['id']?.toString();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<PaymentInitiation?> startPayment(String orderId, String methodKey) {
    return _paymentsService.initiate(orderId: orderId, methodKey: methodKey);
  }
}
